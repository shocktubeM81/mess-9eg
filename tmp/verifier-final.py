from pathlib import Path
import json,re,subprocess
aliases={}
for p in Path('versions').rglob('*.md'):
 old=subprocess.check_output(['git','show','HEAD:'+p.as_posix()]).decode('utf-8-sig'); mapping={}
 for ident,dest in re.findall(r'<a id="([^"]+)"[^>]*data-renvoi="([^"]+)"',old):
  if '#' in dest:mapping[ident]=dest.split('#')[-1]
 aliases[p.as_posix()]=mapping
Path('_data/redirections.json').write_text(json.dumps(aliases,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=Path('_layouts/redirection.html');s=p.read_text(encoding='utf-8-sig').replace('const aliases = {{ site.data.redirections | jsonify }};',"const aliases = {{ site.data.redirections[page.path] | jsonify }} || {};");p.write_text(s,encoding='utf-8')
# Verify the original transcription remains byte-identical to Git.
assert Path('constitution.md').read_bytes()==subprocess.check_output(['git','show','HEAD:constitution.md'])
print('Transcription historique intacte.')

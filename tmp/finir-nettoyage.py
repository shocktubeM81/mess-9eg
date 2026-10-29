from pathlib import Path
import json,re,subprocess
root=Path.cwd()
p=root/'_layouts/default.html';s=p.read_text(encoding='utf-8-sig');a=s.index('    {% if page.doc_code');b=s.index('  </header>',a);s=s[:a]+s[b:];s=s.replace('https://github.com/shocktubeM81/mess-9eg/tree/revision-documents-2026-10-28','https://github.com/shocktubeM81/mess-9eg');p.write_text(s,encoding='utf-8')
p=root/'.github/workflows/documents.yml';s=p.read_text(encoding='utf-8-sig').replace(' --site','').replace('      - name: Vérifier les vues web\n        run: git diff --exit-code -- _includes\n','');p.write_text(s,encoding='utf-8')
aliases={}
for p in (root/'versions').rglob('*.md'):
    old=subprocess.check_output(['git','show','HEAD:'+p.relative_to(root).as_posix()]).decode('utf-8-sig')
    for ident,dest in re.findall(r'<a id="([^"]+)"[^>]*data-renvoi="([^"]+)"',old):
        if '#' in dest:aliases[ident]=dest.split('#')[-1]
(root/'_data/redirections.json').write_text(json.dumps(aliases,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

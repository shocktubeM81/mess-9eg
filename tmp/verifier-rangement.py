from pathlib import Path
import hashlib,json,runpy,subprocess,re
root=Path.cwd()
proof=json.loads((root/'tmp/rangement-empreintes.json').read_text(encoding='utf-8'))
for name in ('textes/texte-maitre.md','textes/archives/constitution.md','textes/structure.json'):
 assert hashlib.sha256((root/name).read_bytes()).hexdigest()==proof[name],name
print('Maître, transcription et identifiants : contenu inchangé.')
for source,target in [('textes/texte-maitre.md','site/_includes/texte-maitre.md'),('textes/structure.json','site/_data/structure.json'),('textes/archives/constitution.md','site/constitution.md')]:
 assert (root/source).read_bytes()==(root/target).read_bytes()
 result=subprocess.run(['git','check-ignore','--quiet',target]);assert result.returncode==0,target
print('Trois entrées Jekyll identiques et ignorées par Git.')
m=runpy.run_path('generateur/generer-documents.py');text=m['read']('textes/texte-maitre.md');structure=json.loads(m['read']('textes/structure.json'));segments,count=m['validate'](text,structure);blocks=m['document_blocks'](text,segments)
original=subprocess.check_output(['git','show','HEAD:outils/generer-documents.py']).decode('utf-8-sig');old={'__file__':str(root/'outils/generer-documents.py'),'__name__':'verification'};exec(compile(original,'ancien-generateur','exec'),old)
oldsegments,oldcount=old['validate'](text,structure);assert blocks==old['document_blocks'](text,oldsegments)
profile=json.loads(m['read']('generateur/modeles/9eg.json'));assert (root/profile['insigne']).is_file();assert (root/'generateur/exporter-pdf.ps1').is_file()
print(f'{count} paragraphes; blocs des exports identiques à ceux de l’ancien générateur; modèle et insigne accessibles.')
for name in ('site/preparer.py','generateur/generer-documents.py'):compile((root/name).read_text(encoding='utf-8-sig'),name,'exec')
try:
 import yaml
 for name in ('.github/workflows/site.yml','.github/workflows/documents.yml','site/_config.yml'):
  assert isinstance(yaml.safe_load((root/name).read_text(encoding='utf-8-sig')),dict)
 print('Configurations YAML lisibles.')
except ImportError:print('Analyseur YAML non installé : validation YAML non exécutée.')
# Check links in current contributor-facing documentation (historic references remain historical).
for name in ('README.md','MODE-EMPLOI.md','CONTRIBUTING.md','documentation/organisation-depot.md','site/README.md','generateur/README.md'):
 p=root/name
 for dest in re.findall(r'\]\(([^)]+)\)',p.read_text(encoding='utf-8-sig')):
  if '://' in dest or dest.startswith('#'):continue
  assert (p.parent/dest.split('#')[0]).exists(), (name,dest)
print('Liens des guides accessibles.')

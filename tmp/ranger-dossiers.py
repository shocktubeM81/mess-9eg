from pathlib import Path
import hashlib,json
root=Path.cwd().resolve()
moves={
 'texte-maitre.md':'textes/texte-maitre.md',
 '_data/structure.json':'textes/structure.json',
 'constitution.md':'textes/archives/constitution.md',
 '_data/redirections.json':'site/_data/redirections.json',
 '_layouts':'site/_layouts', 'assets':'site/assets', 'versions':'site/versions',
 'index.md':'site/index.md', 'reglements.md':'site/reglements.md',
 '_config.yml':'site/_config.yml', 'Gemfile':'site/Gemfile', 'CNAME':'site/CNAME',
 'outils/generer-documents.py':'generateur/generer-documents.py',
 'outils/exporter-pdf.ps1':'generateur/exporter-pdf.ps1',
 'outils/requirements.txt':'generateur/requirements.txt',
 'modeles':'generateur/modeles',
 'Generer-les-documents.ps1':'generateur/Generer-les-documents.ps1',
 'Generer-les-documents.cmd':'generateur/Generer-les-documents.cmd',
}
proof={}
for old,new in moves.items():
 src=(root/old).resolve(); dst=(root/new).resolve()
 assert src.is_relative_to(root) and dst.is_relative_to(root)
 assert src.exists() and not dst.exists(), (src,dst)
 if src.is_file():proof[new]=hashlib.sha256(src.read_bytes()).hexdigest()
for old,new in moves.items():
 src=root/old; dst=root/new; dst.parent.mkdir(parents=True,exist_ok=True);src.rename(dst)
Path('tmp/rangement-empreintes.json').write_text(json.dumps(proof,indent=2),encoding='utf-8')
p=root/'generateur/generer-documents.py';s=p.read_text(encoding='utf-8-sig')
s=s.replace('"""Le maître UTF-8 est la seule entrée des exports et des vues web."""','"""Produire les exports à partir du maître Markdown partagé dans textes/."""')
s=s.replace("ROOT/'texte-maitre.md'","ROOT/'textes/texte-maitre.md'").replace("ROOT/'_data/structure.json'","ROOT/'textes/structure.json'")
s=s.replace("ROOT/'modeles'","ROOT/'generateur/modeles'").replace("ROOT/'outils/exporter-pdf.ps1'","ROOT/'generateur/exporter-pdf.ps1'")
s=s.replace('profil JSON dans modeles','profil JSON dans generateur/modeles')
p.write_text(s,encoding='utf-8')
p=root/'generateur/modeles/9eg.json';data=json.loads(p.read_text(encoding='utf-8-sig'));data['insigne']='generateur/modeles/insigne-genie.png';p.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=root/'generateur/Generer-les-documents.ps1';s=p.read_text(encoding='utf-8-sig').replace("'outils\\generer-documents.py'","'generer-documents.py'");p.write_text(s,encoding='utf-8')
p=root/'generateur/Generer-les-documents.cmd';s=p.read_text(encoding='utf-8-sig').replace('dossier exports.','dossier exports a la racine du depot.');p.write_text(s,encoding='utf-8')
p=root/'site/index.md';s=p.read_text(encoding='utf-8-sig').replace('include_relative texte-maitre.md','include texte-maitre.md');p.write_text(s,encoding='utf-8')
p=root/'site/_config.yml';s=p.read_text(encoding='utf-8-sig');a=s.index('exclude:');b=s.index('plugins:',a);s=s[:a]+'exclude:\n  - README.md\n  - preparer.py\n  - Gemfile\n  - Gemfile.lock\n'+s[b:];p.write_text(s,encoding='utf-8')
p=root/'.github/workflows/documents.yml';s=p.read_text(encoding='utf-8-sig').replace('outils/requirements.txt','generateur/requirements.txt').replace('outils/generer-documents.py','generateur/generer-documents.py');p.write_text(s,encoding='utf-8')
print('Dossiers regroupés; textes déplacés sans révision de leur contenu.')

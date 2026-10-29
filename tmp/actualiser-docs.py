from pathlib import Path
p=Path('MODE-EMPLOI.md');s=p.read_text(encoding='utf-8-sig')
s=s.replace('**texte-maitre.md**','**textes/texte-maitre.md**').replace('**modeles/9eg.json**','**generateur/modeles/9eg.json**').replace('**Generer-les-documents.cmd**','**generateur/Generer-les-documents.cmd**').replace('**_data/structure.json**','**textes/structure.json**')
s=s.replace('outils/requirements.txt','generateur/requirements.txt').replace('outils/generer-documents.py','generateur/generer-documents.py').replace('.\\Generer-les-documents.ps1','.\\generateur\\Generer-les-documents.ps1').replace('dans **modeles**','dans **generateur/modeles**')
a=s.index('## Actualiser le site');b=s.index('## Changer la présentation',a)
s=s[:a]+'''## Actualiser le site

Le site et la génération de fichiers sont séparés. Les pages et les styles
sont dans **site/**; les outils Word/PDF sont dans **generateur/**.
Les deux utilisent **textes/texte-maitre.md** et **textes/structure.json**.

Avant une construction locale du site, depuis la racine :

```powershell
py site/preparer.py
```

Cette préparation copie les entrées partagées à l’identique dans le site;
ces copies sont ignorées par Git. Jekyll affiche ensuite le maître Markdown.
Le sommaire et les renvois numérotés utilisent JavaScript. Le texte reste
lisible sans JavaScript. Voir [les instructions du site](site/README.md)
pour Jekyll et le passage à GitHub Actions pour la publication.
L’option `-Site` du générateur reste acceptée pour compatibilité, sans effet.

'''+s[b:];p.write_text(s,encoding='utf-8')
p=Path('CONTRIBUTING.md');s=p.read_text(encoding='utf-8-sig').replace('`texte-maitre.md`','`textes/texte-maitre.md`').replace('`_data/structure.json`','`textes/structure.json`').replace('`Generer-les-documents.ps1`','`generateur/Generer-les-documents.ps1`').replace('Les pages sous `versions/`','Les pages sous `site/versions/`')
s=s.replace('Le site lit le maître directement.','Le site affiche le même maître après `py site/preparer.py`.')
s += '\nLes changements visuels vont dans `site/`; les changements des exports dans\n`generateur/`. Les deux workflows sont distincts. Voir [site/README.md](site/README.md)\npour la construction et la publication.\n'
p.write_text(s,encoding='utf-8')
# Retarget repository-relative links in historical notes; preserve their wording.
for p in Path('documentation').glob('*.md'):
 if p.name=='organisation-depot.md':continue
 s=p.read_text(encoding='utf-8-sig');updated=s.replace('](../versions/','](../site/versions/').replace('](../constitution.md','](../textes/archives/constitution.md')
 if updated!=s:p.write_text(updated,encoding='utf-8')

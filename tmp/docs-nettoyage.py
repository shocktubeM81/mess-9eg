from pathlib import Path
import re
p=Path('README.md');p.write_text('''# Statuts et règlements du Mess du 9 EG

**Projet à adopter et à approuver.**

Modifier uniquement [texte-maitre.md](texte-maitre.md) pour les dispositions.
Le site affiche directement ce fichier Markdown avec Jekyll. Word, PDF et TXT
sont dérivés du même maître dans `exports/`, ignoré par Git.

- [Mode d’emploi](MODE-EMPLOI.md)
- [Contribuer et enregistrer une adoption](CONTRIBUTING.md)
- [Organisation du dépôt](documentation/organisation-depot.md)
- [Transcription historique à vérifier](constitution.md)
- [Notes de révision](documentation/notes-revision.md)
- [Concordance historique](documentation/concordance.md)

`_data/structure.json` conserve les identifiants stables utilisés par les exports
et les renvois du site. `_layouts/` et `assets/` définissent la présentation.
Les anciennes URL sous `versions/` redirigent vers le document complet;
elles ne contiennent plus de copies des dispositions.

Double-cliquer sur `Generer-les-documents.cmd` pour les exports locaux.
Le workflow GitHub Actions prépare des copies de travail téléchargeables.
Aucune génération ni fusion ne constitue une adoption.
''',encoding='utf-8')
p=Path('MODE-EMPLOI.md');s=p.read_text(encoding='utf-8-sig');a=s.index('## Actualiser aussi le site');b=s.index('## Changer la présentation',a);s=s[:a]+'''## Actualiser le site

Le site lit directement **texte-maitre.md** : aucune copie de texte web à
régénérer ou à commettre. Jekyll convertit le Markdown en HTML à la construction.
Le sommaire et les renvois numérotés utilisent JavaScript et les identifiants
stables de **_data/structure.json**. Le texte reste lisible sans JavaScript.
L’option `-Site` est conservée pour compatibilité, sans génération de vues.
Une modification locale ne publie rien automatiquement sur GitHub.

'''+s[b:];p.write_text(s,encoding='utf-8')
p=Path('CONTRIBUTING.md');s=p.read_text(encoding='utf-8-sig').replace('outils/structure-maitre.json','_data/structure.json').replace('Exécuter `Generer-les-documents.ps1 -Site`; inclure les vues `_includes` régénérées au commit. Garder `exports/` hors de Git.','Exécuter `Generer-les-documents.ps1` pour vérifier les exports. Le site lit le maître directement. Garder `exports/` hors de Git.');p.write_text(s,encoding='utf-8')
for p in Path('versions').rglob('*.md'):
 n=p.stem
 dest='partie-1' if n=='constitution-consolidee' else 'reglement-'+n[1] if re.match(r'R[1-6]-',n) else {'annexe-f':'annexe-e','annexe-g':'annexe-f-regisseur','annexe-h':'annexe-g-serveur'}.get(n,n)
 p.write_text('---\nlayout: redirection\ntitle: Ancien lien du projet\ndestination: '+dest+'\n---\n',encoding='utf-8')
p=Path('documentation/organisation-depot.md');p.write_text('''# Organisation après nettoyage

Le maître `texte-maitre.md` reste inchangé : projet 0.11 non adopté.
`constitution.md` et `documentation/` conservent la transcription et les traces
des révisions. L’original manque pour certifier le texte en vigueur.

## Suppressions et simplification

Les 18 copies Markdown sous `_includes/` ont été supprimées.
`index.md` lit directement le maître avec `include_relative` et `markdownify`.
Les anciennes pages `versions/` et `reglements.md` sont des redirections :
leurs URL sont conservées, sans recopier les dispositions. Les correspondances
historiques de fragments sont dans `_data/redirections.json`.
Le code de génération des copies web a été retiré du générateur Python.

`outils/structure-maitre.json` est déplacé dans `_data/structure.json` pour
partager la même table d’identifiants entre le site Jekyll et les exports.
JavaScript ajoute les ancres des renvois au HTML; sans JavaScript, le texte
reste lisible mais ces renvois et les redirections automatiques sont limités.
Les pages de redirection comportent un lien utilisable sans JavaScript.

## Organisation conservée

- Racine : maître, accueil et lanceurs simples.
- `_layouts/`, `assets/` : présentation du site.
- `_data/` : identifiants et correspondances historiques, sans dispositions.
- `documentation/`, `constitution.md` : historique documentaire.
- `outils/`, `modeles/` : génération Word/PDF et présentation.
- `exports/`, `tmp/` : sorties ignorées par Git.
- `versions/` : compatibilité des anciens liens uniquement.

Le regroupement physique dans `site/` et `textes/` est différé : il imposerait
un changement de configuration Pages sans supprimer davantage de doublons.
Aucun historique Git n’est réécrit; Git conserve les fichiers supprimés.

## Génération et statut

GitHub Actions réutilise le générateur existant pour DOCX, PDF ReportLab, TXT,
empreinte du maître et commit construit. Les copies de travail sont conservées
30 jours; elles ne constituent pas une archive officielle ou une adoption.
Le PDF ReportLab peut avoir une pagination différente de Word. Relire les
exports avant diffusion officielle; l’export Word local reste disponible.
Les dépendances restent définies par plages, sans garantie de reconstruction
strictement identique.

Conserver ce générateur évite une seconde chaîne. Pandoc demanderait un filtre
pour les identifiants, un modèle Word et un moteur PDF, puis une comparaison
des renvois et mises en page avant remplacement.

Après adoption documentée, associer décision, preuves, dates réelles et commit
exact à un tag annoté. Ne pas classer le projet actuel comme approuvé.

Références : [Jekyll include_relative](https://jekyllrb.com/docs/includes/),
[GitHub Actions](https://docs.github.com/en/actions/tutorials/build-and-test-code/python),
[Pandoc](https://pandoc.org/MANUAL.html).
''',encoding='utf-8')

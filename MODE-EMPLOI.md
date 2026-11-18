# Mode d’emploi

## Modifier sur GitHub

1. Ouvrir la branche de travail et le fichier dans [textes/](textes/README.md).
2. Choisir **Edit** et modifier le texte Markdown.
3. Enregistrer le changement dans la branche, puis consulter les contrôles GitHub Actions.

Les statuts sont dans `textes/statuts.md`, les quatre règlements dans `r1.md` à `r4.md` et les fonctions dans les annexes A à G. Le titre et la version se trouvent dans `textes/presentation.md`.

Le gras s’écrit `**texte important**`. Un lien peut aussi être en gras : `[**référence**](https://exemple.ca)`. Les exports Word et PDF conservent ce gras et les liens; le TXT contient le texte lisible sans les marqueurs `**`.

Les numéros et les titres restent ceux reconnus par `textes/structure.json`. En cas de renumérotation, actualiser les renvois et `textes/comparatif.json`. Les annotations du comparatif décrivent les changements par rapport à `textes/archives/constitution.md`, qui est la seule version ancienne conservée.

## Générer les documents

Sous Windows, double-cliquer sur `generateur/Generer-les-documents.cmd` pour produire le recueil Word, PDF et TXT dans `exports/`.

```powershell
py -m pip install -r generateur/requirements.txt
.\generateur\Generer-les-documents.ps1

# Utiliser le moteur PDF autonome
.\generateur\Generer-les-documents.ps1 -PdfMoteur reportlab

# Générer aussi le comparatif Word, PDF et Markdown
py generateur/generer-comparatif.py
```

Le recueil rassemble les statuts, les quatre règlements et les sept annexes. Avec Microsoft Word installé, le PDF peut être exporté depuis le DOCX et la table des matières actualisée. Sinon, ReportLab produit le PDF. Les résultats et leurs empreintes sont consignés dans `exports/`.

Sur GitHub, ouvrir **Actions → Documents de travail**, choisir une exécution réussie et télécharger son artefact. Les fichiers générés ne sont pas conservés parmi les sources du dépôt.

## Prévisualiser le site

Depuis la racine du dépôt, avec Python, Ruby et Bundler installés :

```powershell
py -m pip install -r generateur/requirements.txt
py generateur/generer-comparatif.py
cd site
bundle install
bundle exec jekyll serve
```

Ouvrez <http://localhost:4000>. Les modifications dans **textes/** déclenchent
une reconstruction automatique. La préparation Python n’est plus nécessaire.
Le HTML construit va dans **_site/** à la racine; ne le modifiez pas.
Les anciens liens et le logo sont également gérés à la construction.
Voir [les instructions du site](site/README.md).

Le site est écrit dans `_site/`. Ne pas y modifier les textes. La construction et les vérifications GitHub ne publient pas automatiquement le site; la publication reste manuelle depuis la branche par défaut.

## Présentation et historique

La présentation des exports est définie dans `generateur/modeles/9eg.json`; celle du site se trouve dans `site/`. Les annotations faites dans un Word doivent être reportées dans le fichier source correspondant.

Les anciennes copies de travail ont été retirées du dépôt courant et restent consultables dans l’historique Git. Une génération ou une fusion ne constitue pas une adoption ni une approbation des textes.

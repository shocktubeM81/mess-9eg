# Mode d’emploi

## Modifier un document

Ouvrez le fichier correspondant dans **textes/** : **statuts.md**, **r1.md** à
**r6.md**, une **annexe**, **references.md** ou **avant-propos.md**.
Le titre général et la version se trouvent dans **textes/presentation.md**.
Les fichiers sont en UTF-8, sans balises du site ni mise en page Word.
Conservez les titres reconnus, les numéros et les renvois. L’ordre du recueil
et les identifiants sont définis dans **textes/structure.json**.

Les annotations dans Word sont des propositions : reportez les corrections
retenues dans le Markdown concerné pour les conserver à la prochaine génération.
Le projet reste à adopter et à approuver.

## Générer les Word et PDF

Sous Windows, double-cliquez sur **generateur/Generer-les-documents.cmd**.
Le dossier **exports/** reçoit un seul recueil complet en trois formats :
**statuts-et-reglements.docx**, **statuts-et-reglements.pdf** et
**statuts-et-reglements.txt**.

Le recueil rassemble les statuts, les six règlements et les sept annexes, avec
une couverture, une table des matières, les références cliquables et la pagination.
Les renvois entre les sections restent internes au document.

Avec Microsoft Word installé, le PDF est exporté depuis le DOCX et la table des
matières est actualisée. Sinon, ReportLab produit le PDF; sa pagination peut
différer de Word. Après une génération DOCX seule, actualisez la table dans Word.
**exports/generation.json** consigne les sources, leurs empreintes et le moteur
PDF utilisé pour le recueil.

La génération fonctionne sans GitHub ni connexion Internet. Les références ne
sont pas téléchargées; aucune signature ou date d’adoption n’est ajoutée.

```powershell
# Tout produire et préparer aussi les onglets du site
.\generateur\Generer-les-documents.ps1 -Site

# Produire tous les fichiers sans Microsoft Word
.\generateur\Generer-les-documents.ps1 -PdfMoteur reportlab

# Word et TXT seulement, ou TXT seulement
py generateur/generer-documents.py --docx-seul
py generateur/generer-documents.py --texte-seul
```

## Première installation

Python 3.10 ou plus récent est nécessaire. Sur cet ordinateur, le lanceur utilise
en priorité le Python fourni avec Codex. Sur un autre ordinateur :

```powershell
py -m pip install -r generateur/requirements.txt
```

## Actualiser le site

Depuis la racine, lancez **py site/preparer.py**, puis construisez Jekyll depuis
**site/**. Le site comporte des onglets Statuts, R1 à R6 et Annexes, une page par
document, une page d’accueil et un recueil complet. Les annexes disposent de
leurs propres sous-onglets. Les anciens liens restent accessibles via le recueil.

Les pages de **site/documents/** et les données **site/_data/documents.json** sont
générées et ignorées par Git. Les ancres et les liens entre documents sont préparés
avant la construction; le sommaire latéral utilise JavaScript.
Voir [les instructions du site](site/README.md).

## Changer la présentation

Les marges, la police et l’insigne sont définis dans **generateur/modeles/9eg.json**.
La présentation conserve le format lettre, Times New Roman, la couverture avec
l’insigne et la pagination. Pour choisir un autre profil fourni localement :

```powershell
.\generateur\Generer-les-documents.ps1 -Modele nom-du-profil
```

Le générateur refuse une numérotation discontinue ou un renvoi interne sans
destination. Il ne corrige pas les numéros automatiquement.

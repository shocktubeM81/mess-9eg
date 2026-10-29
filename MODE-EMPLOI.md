# Modifier le texte et produire les documents

## Le fichier à modifier

Ouvrez **textes/texte-maitre.md** dans un éditeur de texte. C’est la version maître de l’ensemble des statuts et règlements. Le fichier est en UTF-8 et contient seulement le texte, les titres, les numéros et les liens. Il ne contient ni HTML, ni balises du site, ni paramètres de mise en page.

Les signes `#` indiquent les titres. Conservez les titres qui commencent par « Références », « Avant-propos », « Partie », « Règlement » et « Annexe » : ils servent à reconnaître les sections. La présentation est définie séparément dans **generateur/modeles/9eg.json**.

Les fichiers Word, PDF et TXT du dossier **exports** sont des copies générées. Pour qu’une correction soit conservée lors de la prochaine génération, faites-la dans le maître, même si vous avez d’abord annoté le Word.

## Générer le Word et le PDF

Sous Windows, double-cliquez sur **generateur/Generer-les-documents.cmd**. Les fichiers suivants sont créés dans **exports** :

- **statuts-et-reglements.docx** : document Word modifiable, avec titres, retraits, liens et pagination;
- **statuts-et-reglements.pdf** : version à imprimer ou à partager;
- **statuts-et-reglements.txt** : copie en texte brut, avec les adresses des références.

Le générateur fonctionne sans GitHub et sans connexion Internet. Les références restent cliquables, mais ne sont pas téléchargées. Aucune signature n’est ajoutée et aucune date d’adoption n’est remplie automatiquement.

Le modèle **9eg** reprend la présentation du document d’août 2024 du Mess du 9e Escadron du génie : format lettre, Times New Roman, couverture centrée avec l’insigne, paragraphes en retrait, en-tête sobre et pagination. L’insigne est repris du document source. Les dates et mentions d’adoption de l’ancien document ne sont pas reprises.

Avec Microsoft Word installé, le PDF est exporté directement depuis le DOCX pour conserver la même pagination. Si Word est indisponible, ReportLab produit un PDF de secours à partir du même maître; sa pagination peut différer. Le fichier **exports/generation.json** indique le moteur utilisé et l’empreinte du maître.

Le Word et le PDF comprennent une table des matières cliquable, placée après la couverture. Elle présente les parties, les rubriques des statuts et de l’avant-propos, les six règlements et les sept annexes, avec les numéros de page. Les renvois internes et les liens vers les références restent cliquables; le PDF comporte aussi des signets de navigation.

Avec Word, la génération actualise la table et enregistre le DOCX avant d’exporter le PDF. Si vous produisez seulement le Word sans exécuter l’export PDF, ouvrez-le dans Word, puis utilisez **Références → Mettre à jour la table → Mettre à jour toute la table**. Faites de même après des retouches manuelles dans Word.

## Première installation sur un autre ordinateur

Python 3.10 ou plus récent est nécessaire. Dans un terminal ouvert dans ce dossier :

```powershell
py -m pip install -r generateur/requirements.txt
```

Puis double-cliquez sur le fichier de génération. Sur cet ordinateur, le lanceur utilise en priorité le Python fourni avec Codex lorsqu’il est présent.

## Actualiser le site

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

## Changer la présentation

Les marges, la police, les titres de couverture et l’insigne sont dans **generateur/modeles/9eg.json**. Modifiez ce fichier pour ajuster la présentation sans toucher au texte. Un autre profil peut être ajouté dans **generateur/modeles**, puis sélectionné avec :

```powershell
.\generateur\Generer-les-documents.ps1 -Modele nom-du-profil
```

Seul le profil **9eg**, établi à partir du document effectivement consulté, est fourni. Le modèle du 35 RGC pourra être ajouté à partir de son document source.

## Commandes utiles

```powershell
# Texte brut seulement, sans Word ni PDF
py generateur/generer-documents.py --texte-seul

# Word seulement, avec la copie en texte brut
py generateur/generer-documents.py --docx-seul

# PDF de secours, sans utiliser Microsoft Word
py generateur/generer-documents.py --pdf-moteur reportlab
```

Le générateur refuse une suite de paragraphes discontinue ou un renvoi interne sans destination, pour éviter un export incomplet. Les nombres d’articles ne sont pas corrigés automatiquement.

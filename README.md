# Statuts et règlements du Mess du 9 EG

**Projet à adopter et à approuver.**

| Dossier | Ce qu’on y trouve |
| --- | --- |
| [textes/](textes/) | Statuts, R1 à R6 et annexes dans des fichiers Markdown distincts |
| [site/](site/) | Le site web : pages, navigation, styles et construction Jekyll |
| [generateur/](generateur/) | Les outils et modèles pour produire Word, PDF et TXT |
| [documentation/](documentation/) | Les notes de révision, concordances et explications |
| `exports/` | Les documents produits, ignorés par Git |

Pour changer les dispositions, modifier le document correspondant dans
[textes/](textes/README.md) : `statuts.md`, `r1.md` à `r6.md`, ou une annexe.
Pour changer l’apparence du site, ouvrir `site/`.
Pour produire les documents sous Windows, double-cliquer sur
[generateur/Generer-les-documents.cmd](generateur/Generer-les-documents.cmd).

Le site lit directement les mêmes fichiers Markdown séparés que le générateur, sans copie intermédiaire.
Le site affiche des onglets et une page par document, avec un recueil complet.
Le générateur assemble ces sources en un seul recueil, exporté en Word, PDF et TXT.
Le site et les documents ont chacun leur workflow GitHub Actions.

- [Mode d’emploi](MODE-EMPLOI.md)
- [Contribuer et enregistrer une adoption](CONTRIBUTING.md)
- [Organisation détaillée](documentation/organisation-depot.md)
- [Transcription historique à vérifier](textes/archives/constitution.md)
- [Notes de révision](documentation/notes-revision.md)
- [Concordance historique](documentation/concordance.md)

La fusion d’un changement ou la génération d’un fichier ne constitue pas une adoption.

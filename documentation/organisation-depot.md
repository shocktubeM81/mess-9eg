# Organisation du dépôt

| Emplacement | Rôle |
| --- | --- |
| `textes/*.md` | Sources Markdown courantes, modifiables sur GitHub |
| `textes/structure.json` | Ordre des documents, titres et signets |
| `textes/comparatif.json` | Annotations du comparatif, par article initial |
| `textes/archives/constitution.md` | Constitution originale conservée |
| `generateur/` | Production du recueil et du comparatif |
| `site/` | Présentation et construction du site |
| `.github/workflows/` | Génération et vérifications automatisées |
| `exports/`, `_site/` | Résultats générés, ignorés par Git |

Le site et les documents lisent les mêmes sources. Il n’existe plus de recueil monolithique concurrent à la racine, ni de maître d’avant la séparation à modifier par erreur.

Le comparatif se reconstruit depuis la constitution originale et `textes/comparatif.json`. Son Markdown, son Word et son PDF vont dans `exports/`; une copie du PDF est préparée pour le site pendant la construction. Aucune de ces copies générées ne fait autorité sur les sources.

Les anciennes URL du site restent des redirections vers les documents courants; elles ne conservent pas d’anciennes versions des dispositions. Les versions antérieures et les notes de travail retirées restent dans l’historique Git.

Voir [les sources](../textes/README.md), le [mode d’emploi](../MODE-EMPLOI.md) et les [règles de contribution](../CONTRIBUTING.md).

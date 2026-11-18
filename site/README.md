# Site web

Le site lit les sources Markdown de `textes/`. Les annotations sont dans `textes/comparatif.json`; la constitution originale est conservée dans `textes/archives/constitution.md`.

## Construire et prévisualiser

Depuis la racine du dépôt :

```powershell
py -m pip install -r generateur/requirements.txt
py generateur/generer-comparatif.py
cd site
bundle install
bundle exec jekyll serve
```

Ouvrir http://localhost:4000. Les modifications des sources Markdown reconstruisent les pages. Après modification des annotations, régénérer le comparatif pour actualiser le PDF téléchargeable. Après modification d’un module Ruby, redémarrer le serveur.

Pour construire sans serveur, remplacer la dernière commande par `bundle exec jekyll build`, puis lancer `py site/verifier.py` depuis la racine.

## Fichiers à modifier

| Contenu | Source |
| --- | --- |
| Dispositions | `textes/*.md` |
| Comparatif | `textes/comparatif.json` |
| Ordre et signets | `textes/structure.json` |
| Accueil | `site/index.md` |
| Présentation | `site/_layouts/` et `site/assets/` |
| Anciennes URL | `site/_data/redirections.json` |

Les anciennes URL redirigent vers les documents courants. Les Word, PDF et pages HTML sont générés; ils ne sont pas des sources à modifier. `_site/`, `exports/` et la copie du PDF préparée dans `site/assets/documents/` sont ignorés par Git.

Le workflow **Site web** génère d’abord le comparatif depuis ses sources, construit Jekyll puis vérifie les liens, les 116 articles initiaux et la fidélité du texte. Il fournit un artefact à consulter. La publication reste manuelle depuis la branche par défaut avec l’option `publier`; l’audience du site n’est pas changée par une simple génération.

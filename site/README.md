# Site web

Ce dossier contient uniquement la présentation du site et ses outils de construction.

- `index.md` affiche le maître Markdown avec Jekyll.
- `_layouts/` contient les mises en page.
- `assets/` contient les styles et la navigation.
- `_data/redirections.json`, `versions/` et `reglements.md` maintiennent les anciens liens.
- `_config.yml`, `Gemfile` et `CNAME` configurent le site.
- `preparer.py` copie les trois entrées partagées depuis `textes/`.

Depuis la racine du dépôt :

```powershell
py site/preparer.py
cd site
bundle install
bundle exec jekyll serve
```

Python prépare seulement les entrées; Ruby/Bundler et les dépendances du Gemfile
sont requis pour Jekyll. Aucun outil de génération Word ou PDF n’est requis.

Ne pas modifier `_includes/texte-maitre.md`, `_data/structure.json` ou
`constitution.md` ici : ces copies ignorées par Git seront remplacées à la
prochaine préparation. Modifier les originaux sous `textes/`.

## GitHub Pages

Le workflow `Site web` construit le dossier `site/` sur les push et demandes de
fusion, puis fournit un artefact pour vérification. Il ne publie pas par défaut.
Pour publier après validation : configurer **Settings → Pages → Source → GitHub
Actions**, puis lancer le workflow manuellement sur la branche par défaut avec
**publier** activé. Les protections de l’environnement `github-pages` s’appliquent.

Les URL publiques restent à la racine (`/`, `/constitution.html`, `/versions/...`),
sans préfixe `/site/`. Le domaine personnalisé reste dans `CNAME`.
Les réglages GitHub Pages ne sont pas changés par ce rangement local.
Avant de fusionner le rangement dans la branche publiée, préparer le passage
à GitHub Actions : la construction historique depuis la racine ne convient plus.

[Documentation officielle Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages).

# Site web

Le site lit directement les fichiers Markdown de `textes/` à chaque construction.
Il ne conserve aucune copie des statuts, règlements, annexes ou de la constitution
historique dans ce dossier. Les exports Word/PDF restent un recueil unique.

## Tester localement

Dans PowerShell :

```powershell
cd "C:\Users\david\OneDrive\Documents\ChatGPT\MESS\site"
bundle install
bundle exec jekyll serve --livereload
```

Ouvrir [le site local](http://localhost:4000). Modifier un fichier dans `textes/`
reconstruit automatiquement ses pages. Aucune préparation Python n’est nécessaire.
Arrêter le serveur avec Ctrl+C. Après une modification de `_config.yml`, relancer
le serveur. Ruby+Devkit et Bundler sont requis sous Windows.

## Fichiers à modifier

- Les dispositions : les fichiers `.md` de `../textes/`.
- L’ordre des documents, leurs titres et les ancres : `../textes/structure.json`.
- L’accueil : `index.md`.
- La présentation : `_layouts/` et `assets/`.
- Le logo original : fichier `insigne` désigné par `../generateur/modeles/9eg.json`.
- Les anciens liens : `_data/redirections.json` et `_layouts/redirection.html`.
- La lecture directe et l’assemblage web : `_plugins/documents.rb`.

Jekyll crée les pages en mémoire puis écrit uniquement le HTML dans `../_site/`,
ignoré par Git. Les onglets, les pages individuelles, le recueil et les anciennes
URL `/versions/...` restent disponibles. Le logo est lu depuis son original et
écrit dans le site construit, sans copie dans `site/assets/`.

La source surveillée est la racine du dépôt pour détecter les changements des
textes; seules les pages sélectionnées et les ressources du site sont publiées.
`verifier.py` contrôle les liens et compare les dispositions avec les exports.

## Construire et vérifier

```powershell
bundle exec jekyll build
cd ..
py site/verifier.py
```

## GitHub Pages

Le workflow `Site web` utilise Ruby et `bundle exec jekyll build` depuis `site/`.
Le module de lecture directe nécessite cette construction personnalisée; ne pas
utiliser le mode Jekyll sécurisé ni la construction Pages historique depuis une
branche. Configurer Pages avec la source **GitHub Actions** pour publier.

La construction et la vérification fournissent un artefact sans publication
automatique. La publication reste manuelle, avec le paramètre **publier** activé
sur la branche par défaut. Le domaine personnalisé reste défini par `CNAME`.

# Organisation du dépôt

Le rangement distingue le contenu de ses deux usages : site web et fichiers.

```text
textes/                         # contenu partagé
  texte-maitre.md                # projet courant non adopté
  structure.json                # identifiants des renvois
  archives/constitution.md       # transcription historique
site/                           # présentation et construction du site
  _layouts/
  assets/
  _data/redirections.json
  versions/                     # anciennes URL uniquement
  index.md
  _config.yml
  preparer.py
  Gemfile
  CNAME
generateur/                     # production Word, PDF et TXT
  modeles/
  generer-documents.py
  exporter-pdf.ps1
  requirements.txt
  Generer-les-documents.cmd
  Generer-les-documents.ps1
documentation/                  # notes et concordances
exports/                        # fichiers produits, ignorés par Git
tmp/                            # fichiers temporaires, ignorés par Git
.github/workflows/
  documents.yml
  site.yml
```

Le maître et la transcription ont été déplacés sans modifier leur contenu.
Les notes de révision sont conservées; seuls les chemins des liens locaux
sont adaptés au rangement. Git conserve les versions antérieures : aucune
réécriture d’historique ni suppression de branche.

## Deux processus indépendants

**Documents** : le générateur lit `textes/`, utilise ses modèles et écrit dans
`exports/`. Il n’a aucune dépendance aux fichiers du site.

**Site** : `site/preparer.py` copie à l’identique le maître, sa table d’identifiants
et la transcription dans les emplacements Jekyll. Ces trois copies sont ignorées
par Git et doivent être régénérées, jamais modifiées. Aucun générateur Word/PDF
ni ses dépendances ne sont nécessaires. Jekyll affiche le Markdown avec
`markdownify`; JavaScript restaure les ancres et le sommaire.

Les URL publiques restent inchangées. Le préfixe `site/` appartient seulement au
rangement du dépôt. Les anciennes pages restent de petites redirections.

## Publication

Le workflow `Site web` construit le site et fournit un artefact pour vérification.
La publication est manuelle, réservée à la branche par défaut, avec l’option
`publier`. Configurer GitHub Pages pour utiliser GitHub Actions avant la mise
en service de ce rangement; les réglages distants ne sont pas changés ici.
Voir [les instructions du site](../site/README.md).

## Statut des textes

Le projet reste non adopté. La transcription mentionne une adoption ancienne,
mais l’original manque pour certifier le texte actuellement en vigueur.
Après adoption documentée, associer décision, justificatifs, dates réelles et
commit exact à un tag annoté. Une génération ne constitue pas une adoption.
Les artefacts Actions de 30 jours sont des copies de travail temporaires.

Le générateur existant est conservé. Un passage à Pandoc demanderait une
migration des identifiants et du modèle, puis une comparaison des exports.

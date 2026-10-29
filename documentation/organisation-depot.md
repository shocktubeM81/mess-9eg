# Organisation après nettoyage

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

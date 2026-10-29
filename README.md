# Mess et Instituts — 9e Escadron du génie

Ce dépôt contient une transcription Markdown de la constitution actuelle, en préparation de modifications futures.

## Structure

- [constitution.md](constitution.md) — transcription non amendée de la constitution du Mess et Instituts.
- [index.md](index.md) — page d'accueil GitHub Pages affichant directement le contenu de `constitution.md`.
- [_config.yml](_config.yml) — paramètres du site Jekyll.
- [CNAME](CNAME) — domaine cible : `mess.9eg.ca`.

## Publication

1. Sur GitHub : **Settings → Pages → Build and deployment → Deploy from a branch**, sélectionner **main** et **/(root)**.
2. Chez le fournisseur DNS de `9eg.ca`, créer un enregistrement **CNAME** : nom `mess`, cible `shocktubem81.github.io`.
3. Sur GitHub Pages : vérifier que **Custom domain** vaut `mess.9eg.ca`, puis activer **Enforce HTTPS** lorsqu'il devient disponible.

## Source et statut

Texte d'origine : *Statuts et règlements du Mess et Instituts du 9e Escadron du génie*, adoptés le 10 septembre 2022, avant-propos daté du 20 août 2024. Le PDF source est un document numérisé de 20 pages, sans couche de texte. Les 116 articles sont présents. La transcription est à relire contre le PDF original avant publication officielle, notamment pour vérifier les libellés et les renvois.

Les changements GitHub ne constituent pas à eux seuls une ratification ou une approbation de modifications aux statuts ou règlements.

## Proposition de révision du 28 octobre 2026

La version 0.2 est préparée sur la branche `revision-documents-2026-10-28`.

- [Dossier de révision et accès aux livrables](versions/2026-10-28-v0.2/index.md)
- [Sources et validations avant adoption](versions/2026-10-28-v0.2/notes-revision.md)
- [Concordance des 116 articles](versions/2026-10-28-v0.2/concordance.md)

La transcription actuelle et la présentation web de la page d’accueil sont conservées. Cette proposition n’est pas un texte adopté. Le dossier contient le tableau des seules modifications, quatre propositions distinctes, les deux textes intégraux consolidés et une courte lettre de présentation. Les fichiers restent au format Markdown natif du dépôt pour conserver leur lecture sur GitHub et leur présentation avec le thème existant.

Le script `build_revision.ps1` produit les documents à partir de la transcription conservée. Il ne modifie pas celle-ci. Les métadonnées de page appliquent le thème existant aux nouvelles pages; les textes sont également lisibles directement sur GitHub.

## Présentation reprise de la branche proposition amendements

La branche de révision reprend le gabarit, les styles et le sommaire de `proposition-amendements`. Son accueil présente la lettre et les livrables de la version 0.2. La navigation vise les quatre règlements et les textes révisés. Cette mise à jour de présentation remplace la mention précédente de conservation de la page d’accueil sur cette branche. La transcription originale, les branches `main` et `proposition-amendements`, ainsi que les paramètres de publication restent inchangés.

## Ajustement de la version 0.2.1

Les principes des assemblées figurent dans la constitution; leur procédure et leur déroulement sont précisés au R3, distinct de la constitution. Le dossier daté conserve son adresse pour préserver les liens existants. Les documents affichent la version 0.2.1 du 28 octobre 2026.

## Ajustement de la version 0.2.2

R3 porte le titre « Assemblées et réunions » et précise comment les séances se préparent, se déroulent et sont documentées et communiquées. R4 est limité au « Service de bar », avec refus de service obligatoire en cas d’ébriété. Les règles financières et les réservations sont regroupées dans la constitution; les dispositions sur les locaux et les jeux sont réaffectées selon la concordance.

## Organisation de la version 0.2.4

Les quatre règlements ont chacun une numérotation continue et un ordre par sujet. Les tâches restent à la fin. La constitution garde son ordre et ses numéros. La concordance indique les nouveaux repères. `reorganize_regulations.ps1`, appelé par le générateur, prépare cette organisation sans modifier le fond des dispositions.

## Version 0.2.5

La page [Règlements](versions/2026-10-28-v0.2/reglements.md) présente quatre documents autonomes, chacun précédé d’une courte introduction. Le R2 est intitulé « Meubles et décorations ». Les répétitions constitutionnelles sur les délais et les titulaires de fonctions sont remplacées par des renvois; les modalités pratiques restent dans les règlements. Le recueil est conservé comme document complémentaire.

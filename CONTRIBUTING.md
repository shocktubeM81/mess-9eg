# Contribuer

Le maître courant est un **projet à adopter et à approuver**. Une fusion ou une génération ne constitue pas une adoption.

1. Créer une branche `codex/description-courte` depuis la base convenue.
2. Modifier `textes/texte-maitre.md` pour les dispositions; conserver titres et numéros reconnus. Adapter `textes/structure.json` si la structure change.
3. Décrire dans la demande de fusion les dispositions touchées, le motif, l’effet et les validations attendues. Compléter la concordance pour renumérotations et changements de fond.
4. Exécuter `generateur/Generer-les-documents.ps1` pour vérifier les exports. Le site affiche le même maître après `py site/preparer.py`. Garder `exports/` hors de Git.
5. Relire le diff et les exports : références, renvois, numéros, montants et dates. Actions fournit les copies après une exécution réussie.
6. Faire relire avant fusion. Séparer présentation du site et modifications de fond dans des commits ou demandes distincts.

Les annotations Word sont des propositions : reporter les corrections retenues dans le maître. Les pages sous `site/versions/` ne sont pas des sources indépendantes.

## Adoption

Après réception des preuves requises, consigner décision, dates réelles d’adoption, d’approbation et d’entrée en vigueur, dispositions concernées et références des justificatifs. Lier la décision au commit exact approuvé, vérifier ses exports puis créer un tag annoté, par exemple `adopte-AAAA-MM-JJ-v1`. Le tag est un repère; la preuve reste la décision. Préserver cet instantané et préparer les amendements suivants sur une branche de projet.

Le site public doit distinguer texte en vigueur et projet consultable. La transcription ancienne attend sa vérification contre l’original; ne pas la certifier sur la seule base de ses dates.

Voir [l’examen et la structure cible](documentation/organisation-depot.md) et le [mode d’emploi](MODE-EMPLOI.md).

Les changements visuels vont dans `site/`; les changements des exports dans
`generateur/`. Les deux workflows sont distincts. Voir [site/README.md](site/README.md)
pour la construction et la publication.

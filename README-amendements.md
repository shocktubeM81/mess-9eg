# Branche de travail : proposition-amendements

La branche `main` conserve la constitution publiée. La branche `archive/constitution-avant-amendements-2026-10-27` conserve un instantané de référence.

- `constitution.md` : transcription originale **à ne pas modifier** dans ce processus.
- `proposition-modifications.md` : copie intégrale sur laquelle insérer les amendements directement dans le texte.
- `comparaison.md` : légende et accès au texte comparatif.
- `assets/css/style.scss` : présentation des ajouts et suppressions.

Exemple, au milieu d'un paragraphe :

```md
Le comité <del class="suppression">devrait</del> <ins class="ajout">doit</ins> se réunir.
```

Pour vérifier les changements, comparer le fichier `proposition-modifications.md` aux archives de `constitution.md`. Ne fusionner cette branche vers `main` qu'après les approbations requises et la révision complète de la transcription.

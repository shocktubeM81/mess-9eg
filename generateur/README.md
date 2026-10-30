# Générateur de fichiers

Tout ce qui produit les fichiers Word, PDF et TXT est regroupé ici.
Le contenu provient des fichiers Markdown séparés de `../textes/`; les résultats vont dans
`../exports/`, quel que soit le dossier depuis lequel on lance la commande.

- `Generer-les-documents.cmd` : double-clic sous Windows.
- `Generer-les-documents.ps1` : lanceur PowerShell.
- `generer-documents.py` : validation du maître et génération.
- `exporter-pdf.ps1` : export PDF avec Microsoft Word si disponible.
- `requirements.txt` : dépendances Python.
- `sources.py` : lecture des fichiers et assemblage dans l’ordre de `textes/structure.json`.
- `modeles/` : présentation et insigne.

Le logo du 9 EG est `modeles/Logo 34RGC Det Rouyn.png`, désigné par le champ
`insigne` du profil `9eg.json`. Jekyll lit directement le même fichier lors de la construction du site.

Depuis la racine :

```powershell
py -m pip install -r generateur/requirements.txt
.\generateur\Generer-les-documents.ps1
```

Le site web n’est pas nécessaire pour produire les fichiers.
Le double-clic assemble les sources en un seul recueil : `statuts-et-reglements.docx`,
`statuts-et-reglements.pdf` et `statuts-et-reglements.txt`.

```powershell
.\generateur\Generer-les-documents.ps1 -PdfMoteur reportlab
```

Les renvois entre statuts, règlements et annexes restent internes au recueil.
Voir le [mode d’emploi complet](../MODE-EMPLOI.md).

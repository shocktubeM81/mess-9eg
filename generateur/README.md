# Générateur de fichiers

Tout ce qui produit les fichiers Word, PDF et TXT est regroupé ici.
Le contenu provient de `../textes/texte-maitre.md`; les résultats vont dans
`../exports/`, quel que soit le dossier depuis lequel on lance la commande.

- `Generer-les-documents.cmd` : double-clic sous Windows.
- `Generer-les-documents.ps1` : lanceur PowerShell.
- `generer-documents.py` : validation du maître et génération.
- `exporter-pdf.ps1` : export PDF avec Microsoft Word si disponible.
- `requirements.txt` : dépendances Python.
- `modeles/` : présentation et insigne.

Depuis la racine :

```powershell
py -m pip install -r generateur/requirements.txt
.\generateur\Generer-les-documents.ps1
```

Le site web n’est pas nécessaire pour produire les fichiers.
Voir le [mode d’emploi complet](../MODE-EMPLOI.md).

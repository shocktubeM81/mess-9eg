# Générateur de documents

Les sources modifiables se trouvent dans [textes/](../textes/README.md). Le recueil et le comparatif sont générés dans `exports/`, sans modifier leurs sources.

| Outil | Rôle |
| --- | --- |
| `Generer-les-documents.cmd` / `.ps1` | Générer le recueil sous Windows |
| `generer-documents.py` | Recueil unique Word, PDF et TXT |
| `generer-comparatif.py` | Comparatif Word, PDF et Markdown |
| `markdown_inline.py` | Gras Markdown et liens dans les exports |
| `sources.py` | Assemblage déclaré dans `textes/structure.json` |
| `modeles/9eg.json` | Présentation et insigne |

```powershell
py -m pip install -r generateur/requirements.txt
.\generateur\Generer-les-documents.ps1 -PdfMoteur reportlab
py generateur/generer-comparatif.py
py -m unittest discover -s generateur -p 'test_*.py'
```

`**texte**` devient du gras dans Word et PDF. Le gras peut entourer un lien ou ne porter que sur son libellé. Les astérisques échappés et les marqueurs sans fermeture restent du texte littéral. Le TXT retire la mise en forme et conserve les destinations externes des liens.

Le comparatif lit `textes/comparatif.json` et `textes/archives/constitution.md`; sa génération vérifie la conservation intégrale des 116 articles initiaux. Le PDF destiné au site est recréé automatiquement par GitHub Actions.

Voir le [mode d’emploi](../MODE-EMPLOI.md).

Les articles numérotés ont un retrait suspendu : numéro à 0 cm et texte à 1,1 cm. Les alinéas `- a.`, `- b.`, etc. sont davantage décalés : lettre à 1,1 cm et texte à 1,8 cm. Les lignes suivantes restent alignées sur le texte de l’alinéa. Ces retraits s’appliquent au recueil Word et PDF.

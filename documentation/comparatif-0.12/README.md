# Comparatif de la constitution initiale avec la version 0.12

`constitution-initiale-annotee.md` contient le texte intégral de
`textes/archives/constitution.md`, dans son ordre et sa numérotation d’origine,
avec des annotations distinctes après chacun des 116 articles. Les préliminaires
et les ajouts sont également commentés. Les 177 annotations décrivent les
modifications, regroupements, déplacements et passages non repris, sans motifs.

`annotations.json` est la source des annotations. Les références `[[S:9.5]]`,
`[[R4:4.2]]`, `[[A:1.1]]` et `[[AP:1.2]]` désignent respectivement les statuts,
un règlement, une annexe et l’avant-propos de la version comparée.

Depuis la racine du dépôt, avec les dépendances du générateur installées :

```powershell
py generateur/generer-comparatif.py
```

Le générateur produit le Markdown annoté et les fichiers PDF et Word dans
`exports/comparatif-constitution-0.12/`. Il vérifie la couverture des 116 articles,
les destinations des renvois et la reconstruction à l’identique du texte initial
en retirant les annotations. `verification.json` contient les empreintes des
sources utilisées. Les annotations correspondent à la version 0.12 et doivent
être révisées si les textes courants changent.

Le PDF a fait l’objet d’un contrôle visuel et d’une vérification de présence et
d’ordre des 331 blocs du texte initial. Le Word est une sortie de travail dont
la pagination reste à contrôler dans Word; le PDF est le document de lecture
vérifié. La pagination du comparatif diffère de celle de la constitution initiale.

Le site lit `annotations.json` et la constitution initiale directement pour
construire l’onglet Comparatif; aucun export Python n’est requis pour son texte.
Le PDF est copié vers `site/assets/documents/` par le générateur pour permettre
son téléchargement. Les annotations restent distinctes du recueil normatif.
La constitution initiale et les textes proposés ne sont pas modifiés.

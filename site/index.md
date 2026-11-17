---
layout: default
permalink: /
title: Projet de modification à la constitution du Mess du 9 EG
document_label: Projet de modification à la constitution
---

**Statuts et règlements proposés**

Ce projet présente les modifications proposées à la constitution du Mess, soit ses statuts et règlements. Il est soumis à l’adoption de l’assemblée générale et à l’approbation du commandant.

**Ce document de travail ne remplace pas les textes en vigueur.** Les modifications entreront en vigueur après leur adoption et leur approbation, selon les modalités prévues aux statuts.

Consultez les textes proposés avec les onglets ci-dessus ou dans le recueil complet.

## Statuts et règlements

{% for doc in site.data.documents %}
{% unless doc.id contains 'annexe-' %}
- [{{ doc.titre }}]({{ doc.url | relative_url }})
{% endunless %}
{% endfor %}

## Annexes des responsabilités

{% for doc in site.data.documents %}
{% if doc.id contains 'annexe-' %}
- [{{ doc.titre }}]({{ doc.url | relative_url }})
{% endif %}
{% endfor %}

## Autres consultations

- [Comparatif avec la constitution initiale]({{ '/comparatif.html' | relative_url }}) — texte intégral annoté et PDF.
- [Recueil complet]({{ '/recueil.html' | relative_url }})
- [Texte original transcrit]({{ '/constitution.html' | relative_url }})

<script>
if (location.hash) location.replace({{ '/recueil.html' | relative_url | jsonify }} + location.hash);
</script>

---
layout: default
permalink: /
title: Statuts et règlements du Mess du 9 EG
document_label: Statuts et règlements
---

# Documents du Mess du 9 EG

Projet à adopter et à approuver. Chaque document se consulte séparément avec les onglets ci-dessus.

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

- [Recueil complet]({{ '/recueil.html' | relative_url }})
- [Texte original transcrit]({{ '/constitution.html' | relative_url }})

<script>
if (location.hash) location.replace({{ '/recueil.html' | relative_url | jsonify }} + location.hash);
</script>

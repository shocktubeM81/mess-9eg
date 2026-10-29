---
layout: default
title: Statuts et règlements du Mess du 9 EG
document_label: Statuts et règlements
---

{% capture maitre %}{% include_relative texte-maitre.md %}{% endcapture %}
{{ maitre | markdownify }}
<script type="application/json" id="structure-texte">{{ site.data.structure | jsonify }}</script>

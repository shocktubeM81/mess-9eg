from pathlib import Path
import json,re
root=Path.cwd()
structure=json.loads((root/'outils/structure-maitre.json').read_text(encoding='utf-8-sig'))
(root/'_data/structure.json').write_text(json.dumps(structure,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(root/'outils/structure-maitre.json').unlink()
(root/'index.md').write_text('''---
layout: default
title: Statuts et règlements du Mess du 9 EG
document_label: Statuts et règlements
---

{% capture maitre %}{% include_relative texte-maitre.md %}{% endcapture %}
{{ maitre | markdownify }}
<script type="application/json" id="structure-texte">{{ site.data.structure | jsonify }}</script>
''',encoding='utf-8')
p=root/'outils/generer-documents.py'
s=p.read_text(encoding='utf-8-sig')
a=s.index('def local_heading('); b=s.index('def bookmark_name(')
s=s[:a]+s[b:]
s=s.replace("ROOT/'outils/structure-maitre.json'","ROOT/'_data/structure.json'")
s=s.replace("help='Actualiser aussi les vues du site à partir du maître'","help='Compatibilité : le site lit désormais le maître directement'")
s=s.replace('    if args.site:write_site(segments)\n','')
s=s.replace("print('Copie TXT créée; vues web actualisées.' if args.site else 'Copie TXT créée.');return","print('Copie TXT créée. Le site lit directement le maître.');return")
p.write_text(s,encoding='utf-8')
# Keep existing URLs as redirects, preserving their fragment identifiers.
for p in (root/'versions').rglob('*.md'):
    p.write_text('---\nlayout: redirection\ntitle: Ancien lien du projet\n---\n',encoding='utf-8')
(root/'reglements.md').write_text('---\nlayout: redirection\ntitle: Règlements\ndestination: reglement-1\n---\n',encoding='utf-8')
for p in (root/'_includes').rglob('*.md'):p.unlink()
# Remove empty includes directories only.
for p in sorted((root/'_includes').rglob('*'),reverse=True):
    if p.is_dir() and not any(p.iterdir()):p.rmdir()
if not any((root/'_includes').iterdir()):(root/'_includes').rmdir()
p=root/'_layouts/default.html';s=p.read_text(encoding='utf-8-sig')
a=s.index('    {% if page.doc_code');b=s.index('  </header>',a)
s=s[:a]+s[b:]
s=s.replace('https://github.com/shocktubeM81/mess-9eg/tree/revision-documents-2026-10-28','https://github.com/shocktubeM81/mess-9eg')
p.write_text(s,encoding='utf-8')
p=root/'.github/workflows/documents.yml';s=p.read_text(encoding='utf-8-sig').replace(' --site','')
s=s.replace('      - name: Vérifier les vues web\n        run: git diff --exit-code -- _includes\n','')
p.write_text(s,encoding='utf-8')

from pathlib import Path
p=Path('outils/generer-documents.py');s=p.read_text();s=s.replace('def bookmark_name(value):', '''def local_heading(line, shift):
    m=re.match(r'^(#+) (.+)',line)
    return '#'*max(1,len(m[1])-shift)+' '+m[2] if m else line

def bookmark_name(value):''');p.write_text(s,encoding='utf-8')
# Simulated top-level Markdown nodes for the anchor portion of site.js.
import json,re
text=Path('texte-maitre.md').read_text(encoding='utf-8-sig');nodes=[]
for block in re.split(r'\n\s*\n',text):
 line=block.strip()
 h=re.match(r'^(#{1,6}) (.+)',line)
 label=h[2] if h else line
 label=re.sub(r'\[([^]]+)\]\([^)]+\)',r'\1',label).replace('**','')
 nodes.append({'tagName':'H'+str(len(h[1])) if h else 'P','textContent':label})
Path('tmp/anchor-input.json').write_text(json.dumps(nodes),encoding='utf-8')

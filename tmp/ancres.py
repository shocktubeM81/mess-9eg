from pathlib import Path
p=Path('assets/js/site.js');s=p.read_text(encoding='utf-8-sig')
insert='''  // Le HTML provient directement du maître; cette table conserve les renvois stables.
  const structureNode = document.getElementById("structure-texte");
  if (structureNode) {
    const specs = JSON.parse(structureNode.textContent).segments;
    const article = document.getElementById("document");
    let spec = null;
    const anchor = (id, target) => {
      if (!document.getElementById(id)) {
        const node = document.createElement("a"); node.id = id; target.before(node);
      }
    };
    const finish = target => {
      if (spec) for (const id of spec.tail_anchors || []) anchor(id, target);
    };
    for (const node of Array.from(article.children)) {
      const text = node.textContent.trim();
      const heading = /^H[1-6]$/.test(node.tagName);
      const next = heading && specs.find(item => item.marker.replace(/^#+\\s*/, "") === text);
      if (next) { finish(node); spec = next; }
      if (heading && text === "Partie II — Règlements") anchor("partie-2", node);
      if (next && next.source === "textes/statuts.md") anchor("partie-1", node);
      if (next && /^textes\\/r[1-6]\\.md$/.test(next.source)) anchor("reglement-" + next.source.match(/r([1-6])/)[1], node);
      if (next && next.source.startsWith("textes/annexe-")) anchor(next.source.split("/").pop().replace(".md", ""), node);
      if (!spec) continue;
      const num = text.match(/^(\\d+)\\.\\s/);
      const para = text.match(/^(\\d+\\.\\d+)\\.\\s/);
      const key = heading ? "H:" + (num ? num[1] : text) : para ? "P:" + para[1] : null;
      for (const id of spec.anchors[key] || []) anchor(id, node);
    }
    const end = document.createElement("span"); article.appendChild(end); finish(end);
    // Le navigateur a pu chercher le fragment avant la création des ancres.
    try { document.getElementById(decodeURIComponent(location.hash.slice(1)))?.scrollIntoView(); } catch {}
  }
'''
s=s.replace('  const followOldReference',insert+'  const followOldReference',1);p.write_text(s,encoding='utf-8')

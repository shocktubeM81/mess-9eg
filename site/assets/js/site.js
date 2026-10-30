(() => {
  "use strict";
  // Le HTML provient directement du maître; cette table conserve les renvois stables.
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
      const next = heading && specs.find(item => item.marker.replace(/^#+\s*/, "") === text);
      if (next) { finish(node); spec = next; }
      if (heading && text === "Partie II — Règlements") anchor("partie-2", node);
      if (next && next.source === "textes/statuts.md") anchor("partie-1", node);
      if (next && /^textes\/r[1-6]\.md$/.test(next.source)) anchor("reglement-" + next.source.match(/r([1-6])/)[1], node);
      if (next && next.source.startsWith("textes/annexe-")) anchor(next.source.split("/").pop().replace(".md", ""), node);
      if (!spec) continue;
      const num = text.match(/^(\d+)\.\s/);
      const para = text.match(/^(\d+\.\d+)\.\s/);
      const key = heading ? "H:" + (num ? num[1] : text) : para ? "P:" + para[1] : null;
      for (const id of spec.anchors[key] || []) anchor(id, node);
    }
    const end = document.createElement("span"); article.appendChild(end); finish(end);
    // Le navigateur a pu chercher le fragment avant la création des ancres.
    try { document.getElementById(decodeURIComponent(location.hash.slice(1)))?.scrollIntoView(); } catch {}
  }
  const followOldReference = () => {
    let id;
    try { id = decodeURIComponent(window.location.hash.slice(1)); } catch { return; }
    const target = id && document.getElementById(id);
    const redirect = target && target.getAttribute("data-renvoi");
    if (!redirect) return;
    const destination = new URL(redirect.replace(/\.md(?=#|$)/, ".html"), document.baseURI);
    if (destination.href !== window.location.href) window.location.replace(destination.href);
  };
  window.addEventListener("hashchange", followOldReference);
  followOldReference();
  const content = document.getElementById("document");
  const toc = document.getElementById("table-of-contents");
  const sidebar = document.getElementById("sidebar");
  const toggle = document.getElementById("toc-toggle");
  const printButton = document.getElementById("print-document");
  document.documentElement.classList.add("js-ready");
  if (printButton) {
    printButton.hidden = false;
    printButton.addEventListener("click", () => window.print());
  }
  if (content && toc) {
    for (const paragraph of content.querySelectorAll(":scope > p")) {
      if (/^Version\s+\d/.test(paragraph.textContent.trim())) paragraph.classList.add("document-version");
    }
    const headings = Array.from(content.querySelectorAll("h2, h3"));
    const usedIds = new Set(Array.from(document.querySelectorAll("[id]"), node => node.id));
    const links = new Map();
    toc.replaceChildren();
    headings.forEach((heading, index) => {
      if (!heading.id) {
        const base = heading.textContent.trim().normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "") || "section";
        let id = base;
        let suffix = 1;
        while (usedIds.has(id)) id = base + "-" + (++suffix);
        heading.id = id;
        usedIds.add(id);
      }
      const link = document.createElement("a");
      link.href = "#" + heading.id;
      link.textContent = heading.textContent.trim();
      if (heading.tagName === "H3") link.classList.add("toc-subsection");
      toc.appendChild(link);
      links.set(heading.id, link);
    });
    if (!headings.length) {
      const note = document.createElement("span");
      note.className = "sidebar-placeholder";
      note.textContent = "Ce document ne comporte pas de sous-sections.";
      toc.appendChild(note);
    }
    if (toggle && headings.length) toggle.hidden = false;
    const activate = id => {
      for (const [target, link] of links) {
        const active = target === id;
        link.classList.toggle("active", active);
        if (active) link.setAttribute("aria-current", "location");
        else link.removeAttribute("aria-current");
      }
    };
    let pending = false;
    const update = () => {
      const passed = headings.filter(heading => heading.getBoundingClientRect().top <= 110);
      if (headings.length) activate((passed.at(-1) || headings[0]).id);
      const available = document.documentElement.scrollHeight - window.innerHeight;
      const progress = document.getElementById("reading-progress");
      if (progress) progress.style.width = (available > 0 ? Math.min(100, Math.max(0, window.scrollY / available * 100)) : 100) + "%";
      pending = false;
    };
    const schedule = () => { if (!pending) { pending = true; requestAnimationFrame(update); } };
    window.addEventListener("scroll", schedule, { passive: true });
    window.addEventListener("resize", schedule, { passive: true });
    window.addEventListener("load", schedule);
    update();
    for (const table of content.querySelectorAll("table")) {
      const wrapper = document.createElement("div");
      wrapper.className = "table-scroll";
      wrapper.tabIndex = 0;
      wrapper.setAttribute("role", "region");
      wrapper.setAttribute("aria-label", "Tableau du document, défilement horizontal disponible");
      table.before(wrapper);
      wrapper.appendChild(table);
    }
    // Les liens Markdown restent lisibles sur GitHub et mènent aux pages HTML du site.
    for (const link of content.querySelectorAll("a[href]")) {
      const href = link.getAttribute("href");
      if (!/^(?:[a-z]+:|\/\/)/i.test(href)) link.setAttribute("href", href.replace(/\.md(?=#|$)/, ".html"));
    }
  }
  if (toggle && sidebar) {
    const close = (returnFocus = false) => {
      sidebar.classList.remove("is-open");
      toggle.setAttribute("aria-expanded", "false");
      if (returnFocus) toggle.focus();
    };
    toggle.addEventListener("click", () => {
      const open = sidebar.classList.toggle("is-open");
      toggle.setAttribute("aria-expanded", String(open));
      if (open) sidebar.querySelector("a")?.focus();
    });
    sidebar.addEventListener("click", event => {
      if (event.target.closest("a")) close();
    });
    document.addEventListener("keydown", event => {
      if (event.key === "Escape" && sidebar.classList.contains("is-open")) close(true);
    });
    document.addEventListener("click", event => {
      if (!sidebar.contains(event.target) && !toggle.contains(event.target)) close();
    });
  }
})();

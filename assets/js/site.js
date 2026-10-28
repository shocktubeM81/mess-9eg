(() => {
  "use strict";
  const documentContent = document.getElementById("document");
  const toc = document.getElementById("table-of-contents");
  if (documentContent && toc) {
    const headings = [...documentContent.querySelectorAll("h2, h3")];
    toc.replaceChildren();
    headings.forEach((heading, index) => {
      if (!heading.id) heading.id = "section-" + (index + 1);
      const item = document.createElement("a");
      item.href = "#" + heading.id;
      item.textContent = heading.textContent.trim();
      if (heading.tagName === "H3") item.style.paddingLeft = "1.45rem";
      toc.appendChild(item);
    });
    if (!headings.length) {
      const fallback = document.createElement("span");
      fallback.className = "sidebar-placeholder";
      fallback.textContent = "Aucune section disponible";
      toc.appendChild(fallback);
    }
    if ("IntersectionObserver" in window && headings.length) {
      const observer = new IntersectionObserver(entries => {
        for (const entry of entries) {
          if (!entry.isIntersecting) continue;
          for (const link of toc.querySelectorAll("a")) {
            const active = link.getAttribute("href") === "#" + entry.target.id;
            link.classList.toggle("active", active);
            if (active) link.setAttribute("aria-current", "location");
            else link.removeAttribute("aria-current");
          }
        }
      }, { rootMargin: "-12% 0px -73% 0px" });
      headings.forEach(heading => observer.observe(heading));
    }
  }
  const toggle = document.getElementById("toc-toggle");
  const sidebar = document.getElementById("sidebar");
  if (toggle && sidebar) {
    toggle.addEventListener("click", () => {
      const open = sidebar.classList.toggle("is-open");
      toggle.setAttribute("aria-expanded", String(open));
    });
    sidebar.addEventListener("click", event => {
      if (event.target.closest("a")) {
        sidebar.classList.remove("is-open");
        toggle.setAttribute("aria-expanded", "false");
      }
    });
  }
  const progress = document.getElementById("reading-progress");
  if (progress) {
    let pending = false;
    const update = () => {
      const available = document.documentElement.scrollHeight - window.innerHeight;
      progress.style.width = (available > 0 ? Math.min(100, window.scrollY / available * 100) : 100) + "%";
      pending = false;
    };
    window.addEventListener("scroll", () => {
      if (!pending) {
        pending = true;
        requestAnimationFrame(update);
      }
    }, { passive: true });
    update();
  }
})();

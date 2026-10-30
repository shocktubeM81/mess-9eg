"""Préparer des pages distinctes et le recueil depuis les sources de Word/PDF."""
from pathlib import Path
import json
import runpy
import shutil
import sys

ROOT = Path(__file__).resolve().parents[1]
SITE = ROOT / 'site'
sys.path.insert(0, str(ROOT / 'generateur'))
from sources import load_sources


def prepare():
    profile = json.loads((ROOT / 'generateur/modeles/9eg.json').read_text(encoding='utf-8'))
    logo = ROOT / profile['insigne']
    if not logo.is_file():
        raise FileNotFoundError('Logo du 9 EG absent : ' + str(logo))
    gen = runpy.run_path(str(ROOT / 'generateur/generer-documents.py'))
    text, structure, _ = load_sources()
    segments, count = gen['validate'](text, structure)
    blocks = gen['document_blocks'](text, segments)
    jobs = gen['document_jobs'](text, segments, blocks)
    owners = {ident: '/' + name + '.html' for name, _, items in jobs for b in items for ident in b['ids']}
    pages = SITE / 'documents'
    pages.mkdir(exist_ok=True)
    def write_page(name, title, content):
        # Éviter que les identifiants automatiques des titres doublent les ancres stables.
        content = '\n'.join(line + ' {#titre-' + name + '-' + str(i) + '}'
                            if line.startswith('#') else line
                            for i, line in enumerate(content.splitlines())) + '\n'
        front = '\n'.join(['---', 'layout: default', 'title: ' + json.dumps(title, ensure_ascii=False),
                           'document_label: ' + json.dumps(title, ensure_ascii=False),
                           'permalink: /' + name + '.html', '---', ''])
        (pages / (name + '.md')).write_text(front + '\n' + content, encoding='utf-8')
    for name, title, items in jobs:
        lines = []
        for block in items:
            lines.extend('<a id="' + ident + '"></a>\n' for ident in block['ids'])
            def replace(match):
                href = match[2]
                target = owners.get(href[1:]) if href.startswith('#') else None
                if target and target != '/' + name + '.html':
                    href = "{{ '" + target + "' | relative_url }}" + href
                return '[' + match[1] + '](' + href + ')'
            line = gen['LINK'].sub(replace, block['text'])
            if line != '## ' + title:
                lines.append(gen['local_heading'](line, 1) + '\n' if line.startswith('##') else line + '\n')
        write_page(name, title, '\n'.join(lines))
    rendered = []
    for block in blocks:
        rendered.extend('<a id="' + ident + '"></a>\n' for ident in block['ids'])
        rendered.append(block['text'] + '\n')
    write_page('recueil', 'Statuts et règlements — Recueil complet', '\n'.join(rendered))
    annexes = '# Annexes des responsabilités\n\n'
    for name, title, _ in jobs:
        if name.startswith('annexe-'):
            annexes += "- [" + title + "]({{ '/" + name + ".html' | relative_url }})\n"
    write_page('annexes', 'Annexes des responsabilités', annexes)
    (SITE / '_data').mkdir(exist_ok=True)
    (SITE / '_data/documents.json').write_text(json.dumps([{'id': name, 'titre': title, 'url': '/' + name + '.html'} for name, title, _ in jobs], ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    shutil.copyfile(ROOT / 'textes/archives/constitution.md', SITE / 'constitution.md')
    images = SITE / 'assets/images'
    images.mkdir(exist_ok=True)
    shutil.copyfile(logo, images / 'logo-9eg.png')
    print(f'{len(jobs)} pages distinctes et recueil préparés; {count} paragraphes vérifiés.')


if __name__ == '__main__':
    prepare()

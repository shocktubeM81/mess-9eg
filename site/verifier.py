"""Vérifier le site construit, ses renvois et sa concordance avec les sources."""
from html.parser import HTMLParser
from pathlib import Path
import argparse
import json
import re
import runpy
import sys
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'generateur'))
from sources import load_sources


class Page(HTMLParser):
    def __init__(self, path):
        super().__init__(convert_charrefs=True)
        self.ids = set()
        self.links = []
        self.paragraphs = []
        self.paragraph = None
        self.elements = []
        self.document_text = []
        self.original_text = []
        self.annotation_paragraphs = []
        self.feed(path.read_text(encoding='utf-8'))

    def handle_starttag(self, tag, attributes):
        attrs = dict(attributes)
        if 'id' in attrs:
            assert attrs['id'] not in self.ids, 'Identifiant répété : ' + attrs['id']
            self.ids.add(attrs['id'])
        for key in ('href', 'src'):
            if attrs.get(key):
                self.links.append(attrs[key])
        if tag == 'p':
            self.paragraph = []
        parent = self.elements[-1][1:] if self.elements else (False, False, False)
        classes = attrs.get('class', '').split()
        flags = (parent[0] or (tag == 'article' and attrs.get('id') == 'document'),
                 parent[1] or 'comparatif-original' in classes,
                 parent[2] or 'comparatif-annotation' in classes)
        if tag not in {'area', 'base', 'br', 'col', 'embed', 'hr', 'img', 'input', 'link', 'meta', 'param', 'source', 'track', 'wbr'}:
            self.elements.append((tag, *flags))

    def handle_data(self, text):
        if self.elements:
            if self.elements[-1][1]:
                self.document_text.append(text)
            if self.elements[-1][2]:
                self.original_text.append(text)
        if self.paragraph is not None:
            self.paragraph.append(text)

    def handle_endtag(self, tag):
        if tag == 'p' and self.paragraph is not None:
            if self.elements and self.elements[-1][3]:
                self.annotation_paragraphs.append(''.join(self.paragraph))
            self.paragraphs.append(''.join(self.paragraph))
            self.paragraph = None
        for index in range(len(self.elements) - 1, -1, -1):
            if self.elements[index][0] == tag:
                del self.elements[index:]
                break


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--site', type=Path, default=ROOT / '_site')
    ap.add_argument('--baseurl', default='')
    args = ap.parse_args()
    output = args.site.resolve()
    pages = {path.relative_to(output).as_posix(): Page(path) for path in output.rglob('*.html')}
    for name, page in pages.items():
        for href in page.links:
            url = urlsplit(href)
            if url.scheme or url.netloc:
                continue
            path = unquote(url.path)
            if args.baseurl and path.startswith('/'):
                assert path.startswith(args.baseurl + '/') or path == args.baseurl, (name, href)
                path = path[len(args.baseurl):]
            target = output / path.lstrip('/') if path.startswith('/') else output / Path(name).parent / path
            if not path:
                target = output / name
            if target.is_dir():
                target /= 'index.html'
            assert target.is_file(), (name, 'Destination absente : ' + href)
            if url.fragment and target.suffix == '.html':
                target_name = target.relative_to(output).as_posix()
                assert unquote(url.fragment) in pages[target_name].ids, (name, href)
    gen = runpy.run_path(str(ROOT / 'generateur/generer-documents.py'))
    text, structure, _ = load_sources()
    segments, count = gen['validate'](text, structure)
    blocks = gen['document_blocks'](text, segments)
    normalize = lambda value: ' '.join(value.split())
    comparison = pages['comparatif.html']
    assert {'article-' + str(n) for n in range(1, 117)} <= comparison.ids, 'Articles absents du comparatif'
    assert normalize(' '.join(comparison.original_text)) == normalize(' '.join(pages['constitution.html'].document_text)), 'Le texte initial du comparatif a été altéré'
    annotations = json.loads((ROOT / 'documentation/comparatif-0.12/annotations.json').read_text(encoding='utf-8'))
    labels = {'S': 'Statuts', 'AP': 'Avant-propos', **{f'R{i}': f'R{i}' for i in range(1, 5)},
              **{c: f'Annexe {c}' for c in 'ABCDEFG'}}
    groups = [('Annotation — Préliminaires', annotations['preliminaires'])]
    groups += [(f'Annotation — Article {n}', annotations['articles'][str(n)]) for n in range(1, 117)]
    groups += [('Ajouts dans le projet', annotations['ajouts'])]
    annotation_text = [value for title, notes in groups for value in [title, *notes]]
    annotation_text = [normalize(re.sub(r'\[\[([A-Z0-9]+):(\d+\.\d+)\]\]',
                       lambda m: labels[m[1]] + ' ' + m[2], value)) for value in annotation_text]
    assert annotation_text == [normalize(p) for p in comparison.annotation_paragraphs], 'Annotations web différentes du comparatif'
    pdf = 'assets/documents/constitution-initiale-annotee-0.12.pdf'
    assert (output / pdf).read_bytes() == (ROOT / 'site' / pdf).read_bytes(), 'PDF comparatif différent'
    expected = [normalize(gen['LINK'].sub(lambda match: match[1], b['text']))
                for b in blocks if re.match(r'^\d+\.\d+\. ', b['text'])]
    actual = [normalize(p) for p in pages['recueil.html'].paragraphs if re.match(r'^\d+\.\d+\. ', p)]
    if expected != actual:
        from itertools import zip_longest
        for index, (source, web) in enumerate(zip_longest(expected, actual), 1):
            if source != web:
                raise AssertionError(
                    f'Disposition {index} différente ({len(expected)} sources, {len(actual)} web) :\n'
                    f'Source : {source!r}\nWeb : {web!r}')
    for name, _, items in gen['document_jobs'](text, segments, blocks):
        expected_ids = {ident for block in items for ident in block['ids']}
        assert expected_ids <= pages[name + '.html'].ids, (name, 'Ancres absentes')
        expected_paragraphs = [normalize(gen['LINK'].sub(lambda match: match[1], b['text']))
                               for b in items if re.match(r'^\d+\.\d+\. ', b['text'])]
        actual_paragraphs = [normalize(p) for p in pages[name + '.html'].paragraphs if re.match(r'^\d+\.\d+\. ', p)]
        assert expected_paragraphs == actual_paragraphs, (name, 'Dispositions différentes')
    profile = json.loads((ROOT / 'generateur/modeles/9eg.json').read_text(encoding='utf-8'))
    assert (output / 'assets/images/logo-9eg.png').read_bytes() == (ROOT / profile['insigne']).read_bytes()
    assert not (output / 'textes').exists(), 'Des sources brutes sont publiées'
    assert not (ROOT / 'site/documents').exists(), 'Des copies Markdown subsistent dans site/'
    print(f'{len(pages)} pages et leurs liens vérifiés; {count} paragraphes identiques aux sources.')


if __name__ == '__main__':
    main()

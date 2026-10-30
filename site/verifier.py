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

    def handle_data(self, text):
        if self.paragraph is not None:
            self.paragraph.append(text)

    def handle_endtag(self, tag):
        if tag == 'p' and self.paragraph is not None:
            self.paragraphs.append(''.join(self.paragraph))
            self.paragraph = None


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
    expected = [normalize(gen['LINK'].sub(lambda match: match[1], b['text']))
                for b in blocks if re.match(r'^\d+\.\d+\. ', b['text'])]
    actual = [normalize(p) for p in pages['recueil.html'].paragraphs if re.match(r'^\d+\.\d+\. ', p)]
    assert expected == actual, 'Le recueil web ne correspond pas aux dispositions sources'
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

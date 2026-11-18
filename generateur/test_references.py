"""Vérifier les renvois externes et leur concordance avec la bibliographie."""
import re
import unittest
from urllib.parse import urlsplit

from sources import load_sources


LINK = re.compile(r'\[([^\]]+)\]\((https?://[^)]+)\)')


class ReferencesTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        _, _, sources = load_sources()
        cls.sources = {path: text for path, text in sources.items()
                       if path != 'textes/references.md'}
        cls.catalog = dict(re.findall(
            r'(?m)^Réf\. ([A-Z])\. \[([^\]]+)\]', sources['textes/references.md']))

    def test_catalog_is_contiguous_and_groups_related_sources(self):
        self.assertEqual(list(self.catalog), list('ABCDEFGHIJKLMN'))
        self.assertIn('PSP', self.catalog['A'])
        self.assertIn('volume I —', self.catalog['H'])
        self.assertIn('volume II —', self.catalog['I'])
        self.assertIn('permis', self.catalog['L'])
        self.assertIn('infractions', self.catalog['M'])

    def test_every_external_citation_has_a_reference_locator_and_target(self):
        for path, text in self.sources.items():
            for label, target in LINK.findall(text):
                with self.subTest(path=path, label=label):
                    match = re.fullmatch(
                        r'réf\. ([A-Z]), (?:chap\.|para\.|art\.|tableau|rubrique) .+', label)
                    self.assertIsNotNone(match)
                    self.assertIn(match[1], self.catalog)
                    self.assertRegex(label, r'(?:para\.|art\.|tableau|rubrique) ')
                    self.assertTrue(urlsplit(target).fragment,
                                    'Un passage, une section ou une page PDF est requis')
            without_links = LINK.sub('', text)
            self.assertIsNone(re.search(r'r[ée]f\.?\s+[A-Z]\b', without_links), path)

    def test_reference_letters_match_the_linked_document(self):
        identities = {
            'A': 'PSP-Policy-Manual-FR.pdf',
            'B': '/AF-N-105/',
            'C': 'DelegationofAuthorities_f-18Jun26.pdf',
            'D': '9003-1-biens-non-publics.html',
            'E': 'npp-contracting-policy-fr-links-feb-22.pdf',
            'F': '5045-0-programmes-de-soutien',
            'G': 'aa-ps-110-soutien-public',
            'H': '/vol-1-administration/',
            'I': '/vol-2-discipline/',
            'J': '/5020-3.html',
            'K': '/instructions-tenue/',
            'L': '/lc/P-9.1',
            'M': '/lc/I-8.1',
            'N': '/action-service-en-ligne/',
        }
        for path, text in self.sources.items():
            for label, target in LINK.findall(text):
                with self.subTest(path=path, label=label):
                    match = re.match(r'réf\. ([A-Z]),', label)
                    self.assertIsNotNone(match)
                    self.assertIn(identities[match[1]], target)


if __name__ == '__main__':
    unittest.main()

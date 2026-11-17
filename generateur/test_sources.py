"""Vérifications de la séparation, des renvois et de l’assemblage."""
import runpy
import unittest

from sources import ROOT, load_sources

GEN = runpy.run_path(str(ROOT / 'generateur/generer-documents.py'))


class DocumentsTest(unittest.TestCase):
    def setUp(self):
        self.text, self.structure, self.sources = load_sources()
        self.segments, self.count = GEN['validate'](self.text, self.structure)
        self.blocks = GEN['document_blocks'](self.text, self.segments)
        self.jobs = GEN['document_jobs'](self.text, self.segments, self.blocks)

    def test_all_numbered_paragraphs_are_exported(self):
        import re
        original = re.findall(r'^\d+\.\d+\. .+$', self.text, flags=re.M)
        exported = [b['text'] for _, _, items in self.jobs for b in items if re.match(r'^\d+\.\d+\. ', b['text'])]
        self.assertEqual(original, exported)
        self.assertEqual(self.count, len(exported))
        self.assertEqual(len(self.jobs), len(self.structure["segments"]))

    def test_every_document_has_its_own_source_and_destination(self):
        names = [name for name, _, _ in self.jobs]
        self.assertEqual(len(names), len(set(names)))
        self.assertTrue(all((ROOT / spec['source']).is_file() for spec in self.structure['segments']))
        anchors = [ident for _, _, items in self.jobs for block in items for ident in block['ids']]
        self.assertEqual(len(anchors), len(set(anchors)))
        for _, _, items in self.jobs:
            self.assertTrue(items[0]['text'].startswith('# '))
            self.assertTrue(items[2]['text'].startswith('## '))
            self.assertFalse(any(b['text'].startswith('#### ') for b in items))

    def test_export_produces_only_the_complete_collection(self):
        import json
        import subprocess
        import sys
        import tempfile
        (ROOT / 'tmp').mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(dir=ROOT / 'tmp') as folder:
            subprocess.run([sys.executable, str(ROOT / 'generateur/generer-documents.py'),
                            '--texte-seul', '--sortie', folder], check=True, capture_output=True)
            from pathlib import Path
            output = Path(folder)
            self.assertEqual({p.name for p in output.iterdir()}, {'statuts-et-reglements.txt', 'generation.json'})
            metadata = json.loads((output / 'generation.json').read_text(encoding='utf-8'))
            self.assertEqual([doc['document'] for doc in metadata['documents']], ['statuts-et-reglements'])
            self.assertEqual(metadata['paragraphes'], self.count)

    def test_sections_and_regulations_are_contiguous(self):
        import re
        regulations = [spec['id'] for spec in self.structure['segments']
                       if re.fullmatch(r'r\d+', spec['id'])]
        self.assertEqual(regulations, ['r1', 'r2', 'r3', 'r4'])
        for spec in self.structure['segments']:
            content = self.sources[spec['source']]
            sections = [int(n) for n in re.findall(r'^#+ (\d+)\. ', content, re.M)]
            self.assertEqual(sections, list(range(1, len(sections) + 1)), spec['source'])
            self.assertFalse(re.search(r'^\d+\.\d+(?:\.\d+)* [^ ]', content, re.M),
                             spec['source'])

    def test_subject_references_use_current_numbers(self):
        treasurer = self.sources['textes/annexe-d.md']
        self.assertIn('[paragraphe 9.5 des statuts](#statuts-paragraphe-9-5)', treasurer)
        self.assertIn('[paragraphe 9.6 des statuts](#statuts-paragraphe-9-6)', treasurer)
        self.assertIn('[paragraphe 9.9 des statuts](#statuts-paragraphe-9-9)',
                      self.sources['textes/r4.md'])

    def test_invalid_numbering_and_missing_links_are_rejected(self):
        broken = self.text.replace('1.1. Le Mess', '1.8. Le Mess', 1)
        with self.assertRaisesRegex(ValueError, 'Numérotation discontinue'):
            GEN['validate'](broken, self.structure)
        with self.assertRaisesRegex(ValueError, 'Renvoi interne sans destination'):
            GEN['document_blocks'](self.text + '\n[renvoi](#inexistant)\n', self.segments)


if __name__ == '__main__':
    unittest.main()

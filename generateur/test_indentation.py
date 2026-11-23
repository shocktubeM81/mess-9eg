"""Vérifier les retraits des articles et alinéas dans les exports réels."""
from pathlib import Path
import runpy
import tempfile
import unittest

GEN = runpy.run_path(str(Path(__file__).with_name('generer-documents.py')))
PROFILE = {
    'police': 'Times New Roman', 'taille': 12,
    'marge_gauche_cm': 2.5, 'marge_droite_cm': 2.5,
    'marge_haut_cm': 2.2, 'marge_bas_cm': 2.2,
    'titre_couverture': 'Constitution du Mess', 'unite': '9 EG',
    'lieu': 'Rouyn-Noranda', 'adresse': '97, rue Perreault Est',
    'entete': 'CONSTITUTION DU MESS',
}
BLOCKS = [
    {'text': '# Constitution du Mess', 'ids': []},
    {'text': 'Version de vérification', 'ids': []},
    {'text': '## Statuts', 'ids': ['statuts']},
    {'text': 'Texte préliminaire.', 'ids': []},
    {'text': 'Autre paragraphe préliminaire.', 'ids': []},
    {'text': '1.1. Introduction.', 'ids': []},
    {'text': 'Suite avant la liste.', 'ids': []},
    {'text': '- a. Premier alinéa avec **du gras** et [un lien](https://exemple.ca).', 'ids': []},
    {'text': '- b. Deuxième alinéa.', 'ids': []},
    {'text': 'Suite après la liste.', 'ids': []},
    {'text': '1.2. Retour aux articles.', 'ids': []},
    {'text': '### Nouvelle section', 'ids': []},
    {'text': 'Introduction de section.', 'ids': []},
    {'text': '## Références', 'ids': []},
    {'text': 'Réf. A. Manuel.', 'ids': []},
]


class IndentationTest(unittest.TestCase):
    def test_word_letters_and_text_are_indented_beyond_articles(self):
        from docx import Document
        from docx.shared import Cm
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / 'retraits.docx'
            GEN['make_docx'](BLOCKS, PROFILE, path)
            doc = Document(path)
            paras = {p.text.split('\t')[0]: p for p in doc.paragraphs if '\t' in p.text}
            for label in ('1.1.', '1.2.', 'a.', 'b.'):
                self.assertIn(label, paras)
            for label in ('a.', 'b.'):
                fmt = paras[label].paragraph_format
                self.assertAlmostEqual(fmt.left_indent.cm, 1.8, places=2)
                self.assertAlmostEqual((fmt.left_indent + fmt.first_line_indent) / Cm(1), 1.1, places=2)
                self.assertAlmostEqual(fmt.tab_stops[0].position.cm, 1.8, places=2)
                self.assertGreater(fmt.left_indent, paras['1.1.'].paragraph_format.left_indent)
            self.assertTrue(any(r.bold and 'du gras' in r.text for r in paras['a.'].runs))
            self.assertIn('https://exemple.ca', [r.target_ref for r in doc.part.rels.values()])
            self.assertAlmostEqual(paras['1.2.'].paragraph_format.left_indent.cm, 1.1, places=2)
            for text in ('Suite avant la liste.', 'Suite après la liste.'):
                p = next(p for p in doc.paragraphs if p.text == text)
                self.assertAlmostEqual(p.paragraph_format.left_indent.cm, 1.1, places=2)
                self.assertEqual(p.paragraph_format.first_line_indent, 0)
            for text in ('Texte préliminaire.', 'Autre paragraphe préliminaire.',
                         'Introduction de section.', 'Réf. A. Manuel.'):
                p = next(p for p in doc.paragraphs if p.text == text)
                self.assertEqual(p.paragraph_format.left_indent, 0)
                self.assertEqual(p.paragraph_format.first_line_indent, 0)
            heading = next(p for p in doc.paragraphs if p.text == 'Statuts')
            self.assertIn(heading.paragraph_format.left_indent, (None, 0))

    def test_pdf_places_letters_beyond_numbered_labels(self):
        from pypdf import PdfReader
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / 'retraits.pdf'
            GEN['reportlab_pdf'](BLOCKS, PROFILE, path)
            positions = {}
            text = ''
            for page in PdfReader(path).pages:
                def visit(value, cm, tm, font, size):
                    token = value.strip()
                    if token in ('1.1.', '1.2.', 'a.', 'b.', 'Premier alinéa avec',
                                 'Suite avant la liste.', 'Suite après la liste.', 'Statuts',
                                 'Texte préliminaire.', 'Autre paragraphe préliminaire.',
                                 'Introduction de section.', 'Réf. A. Manuel.'):
                        positions[token] = tm[4] * cm[0] + tm[5] * cm[2] + cm[4]
                text += page.extract_text(visitor_text=visit)
            for label in ('1.1.', '1.2.', 'a.', 'b.'):
                self.assertIn(label, positions)
            self.assertAlmostEqual(positions['1.1.'], positions['1.2.'], places=2)
            self.assertAlmostEqual(positions['a.'], positions['b.'], places=2)
            self.assertAlmostEqual(positions['a.'] - positions['1.1.'], 1.1 * 72 / 2.54, places=2)
            for token in ('Suite avant la liste.', 'Suite après la liste.'):
                self.assertIn(token, positions)
                self.assertAlmostEqual(positions[token], positions['a.'], places=2)
            self.assertAlmostEqual(positions['Statuts'], positions['1.1.'], places=2)
            for token in ('Texte préliminaire.', 'Autre paragraphe préliminaire.',
                          'Introduction de section.', 'Réf. A. Manuel.'):
                self.assertIn(token, positions)
                self.assertAlmostEqual(positions[token], positions['1.1.'], places=2)
            self.assertIn('Premier alinéa', text)
            self.assertNotIn('- a.', text)


if __name__ == '__main__':
    unittest.main()

"""Verifier le gras et les liens dans les vrais fichiers Word et PDF."""
from pathlib import Path
import tempfile
import unittest
from xml.etree import ElementTree as ET
from zipfile import ZipFile

from markdown_inline import add_docx_runs, inline_spans, pdf_markup, plain_text


class MarkdownExportsTest(unittest.TestCase):
    def test_visible_text_and_link_targets_survive_emphasis(self):
        value = '**Avant [un **lien**](https://exemple.ca?a=1&b=2) après** et texte normal.'
        spans = inline_spans(value)
        self.assertEqual(plain_text(value), 'Avant un lien après et texte normal.')
        self.assertTrue(all(bold for text, bold, _ in spans if text != ' et texte normal.'))
        self.assertIn(('un lien', True, 'https://exemple.ca?a=1&b=2'), spans)
        self.assertEqual(plain_text('[un **lien**](https://exemple.ca)', external_urls=True),
                         'un lien (https://exemple.ca)')
        self.assertEqual(plain_text('[**local**](#section)', external_urls=True), 'local')

    def test_escaped_or_unclosed_markers_remain_literal(self):
        value = r'\*\*littéral\*\* et **sans fermeture'
        self.assertEqual(plain_text(value), '**littéral** et **sans fermeture')
        self.assertFalse(any(bold for _, bold, _ in inline_spans(value)))
        self.assertIn('&lt;test&gt;', pdf_markup('**<test>**'))

    def test_word_contains_bold_runs_and_clickable_links(self):
        from docx import Document
        value = 'Texte **important** et [**référence**](https://exemple.ca?a=1&b=2), puis [local](#section).'
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / 'gras.docx'
            document = Document()
            add_docx_runs(document.add_paragraph(), value, lambda name: 'signet_' + name)
            document.save(path)
            with ZipFile(path) as archive:
                xml = ET.fromstring(archive.read('word/document.xml'))
                relationships = ET.fromstring(archive.read('word/_rels/document.xml.rels'))
            ns = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
            text = ''.join(node.text or '' for node in xml.findall('.//w:t', ns))
            self.assertEqual(text, plain_text(value))
            bold = [''.join(node.text or '' for node in run.findall('.//w:t', ns))
                    for run in xml.findall('.//w:r', ns) if run.find('w:rPr/w:b', ns) is not None]
            self.assertEqual(bold, ['important', 'référence'])
            self.assertTrue(any(node.attrib.get('Target') == 'https://exemple.ca?a=1&b=2' for node in relationships))
            local = xml.find('.//w:hyperlink[@w:anchor="signet_section"]', ns)
            self.assertIsNotNone(local)

    def test_pdf_uses_bold_fonts_and_keeps_external_link(self):
        from pypdf import PdfReader
        from reportlab.lib.styles import ParagraphStyle
        from reportlab.platypus import SimpleDocTemplate, Paragraph
        value = 'Texte **important** et [**référence**](https://exemple.ca?a=1&b=2).'
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / 'gras.pdf'
            document = SimpleDocTemplate(str(path))
            document.build([Paragraph(pdf_markup(value), ParagraphStyle('body', fontName='Times-Roman', fontSize=12))])
            page = PdfReader(path).pages[0]
            fonts = []
            def visit(text, cm, tm, font, size):
                if text.strip():
                    fonts.append((text.strip(), str(font.get('/BaseFont', '')) if font else ''))
            text = page.extract_text(visitor_text=visit)
            self.assertNotIn('**', text)
            self.assertTrue(any('important' in part and 'Bold' in font for part, font in fonts), fonts)
            self.assertTrue(any('référence' in part and 'Bold' in font for part, font in fonts), fonts)
            self.assertTrue(any(part == 'Texte' and 'Bold' not in font for part, font in fonts), fonts)
            links = [item.get_object().get('/A', {}).get('/URI') for item in page.get('/Annots', [])]
            self.assertIn('https://exemple.ca?a=1&b=2', links)


if __name__ == '__main__':
    unittest.main()

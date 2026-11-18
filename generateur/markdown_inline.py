"""Rendre le gras et les liens Markdown sans perdre le texte ni les destinations."""
from __future__ import annotations

import html
import re

TOKEN = re.compile(r'\\(?P<escape>[\\*])|(?P<strong>\*\*)|\[(?P<label>[^\]]+)\]\((?P<href>[^)]+)\)')


def inline_spans(text, bold=False, href=None):
    """Retourner (texte, gras, destination) pour les fragments visibles.

    Le gras peut entourer un lien ou ne concerner que son libellé. Une paire
    échappée ou un marqueur sans fermeture reste du texte littéral.
    """
    tokens = list(TOKEN.finditer(text))
    markers = [index for index, token in enumerate(tokens) if token['strong']]
    paired = set(markers[:len(markers) // 2 * 2])
    spans = []
    strong = False
    position = 0

    def append(value, is_bold, target):
        if not value:
            return
        if spans and spans[-1][1:] == (is_bold, target):
            spans[-1] = (spans[-1][0] + value, is_bold, target)
        else:
            spans.append((value, is_bold, target))

    for index, token in enumerate(tokens):
        append(text[position:token.start()], bold or strong, href)
        if token['escape']:
            append(token['escape'], bold or strong, href)
        elif token['strong']:
            if index in paired:
                strong = not strong
            else:
                append('**', bold or strong, href)
        else:
            for value, is_bold, target in inline_spans(token['label'], bold or strong, token['href']):
                append(value, is_bold, target)
        position = token.end()
    append(text[position:], bold or strong, href)
    return spans


def plain_text(text, external_urls=False):
    """Texte visible, avec au besoin une seule destination par lien externe."""
    result = []
    active = None
    for value, _, href in inline_spans(text):
        if href != active:
            if external_urls and active and not active.startswith('#'):
                result.append(' (' + active + ')')
            active = href
        result.append(value)
    if external_urls and active and not active.startswith('#'):
        result.append(' (' + active + ')')
    return ''.join(result)


def add_docx_runs(paragraph, text, anchor=lambda value: value):
    from docx.oxml import OxmlElement
    from docx.oxml.ns import qn
    from docx.opc.constants import RELATIONSHIP_TYPE as RT

    for value, bold, href in inline_spans(text):
        if href is None:
            run = paragraph.add_run(value)
            if bold:
                run.bold = True
            continue
        link = OxmlElement('w:hyperlink')
        if href.startswith('#'):
            link.set(qn('w:anchor'), anchor(href[1:]))
        else:
            link.set(qn('r:id'), paragraph.part.relate_to(href, RT.HYPERLINK, is_external=True))
        run = OxmlElement('w:r')
        properties = OxmlElement('w:rPr')
        color = OxmlElement('w:color')
        color.set(qn('w:val'), '000000')
        properties.append(color)
        underline = OxmlElement('w:u')
        underline.set(qn('w:val'), 'single')
        properties.append(underline)
        if bold:
            properties.append(OxmlElement('w:b'))
            properties.append(OxmlElement('w:bCs'))
        run.append(properties)
        node = OxmlElement('w:t')
        node.set(qn('xml:space'), 'preserve')
        node.text = value
        run.append(node)
        link.append(run)
        paragraph._p.append(link)


def pdf_markup(text, anchor=lambda value: value):
    """Balisage ReportLab, après échappement du texte et des URL."""
    result = []
    for value, bold, href in inline_spans(text):
        rendered = html.escape(value)
        if bold:
            rendered = '<b>' + rendered + '</b>'
        if href is not None:
            target = '#' + anchor(href[1:]) if href.startswith('#') else href
            rendered = '<link href="' + html.escape(target, quote=True) + '"><u>' + rendered + '</u></link>'
        result.append(rendered)
    return ''.join(result)

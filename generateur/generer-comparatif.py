"""Conserver la constitution initiale et insérer les annotations de la version 0.12."""
from pathlib import Path
import base64
import hashlib
import html
import json
import re
import sys
import shutil

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'textes/archives/constitution.md'
DATA = ROOT / 'documentation/comparatif-0.12/annotations.json'
OUT = ROOT / 'exports/comparatif-constitution-0.12'
REF = re.compile(r'\[\[([A-Z0-9]+):(\d+\.\d+)\]\]')
FILES = {'S':'statuts', 'AP':'avant-propos', **{f'R{i}':f'r{i}' for i in range(1,5)},
         **{c:f'annexe-{c.lower()}' for c in 'ABCDE'},
         'F':'annexe-f-regisseur', 'G':'annexe-g-serveur'}
LABELS = {'S':'Statuts', 'AP':'Avant-propos', **{f'R{i}':f'R{i}' for i in range(1,5)},
          **{c:f'Annexe {c}' for c in 'ABCDEFG'}}

def digest(content):
    return hashlib.sha256(content).hexdigest()

def clean_original(text):
    text = re.sub(r'\A---\r?\n.*?\r?\n---\r?\n', '', text, flags=re.S)
    text = re.sub(r'<!--.*?-->', '', text, flags=re.S)
    text = re.sub(r'<a\s+id="[^"]+"></a>', '', text)
    return text

def plain(text):
    return re.sub(r'\*\*|\*', '', text)

def ref_label(match):
    group,number = match.groups()
    return LABELS[group]+' '+number

def resolve(text):
    return REF.sub(ref_label, text)

def url(group,number):
    return f'https://mess.9eg.ca/{FILES[group]}.html#{FILES[group]}-paragraphe-{number.replace(".","-")}'

def markup(text):
    # Source characters are escaped first; formatting is applied without typography substitutions.
    text=html.escape(text)
    text=re.sub(r'\*\*(.+?)\*\*',r'<b>\1</b>',text,flags=re.S)
    text=re.sub(r'(?<!\*)\*([^*]+)\*(?!\*)',r'<i>\1</i>',text,flags=re.S)
    return text

def rich_note(text):
    result=[]; start=0
    for m in REF.finditer(text):
        result.append(html.escape(text[start:m.start()]))
        result.append(f'<a href="{url(*m.groups())}" color="#24465e">{ref_label(m)}</a>')
        start=m.end()
    result.append(html.escape(text[start:]))
    return ''.join(result)

def main():
    raw=SOURCE.read_bytes(); original=raw.decode('utf-8'); original_hash=digest(raw)
    data=json.loads(DATA.read_text(encoding='utf-8'))
    assert set(data['articles'])==set(map(str,range(1,117))), 'Il faut annoter les 116 articles'
    allnotes=data['preliminaires']+data['ajouts']+[n for notes in data['articles'].values() for n in notes]
    target_content={key:(ROOT/f'textes/{name}.md').read_text(encoding='utf-8') for key,name in FILES.items()}
    for note in allnotes:
        for group,number in REF.findall(note):
            assert re.search(r'^'+re.escape(number)+r'\. ',target_content[group],re.M), (group,number)
    # Build ordered source and annotation blocks. Source strings are never rewritten.
    markers=list(re.finditer(r'<a id="article-(\d+)"></a>',original))
    assert [int(m[1]) for m in markers]==list(range(1,117))
    prefix=original[:markers[0].start()]
    split=prefix.rfind('\n## ')
    blocks=[('original',prefix[:split]),('annotation',('Préliminaires',data['preliminaires'])),
            ('original',prefix[split:])]
    for index,m in enumerate(markers):
        end=markers[index+1].start() if index+1<len(markers) else len(original)
        piece=original[m.start():end]
        trailing=re.search(r'\n## ',piece)
        head,tail=(piece[:trailing.start()],piece[trailing.start():]) if trailing else (piece,'')
        blocks.append(('original',head))
        blocks.append(('annotation',(f'Article {m[1]}',data['articles'][m[1]])))
        if tail: blocks.append(('original',tail))
    assert ''.join(value for kind,value in blocks if kind=='original')==original
    intro=(f'# Constitution initiale annotée\n\nComparaison avec le projet de modification version {data["version_comparee"]}.\n\n'
           'Le texte initial, ses titres, ses numéros et ses alinéas sont conservés dans leur ordre d’origine. '
           'Les annotations décrivent les modifications, déplacements et passages non repris, sans en donner les motifs. '
           'Les renvois désignent la numérotation actuelle : Statuts, R1 à R4 et annexes A à G. '
           '« Non repris » signifie non reproduit explicitement dans le projet; un renvoi à une politique extérieure '
           'ne constitue pas ici une vérification du contenu de cette politique.\n\n'
           'Source initiale : textes/archives/constitution.md. Les annotations sont distinctes du texte initial; '
           'la pagination du présent comparatif est nouvelle.\n\n')
    md=intro+'<!-- DEBUT TEXTE INITIAL ANNOTE -->\n'
    for kind,value in blocks:
        if kind=='original': md+=value
        else:
            label,notes=value
            md+='\n<!-- DEBUT ANNOTATION -->\n\n> **Annotation — '+label+'**\n>\n'
            md+='\n>\n'.join('> '+resolve(n) for n in notes)
            md+='\n\n<!-- FIN ANNOTATION -->\n'
    md+='\n<!-- FIN TEXTE INITIAL ANNOTE -->\n\n## Dispositions ajoutées ou développées\n\n'
    md+='\n\n'.join(resolve(n) for n in data['ajouts'])+'\n'
    # Prove reversibility against the complete source, including metadata and page comments.
    body=md.split('<!-- DEBUT TEXTE INITIAL ANNOTE -->\n',1)[1].split('\n<!-- FIN TEXTE INITIAL ANNOTE -->',1)[0]
    recovered=re.sub(r'\n<!-- DEBUT ANNOTATION -->.*?<!-- FIN ANNOTATION -->\n','',body,flags=re.S)
    assert recovered==original, 'Le texte initial doit pouvoir être reconstruit à l’identique'
    mdpath=ROOT/'documentation/comparatif-0.12/constitution-initiale-annotee.md'
    mdpath.write_text(md,encoding='utf-8')
    OUT.mkdir(parents=True,exist_ok=True)
    # One ordered content stream drives both Word and PDF.
    stream=[('title','Constitution initiale annotée'),('subtitle',f'Comparaison avec le projet version {data["version_comparee"]}')]
    for para in intro.split('\n\n')[2:]:
        if para.strip(): stream.append(('intro',para.strip()))
    stream.append(('break',''))
    for kind,value in blocks:
        if kind=='annotation':
            label,notes=value
            stream.append(('note-title','Annotation — '+label))
            stream.extend(('note',n) for n in notes)
            continue
        for para in re.split(r'\n\s*\n',clean_original(value)):
            para=para.strip()
            if not para: continue
            if para.startswith('#'):
                stream.append(('original-heading',re.sub(r'^#+\s*','',para)))
            else:
                sub=para.startswith('- ')
                if sub: para=para[2:]
                stream.append(('original-sub' if sub else 'original',para))
    stream.append(('break',''))
    stream.append(('original-heading','Dispositions ajoutées ou développées'))
    stream.extend(('note',n) for n in data['ajouts'])
    write_docx(stream,OUT/'constitution-initiale-annotee-0.12.docx')
    write_pdf(stream,OUT/'constitution-initiale-annotee-0.12.pdf')
    web_pdf=ROOT/'site/assets/documents/constitution-initiale-annotee-0.12.pdf'
    web_pdf.parent.mkdir(parents=True,exist_ok=True)
    shutil.copyfile(OUT/'constitution-initiale-annotee-0.12.pdf',web_pdf)
    assert digest(SOURCE.read_bytes())==original_hash
    manifest={'source':str(SOURCE.relative_to(ROOT)),'sha256_source':original_hash,
              'version_comparee':data['version_comparee'],'articles_initiaux':116,
              'annotations':len(allnotes),'fidelite_source':'reconstruction intégrale vérifiée à l’identique',
              'sources_courantes':{f'textes/{FILES[k]}.md':digest(v.encode('utf-8')) for k,v in target_content.items()}}
    (OUT/'verification.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({'sortie':str(OUT),'articles':116,'annotations':len(allnotes),'source_sha256':original_hash},ensure_ascii=False))

def write_docx(stream,path):
    from docx import Document
    from docx.shared import Inches,Pt,RGBColor
    from docx.oxml import OxmlElement
    from docx.oxml.ns import qn
    doc=Document(); sec=doc.sections[0]
    sec.page_width=Inches(8.5); sec.page_height=Inches(11)
    sec.top_margin=sec.bottom_margin=Inches(.75)
    sec.left_margin=sec.right_margin=Inches(.85)
    for name in ['Normal','Title','Subtitle','Heading 1','Heading 2']:
        st=doc.styles[name]; st.font.name='Times New Roman'; st.font.color.rgb=RGBColor(0,0,0)
    normal=doc.styles['Normal']; normal.font.size=Pt(11); normal.paragraph_format.space_after=Pt(6)
    normal.paragraph_format.line_spacing=1.05
    doc.styles['Title'].font.size=Pt(22)
    doc.styles['Subtitle'].font.size=Pt(12)
    doc.styles['Heading 1'].font.size=Pt(14)
    for idx,(kind,text) in enumerate(stream):
        if kind=='break': doc.add_page_break(); continue
        style='Title' if kind=='title' else 'Subtitle' if kind=='subtitle' else 'Heading 1' if kind=='original-heading' else 'Normal'
        p=doc.add_paragraph(style=style)
        if kind=='note-title': p.paragraph_format.keep_with_next=True; p.paragraph_format.space_before=Pt(9)
        if kind in ('note','note-title'):
            p.paragraph_format.left_indent=Inches(.2)
            for token in re.split(r'(\*\*.*?\*\*|\*[^*]+\*)',resolve(text),flags=re.S):
                run=p.add_run(plain(token)); run.font.size=Pt(10); run.font.color.rgb=RGBColor.from_string('24465E')
                run.bold=kind=='note-title'; run.italic=kind=='note'
        else:
            if kind=='original-sub': p.paragraph_format.left_indent=Inches(.22)
            for token in re.split(r'(\*\*.*?\*\*|\*[^*]+\*)',text,flags=re.S):
                run=p.add_run(plain(token).replace('\n',' '))
                run.bold=token.startswith('**'); run.italic=token.startswith('*') and not token.startswith('**')
        p.paragraph_format.widow_control=True
        if kind in ('original','original-sub') and idx+1<len(stream) and stream[idx+1][0]=='note-title':
            p.paragraph_format.keep_with_next=True
    footer=sec.footer.paragraphs[0]; footer.alignment=2
    footer.add_run('Comparatif 0.12  |  ')
    fld=OxmlElement('w:fldSimple'); fld.set(qn('w:instr'),'PAGE'); footer._p.append(fld)
    doc.core_properties.title='Constitution initiale annotée — comparaison avec la version 0.12'
    doc.core_properties.author='Mess du 9 EG'
    doc.save(path)
    # Check every source paragraph in the Word body remains in the original sequence.
    expected=[' '.join(plain(text).split()) for kind,text in stream if kind in ('original','original-sub','original-heading')]
    actual=[' '.join(p.text.split()) for p in doc.paragraphs]
    index=0
    for text in actual:
        if index<len(expected) and text==expected[index]: index+=1
    assert index==len(expected),'Texte initial manquant dans le Word'

def write_pdf(stream,path):
    from reportlab.platypus import SimpleDocTemplate,Paragraph,Spacer,PageBreak
    from reportlab.lib.styles import ParagraphStyle
    from reportlab.lib.colors import HexColor
    from reportlab.pdfbase import pdfmetrics
    from reportlab.pdfbase.ttfonts import TTFont
    from reportlab.lib.pagesizes import letter
    fontroot=Path('C:/Windows/Fonts')
    for name,file in [('Source','times.ttf'),('Source-Bold','timesbd.ttf'),('Source-Italic','timesi.ttf'),('Source-BoldItalic','timesbi.ttf')]:
        pdfmetrics.registerFont(TTFont(name,str(fontroot/file)))
    pdfmetrics.registerFontFamily('Source',normal='Source',bold='Source-Bold',italic='Source-Italic',boldItalic='Source-BoldItalic')
    body=ParagraphStyle('body',fontName='Source',fontSize=11,leading=13.3,spaceAfter=6,allowWidows=0,allowOrphans=0)
    styles={
      'title':ParagraphStyle('title',parent=body,fontName='Source-Bold',fontSize=22,leading=27,spaceBefore=44,spaceAfter=17),
      'subtitle':ParagraphStyle('subtitle',parent=body,fontSize=12,leading=16,spaceAfter=24),
      'intro':ParagraphStyle('intro',parent=body,spaceAfter=12),
      'original-heading':ParagraphStyle('heading',parent=body,fontName='Source-Bold',fontSize=14,leading=17,spaceBefore=13,spaceAfter=8,keepWithNext=True),
      'original':body,
      'original-sub':ParagraphStyle('sub',parent=body,leftIndent=16),
      'note-title':ParagraphStyle('notetitle',parent=body,fontName='Source-Bold',fontSize=10,leading=12,textColor=HexColor('#24465e'),leftIndent=14,spaceBefore=10,spaceAfter=5,keepWithNext=True),
      'note':ParagraphStyle('note',parent=body,fontName='Source-Italic',fontSize=10,leading=12.5,textColor=HexColor('#24465e'),leftIndent=14,spaceAfter=7)
    }
    story=[]
    for idx,(kind,text) in enumerate(stream):
        if kind=='break': story.append(PageBreak()); continue
        content=rich_note(text) if kind in ('note','note-title') else markup(text)
        p=Paragraph(content,styles[kind])
        if kind in ('original','original-sub') and idx+1<len(stream) and stream[idx+1][0]=='note-title':
            p.keepWithNext=True
        story.append(p)
    def page_footer(canvas,doc):
        canvas.setFont('Source',9); canvas.setFillColor(HexColor('#333333'))
        canvas.drawRightString(letter[0]-61,28,f'Comparatif 0.12  |  {doc.page}')
    doc=SimpleDocTemplate(str(path),pagesize=letter,leftMargin=61,rightMargin=61,topMargin=46,bottomMargin=46,
        title='Constitution initiale annotée — comparaison avec la version 0.12',author='Mess du 9 EG')
    doc.build(story,onFirstPage=page_footer,onLaterPages=page_footer)

if __name__=='__main__': main()

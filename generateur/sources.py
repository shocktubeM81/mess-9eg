"""Charger les documents Markdown et assembler le recueil dans leur ordre déclaré."""
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]


def load_sources():
    structure = json.loads((ROOT / 'textes/structure.json').read_text(encoding='utf-8'))
    parts = []
    sources = {}
    for item in structure['assemblage']:
        if 'source' in item:
            path = (ROOT / item['source']).resolve()
            if not path.is_relative_to(ROOT / 'textes'):
                raise ValueError('Source hors du dossier textes : ' + item['source'])
            content = path.read_text(encoding='utf-8-sig').rstrip() + '\n'
            sources[item['source']] = content
            parts.append(content)
        else:
            parts.append(item['texte'].rstrip() + '\n')
    return '\n'.join(parts), structure, sources

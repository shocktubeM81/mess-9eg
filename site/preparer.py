"""Préparer les entrées partagées de Jekyll, sans transformer le Markdown."""
from pathlib import Path
import shutil

ROOT = Path(__file__).resolve().parents[1]
SITE = ROOT / 'site'


def prepare():
    copies = {
        ROOT / 'textes/texte-maitre.md': SITE / '_includes/texte-maitre.md',
        ROOT / 'textes/structure.json': SITE / '_data/structure.json',
        ROOT / 'textes/archives/constitution.md': SITE / 'constitution.md',
    }
    # Vérifier toutes les sources avant d’écrire.
    for source in copies:
        if not source.is_file():
            raise FileNotFoundError(f'Source absente : {source}')
    for source, target in copies.items():
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, target)
    print('Site préparé depuis textes/; aucune disposition transformée.')


if __name__ == '__main__':
    prepare()

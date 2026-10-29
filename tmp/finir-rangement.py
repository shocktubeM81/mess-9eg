from pathlib import Path
p=Path('generateur/generer-documents.py');s=p.read_text(encoding='utf-8-sig').replace("help='Produire seulement la copie TXT et, sur demande, les vues du site'","help='Produire seulement la copie TXT'").replace("'maitre':master.name","'maitre':master.relative_to(ROOT).as_posix()");p.write_text(s,encoding='utf-8')

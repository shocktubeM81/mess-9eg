from pathlib import Path
import subprocess
p=Path('outils/generer-documents.py');s=subprocess.check_output(['git','show','HEAD:outils/generer-documents.py']).decode('utf-8-sig')
a=s.index('def source_content(');b=s.index('def bookmark_name(');s=s[:a]+s[b:]
s=s.replace("ROOT/'outils/structure-maitre.json'","ROOT/'_data/structure.json'").replace('    if args.site:write_site(segments)\n','').replace("help='Actualiser aussi les vues du site à partir du maître'","help='Compatibilité : le site lit directement le maître'").replace("print('Copie TXT créée; vues web actualisées.' if args.site else 'Copie TXT créée.');return","print('Copie TXT créée.');return")
p.write_text(s,encoding='utf-8')

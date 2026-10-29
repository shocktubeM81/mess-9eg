$ErrorActionPreference='Stop'
$revisionDir=Join-Path $PSScriptRoot 'versions/2026-10-28-v0.2'
$encoding=New-Object System.Text.UTF8Encoding($false)
$units=@{};$documents=@{};$mapping=@{}
foreach($i in 1..4){
 $file=Join-Path $revisionDir "R$i-proposition.md"
 $documents[$i]=[IO.File]::ReadAllText($file)
 $units[$i]=@{}
 foreach($m in [regex]::Matches($documents[$i],'(?ms)(?:<a id="article-\d+"></a>)?\*\*((?:R\d\.)?\d+)\.\*\*\s+(.*?)(?=(?:<a id="article-\d+"></a>)?\*\*(?:R\d\.)?\d+\.\*\*|^## |\z)')){
  $units[$i][$m.Groups[1].Value]=$m.Groups[2].Value.Trim()
 }
}
# Modalités pratiques complémentaires aux fonctions constitutionnelles.
$units[3]['17']="L’avis précise la date, le lieu ou le moyen de connexion. L’ordre du jour et les documents utiles sont transmis au moins 7 jours avant la séance; l’avis et l’ordre du jour sont aussi affichés dans les locaux. Le secrétaire organise ces envois en respectant les délais minimaux fixés aux articles 25 et 115 de la constitution."
$units[3]['16']="Pendant la séance, la présidence distribue la parole, évite les répétitions et veille au respect de l’ordre du jour et des procédures. Les interventions lui sont adressées, une personne à la fois."
$units[3]['R3.1']="Les dossiers sont classés dans un répertoire commun : textes de gouvernance, convocations, ordres du jour, procès-verbaux, décisions, budgets, rapports financiers, inventaires et correspondance. Chaque document indique sa date, sa version, son statut et les preuves d’adoption et d’approbation requises. Le registre des décisions précise responsable, échéance et suivi. Les dossiers du comité et ceux des assemblées sont distincts et reliés par les recommandations et décisions correspondantes."
$units[2]['R2.1']="L’inventaire distingue les biens du Mess, de la Couronne, du fonds d’unité et de tiers. Chaque fiche indique description, emplacement, provenance, date d’entrée, propriétaire, valeur connue, justificatif et conditions d’utilisation ou de restitution. Une provenance incertaine est signalée et vérifiée avant disposition. La responsabilité de tenir cet inventaire demeure celle prévue à l’article 37 de la constitution."
$units[3]['84']="Les demandes urgentes sont acheminées directement au président selon les voies prévues par la constitution; les sujets collectifs sont inscrits au suivi de la prochaine séance."
# Rédaction autonome : chaque sujet est traité une seule fois et dans son contexte.
$units[1]['65']="Les locaux du Mess sont répartis selon les grades. Un militaire utilise le local correspondant à son grade. L’accès à un autre local est permis dans l’exercice de ses fonctions ou après une invitation spéciale autorisée par le commandant ou le président du comité du Mess."
$units[1]['74']="Les conjoints des membres peuvent participer aux activités du Mess même en l’absence du membre. Ils doivent pouvoir s’identifier; en cas de doute sur leur identité, un membre du comité est consulté. Lorsque le membre est à l’extérieur de la région, son conjoint reçoit le même traitement que celui réservé au membre. Pour un conjoint de moins de 18 ans, l’autorisation du commandant est requise."
$units[1]['75']="Le Mess peut recevoir des invités officiels, dont il assume les frais dans les limites approuvées. Les membres peuvent également recevoir des invités personnels, qui restent sous leur responsabilité. Lorsqu’un membre accompagne un invité à une activité financée par le président du comité, l’invité paie son repas et ne participe pas aux tirages des prix de présence."
$units[1]['95']="Un membre peut recevoir un invité personnel et doit l’accompagner pendant sa présence au Mess. Il répond de sa tenue et de son comportement. Lorsque le membre quitte les lieux, son invité quitte également. Les conjoints admis sans le membre suivent les conditions de la section sur l’accès aux locaux."
$units[1]['96']="Un officier présente son invité au commandant. Un sergent ou un adjudant présente son invité au sergent-major de l’escadron."
$units[1]['67']="Les personnes de moins de 18 ans admises au Mess sont les membres du Mess, les conjoints autorisés par le commandant et les enfants dans les conditions précisées ci-dessous. Leur admission ne leur permet pas de consommer de l’alcool : aucune boisson alcoolisée ne peut leur être vendue ou servie."
$units[1]['69']="Pendant les ouvertures normales, les enfants peuvent utiliser la salle de télévision sous la surveillance de leurs parents. Lors d’une activité officielle, ils quittent le Mess avant 19 h, sauf si l’activité est familiale."
$units[1]['70']=@"
Les membres et leurs invités respectent les règles suivantes :

- **Tenue générale.** Porter des vêtements propres et convenables. Les vêtements dégradants ou répulsifs sont interdits.
- **Torse et chaussures.** Garder le torse couvert et porter des chaussures; les pieds nus sont interdits.
- **Couvre-chef.** Retirer son couvre-chef à l’entrée du Mess, sous réserve des exceptions prévues par les instructions militaires, notamment pour les pratiques religieuses ou l’exercice de fonctions.
- **Port de l’uniforme.** Lorsqu’un militaire porte l’uniforme, celui-ci demeure conforme aux Instructions sur la tenue des Forces canadiennes (A-DH-265-000/AG-001), dans leur version en vigueur, ainsi qu’aux directives de tenue applicables de la chaîne de commandement. L’uniforme est propre, soigné et porté avec les articles et insignes autorisés.
- **Tenue minimale.** En cas d’abus, le commandant ou le président peut préciser la tenue minimale exigée, dans le respect des instructions militaires applicables.

Pour le personnel du bar :

- **Soirées spéciales.** Chemise blanche, nœud papillon et pantalon noir, ou tenue équivalente.
- **Autres ouvertures et fins de semaine d’entraînement.** Uniforme de la journée ou tenue propre. Le port de l’uniforme demeure soumis aux exigences ci-dessus.

Référence : [Instructions sur la tenue des Forces canadiennes, chapitre 2 — Politique et apparence](https://www.canada.ca/fr/services/defense/fac/systeme-identite-militaire/instructions-tenue/chapitre-2.html), notamment les rubriques sur le port de l’uniforme, les coiffures et les vêtements civils.
"@
$units[1]['71']="Il est interdit de dormir dans les locaux du Mess, y compris derrière le bar, pour des raisons d’hygiène et de sécurité."
$units[1]['62']="Les membres et leurs invités respectent les règles du Mess et contribuent au maintien de l’ordre et d’un climat amical. Les comportements perturbateurs donnent lieu à un rappel à l’ordre et sont signalés au sergent-major de l’escadron."
$units[1]['66']="Après utilisation, chacun laisse les locaux et les équipements de jeu propres et remet les meubles à leur place."
$units[1]['63']="Tout dommage causé par un membre ou son invité est signalé au président, même s’il est accidentel. Les frais de réparation ou de remise en état peuvent être réclamés selon la responsabilité établie; le seul signalement d’un accident ne rend pas automatiquement le membre responsable du coût."
$units[1]['94']="Lors d’une réception privée, le responsable de l’activité répond des dommages causés aux biens du Mess ou de la Couronne. Le comité assure le suivi du remboursement."
$units[1]['57']="Le président répond au commandant de la discipline dans les locaux. En son absence, le membre senior présent veille au maintien de l’ordre."
$units[2]['R2.1']="Le vice-président tient l’inventaire en distinguant les biens du Mess, de la Couronne, du fonds d’unité et de tiers. Chaque fiche indique description, emplacement, provenance, date d’entrée, propriétaire, valeur connue, justificatif et conditions d’utilisation ou de restitution. Une provenance incertaine est signalée et vérifiée avant disposition."
$units[4]['R4.3']="Le refus de service est expliqué calmement. Le responsable appuie le serveur, propose au besoin de l’eau ou une boisson sans alcool et aide à organiser un retour sécuritaire. En cas de menace, de malaise ou de danger immédiat, il suspend le service et appelle les services d’urgence appropriés. Un relevé factuel de l’incident est transmis au capitaine-adjudant et conservé avec un accès restreint."
# Fusion des dispositions qui répétaient la même règle.
$merged=@{'64'='95';'97'='70';'98'='66'}
foreach($key in $merged.Keys){$units[1].Remove($key)}
$introductions=@{}
$introductions[1]="Ce règlement précise la tenue, le comportement et les conditions pratiques de fréquentation du Mess. Il s’applique à toute personne admise dans les locaux afin de préserver des lieux accueillants, propres et respectueux."
$introductions[2]="Ce règlement encadre l’utilisation, la conservation et la présentation des meubles, décorations et souvenirs du Mess. Il précise aussi la provenance des biens, les conditions d’acceptation des dons et les renseignements à conserver à l’inventaire."
$introductions[3]="Ce règlement explique comment préparer et tenir les assemblées et les réunions, puis en consigner et communiquer les résultats. Il précise aussi l’accès aux documents, leur archivage et leur sauvegarde; les pouvoirs, le quorum et les droits des membres demeurent fixés par la constitution."
$introductions[4]="Ce règlement encadre le service du bar, de l’ouverture à la fermeture. Il précise les refus de service, la protection des personnes mineures, la gestion des incidents et les responsabilités du personnel."
$plans=@{}
$plans[1]=@(
 @{title='Accès aux locaux et conjoints';keys=@('65','74')},
 @{title='Invités personnels et officiels';keys=@('75','95','96')},
 @{title='Personnes mineures et enfants';keys=@('67','69')},
 @{title='Tenue';keys=@('70')},
 @{title='Comportement et sécurité';keys=@('62','71','72','100')},
 @{title='Propreté et dommages';keys=@('66','63','94')},
 @{title='Tâches et responsabilités';keys=@('57')}
)
$plans[2]=@(
 @{title='Provenance dons et décorations';keys=@('R2.2','81')},
 @{title='Utilisation déplacement et retrait des biens';keys=@('76','80','79')},
 @{title='Dommages et assurances';keys=@('77','78','82')},
 @{title='Tâches et responsabilités';keys=@('R2.1','99')}
)
$plans[3]=@(
 @{title='Préparation et convocation';keys=@('13','17','19')},
 @{title='Déroulement des assemblées';keys=@('15','R3.8','18','20','21','22','R3.7')},
 @{title='Vote par internet';keys=@('R3.9')},
 @{title='Réunions du comité';keys=@('R3.10')},
 @{title='Communication et accès aux documents';keys=@('85','73','86','89','87','88','R3.3','R3.4','83','84')},
 @{title='Tâches et responsabilités';keys=@('16','R3.1','R3.2')}
)
$plans[4]=@(
 @{title='Portée et règles de service';keys=@('R4.1','56','59','68','58','R4.2')},
 @{title='Refus de service et incidents';keys=@('R4.3','61')},
 @{title='Ouverture et fermeture';keys=@('R4.4')},
 @{title='Rôles et responsabilités';keys=@('40','42','60')}
)
foreach($i in 1..4){
 $keys=@($plans[$i]|ForEach-Object{$_.keys})
 if($keys.Count -ne $units[$i].Count -or @($keys|Select-Object -Unique).Count -ne $keys.Count){throw "Répartition incomplète du R$i"}
 $number=0
 foreach($key in $keys){if(-not $units[$i].ContainsKey($key)){throw "Disposition absente : $key"};$number++;$mapping[$key]="R$i.$number"}
}
foreach($key in $merged.Keys){$mapping[$key]=$mapping[$merged[$key]]}
function Update-References([string]$text){
 # Les références aux articles constitutionnels conservent leur numérotation.
 $text=[regex]::Replace($text,'\bR[1-4]\.\d+\b',{param($m) if($mapping.ContainsKey($m.Value)){$mapping[$m.Value]}else{$m.Value}})
 $text=[regex]::Replace($text,'\b(articles?) (\d+)(?: et (\d+))?',{
  param($m)
  $first=$m.Groups[2].Value;$second=$m.Groups[3].Value
  $one=if($mapping.ContainsKey($first)){$mapping[$first]}else{$first}
  if($second){$two=if($mapping.ContainsKey($second)){$mapping[$second]}else{$second};return "$($m.Groups[1].Value) $one et $two"}
  return "$($m.Groups[1].Value) $one"
 })
 return $text
}
$newStatus='La constitution conserve ses repères; les règlements suivent une numérotation propre à chacun.'
foreach($i in 1..4){
 $front=[regex]::Match($documents[$i],'(?s)\A---.*?---\s*# [^\n]+\s*\*\*Version.*?(?=\r?\n\r?\n)').Value.Trim()
 $front=$front.Replace('Les numéros historiques sont conservés pour faciliter la comparaison; les articles déplacés figurent dans les règlements.',$newStatus)
 $body="$front`n`n$($introductions[$i])`n`n"
 foreach($section in $plans[$i]){
  $body+="## $($section.title)`n`n"
  foreach($key in $section.keys){$id=$mapping[$key];$paragraph=Update-References $units[$i][$key];$paragraph=[regex]::Replace($paragraph,'\bPCAM\b','président du comité du Mess');$body+="<a id=`"$($id.ToLower().Replace('.','-'))`"></a>**$id.** $paragraph`n`n"}
 }
 [IO.File]::WriteAllText((Join-Path $revisionDir "R$i-proposition.md"),$body.Trim()+"`n",$encoding)
}
$constitutionPath=Join-Path $revisionDir 'constitution-consolidee.md'
$constitution=[IO.File]::ReadAllText($constitutionPath)
$constitution=Update-References $constitution
$constitution=$constitution.Replace('Les numéros historiques sont conservés pour faciliter la comparaison; les articles déplacés figurent dans les règlements.',$newStatus)
[IO.File]::WriteAllText($constitutionPath,$constitution,$encoding)
$consolidatedPath=Join-Path $revisionDir 'reglement-consolide.md'
$old=[IO.File]::ReadAllText($consolidatedPath)
$prefix=[regex]::Match($old,'(?s)\A.*?(?=^## R1 )',[Text.RegularExpressions.RegexOptions]::Multiline).Value.Trim()
$prefix=$prefix.Replace('Les numéros historiques sont conservés pour faciliter la comparaison; les articles déplacés figurent dans les règlements.',$newStatus)
$full="$prefix`n`n"
foreach($i in 1..4){$page=[IO.File]::ReadAllText((Join-Path $revisionDir "R$i-proposition.md"));$title=[regex]::Match($page,'(?m)^# (.+)$').Groups[1].Value;$start=$page.IndexOf('## ');$full+="## $title`n`n$($introductions[$i])`n`n"+([regex]::Replace($page.Substring($start).Trim(),'(?m)^## ','### '))+"`n`n"}
[IO.File]::WriteAllText($consolidatedPath,$full.Trim()+"`n",$encoding)
$mapPath=Join-Path $revisionDir 'concordance.md'
$map=[IO.File]::ReadAllText($mapPath)
$map=[regex]::Replace($map,'(?m)^\| (\d+) \| (R[1-4]) \| (.*?) \|$',{param($m)$key=$m.Groups[1].Value;if(-not $mapping.ContainsKey($key)){throw "Concordance absente : $key"};"| $key | $($mapping[$key]) | $($m.Groups[3].Value) |"})
$map=$map.Replace('Les numéros historiques sont conservés.','La constitution conserve ses numéros. Les règlements suivent une numérotation propre; les anciens numéros ne servent ici que de repères de comparaison.')
$map+="`n## Concordance des clauses ajoutées`n`n| Ancien repère | Nouveau repère |`n|---|---|`n"
foreach($i in 1..4){foreach($section in $plans[$i]){foreach($key in $section.keys){if($key.StartsWith('R')){$map+="| $key | $($mapping[$key]) |`n"}}}}
[IO.File]::WriteAllText($mapPath,$map,$encoding)
$tablePath=Join-Path $revisionDir 'tableau-modifications.md'
$table=[IO.File]::ReadAllText($tablePath);$table=$table.Replace('Les numéros historiques sont conservés pour faciliter la comparaison; les articles déplacés figurent dans les règlements.',$newStatus)
$table+="`nLes numéros cités dans les comparaisons ci-dessus sont les repères historiques de la source ou des propositions précédentes. La concordance donne leur emplacement actuel. La réorganisation et la renumérotation de la version 0.2.7 ne modifient pas le fond des règles.`n"
[IO.File]::WriteAllText($tablePath,$table,$encoding)
$note=@"

## Organisation et numérotation de la version 0.2.7

Les règlements sont regroupés par sujet et suivent chacun une numérotation continue R1.1, R1.2, etc. Les tâches restent à la fin. Le fond des dispositions est conservé; seuls l’ordre, les titres, les repères et les renvois changent. La constitution conserve son ordre et ses numéros; seuls les renvois vers les règlements et la mention de version sont adaptés. La concordance conserve le suivi des dispositions sources et des clauses ajoutées.
"@
[IO.File]::AppendAllText((Join-Path $revisionDir 'notes-revision.md'),$note,$encoding)
Write-Output 'Règlements réorganisés et renumérotés; renvois et concordance mis à jour.'

$directory=@"
---
layout: default
title: Règlements du Mess
---

# Règlements du Mess

Version 0.2.7 du 28 octobre 2026 — Proposition à adopter et à approuver.

Chaque règlement constitue un document distinct. La constitution fixe les droits, les pouvoirs et les garanties; les règlements précisent les modalités pratiques.

## R1 Tenue et comportement

Tenue, accès, invités et comportement dans les locaux.

[Lire le règlement 1](R1-proposition.md)

## R2 Meubles et décorations

Utilisation et conservation des biens, provenance, dons et inventaire.

[Lire le règlement 2](R2-proposition.md)

## R3 Assemblées et réunions

Préparation et déroulement des séances, comptes rendus, accès aux documents et sauvegarde.

[Lire le règlement 3](R3-proposition.md)

## R4 Service de bar

Service responsable, refus de service, incidents et tâches du personnel.

[Lire le règlement 4](R4-proposition.md)

## Documents complémentaires

- [Constitution](constitution-consolidee.md)
- [Recueil complémentaire des quatre règlements](reglement-consolide.md)
- [Tableau des modifications](tableau-modifications.md)
"@
[IO.File]::WriteAllText((Join-Path $revisionDir 'reglements.md'),$directory,$encoding)
$note=@"

## Documents distincts et suppression des répétitions

La version 0.2.7 présente chaque règlement sur une page autonome avec une courte introduction. Le R2 devient « Meubles et décorations »; sa portée conserve les souvenirs, la provenance et les dons. La page Règlements donne accès aux quatre documents; le recueil reste un complément.

Le R3 renvoie aux délais constitutionnels des articles 25 et 115 au lieu de les reproduire, et conserve l’envoi des documents de séance au moins 7 jours avant. Il décrit la conduite pratique de la séance sans répéter qui exerce la présidence. La fiche d’inventaire du R2 conserve ses renseignements pratiques et renvoie à l’article 37 pour le titulaire de la fonction. Le classement des dossiers est décrit comme une modalité, sans réénoncer la fonction constitutionnelle du secrétaire. La constitution est conservée, hormis la version et le nouveau titre du R2.
"@
[IO.File]::AppendAllText((Join-Path $revisionDir 'notes-revision.md'),$note,$encoding)
$tableRow=@"
| Documents autonomes et répétitions | Règles, rappels constitutionnels et tâches présentés ensemble dans la source | Quatre documents avec une introduction chacun; R2 Meubles et décorations; renvois à la constitution pour les délais et les titulaires de fonctions | Les répétitions allongent la lecture et risquent de créer deux formulations d’une même règle. Les modalités pratiques restent dans les règlements, avec une seule référence pour la règle constitutionnelle. | R2 et R3; introductions; page Règlements |
"@
# Ajouter la ligne au tableau avant son paragraphe explicatif final.
$tablePath=Join-Path $revisionDir 'tableau-modifications.md'
$table=[IO.File]::ReadAllText($tablePath)
$table=$table.Replace("`nLes numéros cités", "`n"+$tableRow+"`nLes numéros cités")
[IO.File]::WriteAllText($tablePath,$table,$encoding)
$clarification=@"

## Lecture autonome de la version 0.2.7

Le R1 est rédigé par situations : accès aux locaux et conjoints, invités, personnes mineures et enfants, tenue, comportement, propreté et dommages, puis responsabilités. Les articles sources 64 et 95 sont fusionnés pour l’accompagnement, 70 et 97 pour la tenue, 66 et 98 pour la propreté. La concordance suit ces fusions; les 116 dispositions sources restent repérables, même si plusieurs aboutissent désormais à une règle commune.

La présence d’enfants sous surveillance est présentée comme une situation distincte des invités personnels et des conjoints mineurs autorisés. Cette rédaction rapproche les anciens articles 67 et 69, dont la juxtaposition était ambiguë; elle conserve les conditions de présence des enfants, leur départ avant 19 h aux activités officielles sauf activités familiales, et l’interdiction d’alcool aux personnes de moins de 18 ans. Cette clarification doit être comprise et validée lors de l’examen de la proposition.

Le titulaire de l’inventaire est nommé dans le R2, les destinataires d’un rapport d’incident sont explicités dans le R4 et les abréviations de fonction sont développées. La constitution conserve son contenu. Les règlements peuvent se lire chacun de façon suivie, tout en restant soumis à la constitution pour les pouvoirs et approbations.
"@
[IO.File]::AppendAllText((Join-Path $revisionDir 'notes-revision.md'),$clarification,$encoding)
$tablePath=Join-Path $revisionDir 'tableau-modifications.md'
$table=[IO.File]::ReadAllText($tablePath)
$editorialRow=@"
| Lecture autonome du R1 | Conditions d’accès, invités, enfants et alcool mêlés aux art. 64, 65, 67, 69, 74, 75 et 95 à 98 | Sections distinctes; accompagnement, tenue et propreté regroupés; cas des enfants présenté à part | La juxtaposition des clauses rendait incertain à qui chaque règle s’applique. Le lecteur suit désormais sa situation sans devoir reconstruire les liens entre plusieurs paragraphes. | R1 et concordance des fusions; précisions de fonction aux R2 et R4 |
"@
$table=$table.Replace("`nLes numéros cités","`n"+$editorialRow+"`nLes numéros cités")
[IO.File]::WriteAllText($tablePath,$table,$encoding)
$attireNote=@"

## Tenue précisée dans la version 0.2.7

La section tenue du R1 est présentée par points : vêtements, torse et chaussures, couvre-chef, uniforme, tenue minimale et personnel du bar. Le terme couvre-chef remplace l’énumération des modèles. La conformité de l’uniforme aux Instructions A-DH-265-000/AG-001 et aux directives applicables est explicitée. Le chapitre 2 officiel est cité; il traite du port de l’uniforme et du retrait de la coiffure au mess, avec exceptions religieuses et pour le personnel exerçant ses fonctions.
"@
[IO.File]::AppendAllText((Join-Path $revisionDir 'notes-revision.md'),$attireNote,$encoding)
$attireRow=@"
| Tenue et uniforme | Art. 70 source : énumération de couvre-chefs et consignes de tenue regroupées | Règles par points; terme couvre-chef; conformité de l’uniforme aux Instructions A-DH-265-000/AG-001 et prise en compte des exceptions applicables | Une liste claire facilite l’application. La référence militaire évite qu’une règle locale soit interprétée comme une autorisation de porter un uniforme non conforme. | R1.8 et référence officielle au chapitre 2 |
"@
$tablePath=Join-Path $revisionDir 'tableau-modifications.md'
$table=[IO.File]::ReadAllText($tablePath).Replace("`nLes numéros cités","`n"+$attireRow+"`nLes numéros cités")
[IO.File]::WriteAllText($tablePath,$table,$encoding)

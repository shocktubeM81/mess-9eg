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
$introductions=@{}
$introductions[1]="Ce règlement précise la tenue, le comportement et les conditions pratiques de fréquentation du Mess. Il s’applique aux membres et à leurs invités afin de préserver des lieux accueillants, propres et respectueux."
$introductions[2]="Ce règlement encadre l’utilisation, la conservation et la présentation des meubles, décorations et souvenirs du Mess. Il précise aussi la provenance des biens, les conditions d’acceptation des dons et les renseignements à conserver à l’inventaire."
$introductions[3]="Ce règlement explique comment préparer et tenir les assemblées et les réunions, puis en consigner et communiquer les résultats. Il précise aussi l’accès aux documents, leur archivage et leur sauvegarde; les pouvoirs, le quorum et les droits des membres demeurent fixés par la constitution."
$introductions[4]="Ce règlement encadre le service du bar, de l’ouverture à la fermeture. Il précise les refus de service, la protection des personnes mineures, la gestion des incidents et les responsabilités du personnel."
$plans=@{}
$plans[1]=@(
 @{title='Accès et invités';keys=@('65','67','69','74','75','95','96')},
 @{title='Tenue';keys=@('70','97')},
 @{title='Comportement et sécurité';keys=@('62','64','71','72','100')},
 @{title='Propreté et dommages';keys=@('66','98','63','94')},
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
  foreach($key in $section.keys){$id=$mapping[$key];$paragraph=Update-References $units[$i][$key];$body+="<a id=`"$($id.ToLower().Replace('.','-'))`"></a>**$id.** $paragraph`n`n"}
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
$table+="`nLes numéros cités dans les comparaisons ci-dessus sont les repères historiques de la source ou des propositions précédentes. La concordance donne leur emplacement actuel. La réorganisation et la renumérotation de la version 0.2.5 ne modifient pas le fond des règles.`n"
[IO.File]::WriteAllText($tablePath,$table,$encoding)
$note=@"

## Organisation et numérotation de la version 0.2.5

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

Version 0.2.5 du 28 octobre 2026 — Proposition à adopter et à approuver.

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

La version 0.2.5 présente chaque règlement sur une page autonome avec une courte introduction. Le R2 devient « Meubles et décorations »; sa portée conserve les souvenirs, la provenance et les dons. La page Règlements donne accès aux quatre documents; le recueil reste un complément.

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
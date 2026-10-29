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
 $body="$front`n`n"
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
foreach($i in 1..4){$page=[IO.File]::ReadAllText((Join-Path $revisionDir "R$i-proposition.md"));$title=[regex]::Match($page,'(?m)^# (.+)$').Groups[1].Value;$start=$page.IndexOf('## ');$full+="## $title`n`n"+([regex]::Replace($page.Substring($start).Trim(),'(?m)^## ','### '))+"`n`n"}
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
$table+="`nLes numéros cités dans les comparaisons ci-dessus sont les repères historiques de la source ou des propositions précédentes. La concordance donne leur emplacement actuel. La réorganisation et la renumérotation de la version 0.2.4 ne modifient pas le fond des règles.`n"
[IO.File]::WriteAllText($tablePath,$table,$encoding)
$note=@"

## Organisation et numérotation de la version 0.2.4

Les règlements sont regroupés par sujet et suivent chacun une numérotation continue R1.1, R1.2, etc. Les tâches restent à la fin. Le fond des dispositions est conservé; seuls l’ordre, les titres, les repères et les renvois changent. La constitution conserve son ordre et ses numéros; seuls les renvois vers les règlements et la mention de version sont adaptés. La concordance conserve le suivi des dispositions sources et des clauses ajoutées.
"@
[IO.File]::AppendAllText((Join-Path $revisionDir 'notes-revision.md'),$note,$encoding)
Write-Output 'Règlements réorganisés et renumérotés; renvois et concordance mis à jour.'

$ErrorActionPreference='Stop'
$dir=Join-Path $PSScriptRoot 'versions/2026-10-28-v0.2'
New-Item -ItemType Directory -Force $dir | Out-Null
$enc=New-Object System.Text.UTF8Encoding($false)
function Save($name,$body){[IO.File]::WriteAllText((Join-Path $dir $name),($body.Trim().Replace([char]0x02BC,[char]0x2019)+"`n"),$enc)}
$src=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'constitution.md'))
$a=@{}; $edit=@{}
foreach($m in [regex]::Matches($src,'(?ms)<a id="article-(\d+)"></a>\*\*\d+\.\*\* (.*?)(?=<a id="article-|\z)')){
$t=[regex]::Replace($m.Groups[2].Value,'(?s)<!--.*?-->','')
$a[[int]$m.Groups[1].Value]=[regex]::Replace($t,'(?m)^## .*$','').Trim()
}
if($a.Count -ne 116){throw 'Source incomplète'}
$edit[1]='Les références DOAD 5045-0 et A-PS-110-001/AG-002 citées dans la source demeurent applicables sous réserve de leur version en vigueur. La constitution fixe les droits des membres, les organes de décision et les garanties financières. Quatre règlements en précisent les modalités : R1 tenue et comportement; R2 mobilier, décorations, souvenirs, provenance et dons; R3 assemblées et réunions; R4 service de bar. Un règlement ne peut modifier un pouvoir réservé aux membres ni contourner une approbation requise. Le terme commandant désigne le commandant du 9 EG; les fonctions sʼappliquent sans distinction de genre.'
$edit[5]='Une assemblée générale des membres est tenue chaque trimestre. Le calendrier annuel tient compte des entraînements et est communiqué aux membres. Les réunions du comité préparent et exécutent les décisions; elles ne remplacent aucune assemblée trimestrielle.'
$edit[7]='Un rapport financier sommaire est présenté à chaque assemblée générale. Il distingue les opérations du Mess, le fonds cadeau et, le cas échéant, les opérations relatives au fonds dʼunité, sans confondre leur propriété ni leur autorité financière.'
$edit[13]='Le calendrier tient compte de la disponibilité estivale. Une assemblée peut être planifiée avant le 30 mai et une autre après le 30 août, dans leurs trimestres respectifs. Lʼabsence de quorum entraîne une nouvelle convocation et ne transfère aucun pouvoir au comité.'
$edit[15]='Les délibérations dʼune assemblée générale ne sont valides que si le quorum prévu à lʼarticle 8 de la constitution est atteint. Le seul nombre des présents ne constitue pas le quorum.'
$edit[17]='Le secrétaire transmet à tous les membres lʼavis de convocation au moins 14 jours avant lʼassemblée, puis lʼordre du jour et les documents utiles au moins 7 jours avant. Toute proposition de modification est communiquée et affichée au moins 15 jours avant son étude, conformément à lʼarticle 115. Lʼavis et lʼordre du jour sont également affichés dans les locaux.'
$edit[20]='Une proposition à lʼassemblée vise à faire prendre position aux membres. Les membres ayant droit de vote peuvent proposer une motion, sauf le président de séance; le commandant ne propose pas de motion. Le membre obtient la parole du président, qui reformule le texte pour assurer sa compréhension. Le comité peut recommander une décision, mais ne dispose pas du vote réservé aux membres.'
$edit[22]='Une proposition recevable, appuyée et reformulée est débattue par lʼassemblée et ne peut être écartée hors de ses procédures. Chaque membre doit pouvoir sʼexprimer.'
$edit[23]=@"
Une proposition est adoptée si elle recueille strictement plus de la moitié des voix exprimées par les membres ayant droit de vote, sans compter les abstentions. En cas dʼégalité, un recomptage est effectué; en cas de nouvelle égalité, le président de séance tranche par sa voix prépondérante, seule occasion où il vote. Il ne propose, nʼamende ni nʼappuie une motion. Un vote erroné fait lʼobjet dʼun nouveau vote. Les seuils particuliers, notamment pour la destitution, demeurent applicables.

Les votes par internet restent possibles en privilégiant les assemblées : proposition étudiée et publiée par le comité; aucune dépense supérieure à 200 dollars; participation facultative; votants membres ordinaires actifs et en règle pour lʼexercice; quorum de lʼarticle 8; délai minimal de 15 jours; maintien du veto du commandant. Le secrétaire conserve le texte, les dates, le résultat et la preuve du quorum. Ces votes ne remplacent ni les assemblées trimestrielles ni les procédures dʼamendement des articles 114 à 116.
"@
$edit[25]='Lʼavis est transmis à tous les membres au moins 14 jours avant lʼassemblée, même si sa date a été annoncée à la séance précédente. Les propositions de modification sont communiquées et affichées au moins 15 jours avant leur étude. Le calendrier annuel ne dispense pas de ces avis.'
$edit[35]='Le comité prépare les dossiers, exécute les décisions des membres et gère les affaires courantes dans les limites du budget et des délégations approuvés. Il rend compte à lʼassemblée et sert dʼintermédiaire avec le commandant. Les élections, destitutions, cotisations, budgets et amendements réservés aux membres ne peuvent être décidés à leur place par le comité. Celui-ci obtient les approbations requises avant exécution.'
$edit[73]='Les avis sont affichés selon les autorisations applicables du commandant. Le secrétaire organise les validations en amont pour respecter les délais du R3. Le tableau complète le canal direct de communication aux membres.'
$edit[79]='Aucun bien du Mess ne peut être retiré ou vendu sans lʼapprobation du comité, dans les limites de ses délégations et du budget voté. Hors de ces limites, lʼopération est soumise à lʼassemblée et aux approbations requises. La propriété et les conditions de don ou de prêt sont vérifiées avant toute disposition.'
$edit[81]='Toute décoration permanente, plaque, tableau ou trophée requiert lʼapprobation du comité dans les limites de ses pouvoirs avant installation. Lʼinventaire indique provenance, propriétaire et conditions du don ou du prêt. Une inscription commémorative ne prouve pas la propriété.'
$edit[83]='Un registre physique ou numérique reçoit suggestions, plaintes et commentaires. Le comité en assure le suivi et soumet aux membres les questions de leur compétence. Les dossiers individuels sont protégés; le suivi collectif est communiqué sans renseignements personnels.'
$edit[85]='Le secrétaire communique de façon proactive les avis, ordres du jour, propositions, décisions et mises à jour par un canal commun accessible à tous les membres, complété par lʼaffichage. Un accès équivalent est offert aux membres qui nʼutilisent pas le canal numérique.'
$edit[86]='Les documents sont validés par lʼautorité compétente avant diffusion. Les procès-verbaux non adoptés sont identifiés comme projets. Adoption et approbations sont indiquées séparément. Les validations sont organisées pour respecter les délais de consultation et de convocation.'
$edit[87]='La constitution et les quatre règlements en vigueur sont accessibles en permanence aux membres dans un répertoire commun et dans les locaux. Les procès-verbaux adoptés, décisions, budgets et rapports financiers destinés aux membres y sont aussi accessibles. Les anciennes versions sont archivées et distinguées. Le site public ne remplace pas cet accès réservé aux membres.'
$edit[88]='À son admission, chaque membre reçoit les textes ou un accès direct, avec copie sur demande. Il est informé de lʼemplacement des documents, du canal dʼavis et du moyen de soumettre une question. Toute modification approuvée est annoncée aux membres : déposer un fichier sans avis ne suffit pas.'
$edit[89]='Le calendrier et les avis dʼactivités sont affichés et communiqués directement aux membres. Un relevé des décisions et le projet de procès-verbal sont accessibles dans les 14 jours suivant lʼassemblée, avec indication des approbations encore attendues. Le procès-verbal adopté remplace ensuite le projet. Ce délai est une modalité proposée dans la présente révision.'
$edit[59]="Le personnel du bar ne doit ni vendre ni servir de boisson alcoolisée à une personne en état d’ébriété ou qui en présente manifestement les signes. Il refuse ou interrompt immédiatement le service et en informe le responsable de service. Le grade, la fonction, le paiement ou l’insistance du client ne permettent pas de passer outre ce refus. Aucun autre serveur ne doit le contourner en servant cette personne."
$edit[68]="Aucune boisson alcoolisée ne peut être vendue ou servie à une personne de moins de 18 ans. En cas de doute sur l’âge, le serveur demande une pièce d’identité permettant de le vérifier; si l’âge ne peut être établi, il refuse le service. Il ne sert pas non plus une personne qui achète pour remettre la boisson à un mineur ou contourner un refus de service."
# Répartition affinée après la demande du 28 octobre 2026.
$edit[8]="Le quorum dʼune assemblée générale ordinaire ou extraordinaire est formé de plus de 50 % des membres ordinaires en règle et disponibles en région. Aucune décision de lʼassemblée ne peut être prise sans ce quorum. La vérification et la nouvelle convocation sont précisées au R3."
$edit[23]="Les décisions de lʼassemblée sont adoptées à une majorité strictement supérieure à la moitié des voix exprimées par les membres ayant droit de vote, sans compter les abstentions, sauf seuil particulier prévu à la constitution. Le président de séance ne propose, nʼamende ni nʼappuie de motion et ne vote que pour trancher une égalité confirmée selon le R3. Les votes par internet sont permis sous réserve du quorum de lʼarticle 8, de la qualité de membre ordinaire actif et en règle, dʼun délai minimal de 15 jours, de la priorité aux assemblées et du maintien du veto du commandant. Ils ne peuvent autoriser une dépense supérieure à 200 dollars ni remplacer les assemblées trimestrielles ou les procédures dʼamendement des articles 114 à 116. Le R3 fixe les modalités de préparation, de scrutin et de consignation."
$edit[25]="Chaque membre reçoit un avis de convocation au moins 14 jours avant lʼassemblée, même si sa date a déjà été annoncée. Toute proposition de modification est communiquée et affichée au moins 15 jours avant son étude. Le R3 précise la transmission des avis, de lʼordre du jour et des documents, sans réduire ces délais ni les droits des membres."
$edit[15]="À l’ouverture, le secrétaire vérifie les présences au regard du quorum fixé par la constitution et en inscrit le résultat au procès-verbal. Le président applique les modalités du R3.8 si le quorum manque."
$edit[20]="Le membre qui souhaite proposer une motion demande la parole au président de séance. Le texte de la proposition est formulé clairement, puis reformulé par le président pour que tous sachent sur quoi porte le débat. Le secrétaire en consigne le libellé. La recevabilité et les personnes habilitées à proposer sont déterminées par la constitution."
$edit[22]="Le président ouvre le débat sur la proposition appuyée, donne la parole à une personne à la fois et recentre les interventions sur le texte discuté. Le secrétaire consigne les amendements et le libellé finalement soumis au vote. Le président applique les droits et pouvoirs fixés par la constitution."
# Simplification de la lecture et suppression des contraintes estivales.
$edit[13]="Les dates, le lieu et, s’il y a lieu, le moyen de connexion sont indiqués dans la convocation. Aucune période de l’année n’est exclue pour tenir une assemblée ou une réunion."
$edit[15]="Le quorum est vérifié et consigné selon la procédure du R3.8, en appliquant le seuil fixé par la constitution."
$edit[16]="Le président, ou le vice-président en son absence, dirige la séance. Il distribue la parole, évite les répétitions et veille au respect de l’ordre du jour et des procédures. Les interventions lui sont adressées, une personne à la fois."
$edit[18]="L’assemblée suit normalement cet ordre : ouverture et vérification du quorum; adoption du procès-verbal précédent; rapports du président, des finances et des sous-comités; suivi des décisions; nouvelles affaires; levée de la séance. Le procès-verbal transmis à l’avance n’a pas à être relu intégralement."
$edit[19]="Les propositions importantes ou complexes sont accompagnées des renseignements utiles à leur discussion et transmises avec les documents de séance, selon les délais applicables."
$r1=@(57,62,63,64,65,66,67,69,70,71,72,74,75,94,95,96,97,98,100)
$r2=@(76..82)+@(99)
$r3=@(13,15,16,17,18,19,20,21,22,73,83,84,85,86,87,88,89)
$r4=@(40,42,56,58,59,60,61,68)
$core=@(1..116|Where-Object{$_ -notin $r1 -and $_ -notin $r2 -and $_ -notin $r3 -and $_ -notin $r4})




function Blocks($ns){$out=foreach($n in $ns){$b=if($edit.ContainsKey($n)){$edit[$n]}else{$a[$n]};$heading=''
if($ns -contains 1){
$headings=@{1='Identité et membres';5='Assemblées générales';23='Votes et élections';26='Composition et pouvoirs du comité';36='Responsabilités administratives';43='Finances et cotisations';90='Réceptions privées';101='Activités';105='Fonds cadeau';112='Plaintes et suggestions';114='Modification des textes'}
if($headings.ContainsKey([int]$n)){$heading="## $($headings[[int]$n])`n`n"}
}
"$heading<a id=`"article-$n`"></a>**$n.** $b"};$out -join "`n`n"}
$status='**Version 0.2.3 du 28 octobre 2026 — Proposition à discuter et à adopter.** Entrée en vigueur après ratification des membres avec quorum et approbation du commandant. Les numéros historiques sont conservés pour faciliter la comparaison; les articles déplacés figurent dans les règlements.'
$funds=@"
## Assemblées et portée des règlements

**C4.** Les assemblées générales sont les instances de délibération et de décision des membres. Chaque membre peut participer aux discussions selon sa catégorie; le droit de vote est réservé aux membres ordinaires en règle, sous les exclusions et règles particulières de la constitution. Le président, ou le vice-président en son absence, préside les assemblées. Le R3 encadre la prise de parole, les propositions, les débats, les scrutins et les procès-verbaux sans modifier la fréquence des assemblées, le quorum, les droits de vote, les décisions réservées aux membres ni les approbations requises.

## Fonds et garanties financières

**C1.** Les cotisations du Mess sont affectées aux besoins du Mess. Le fonds dʼunité ne peut être assimilé au fonds du Mess ni être alimenté par un simple changement dʼétiquette des cotisations. Toute opération respecte la propriété et la destination des biens non publics (BNP), les règles financières applicables et les approbations nécessaires.

**C2.** Le fonds cadeau fait lʼobjet dʼun suivi distinct des opérations du Mess et du fonds dʼunité. Sa qualification, ses sources admissibles et son mode de comptabilisation sont confirmés auprès de lʼautorité compétente BNP avant toute nouvelle modalité de financement ou tout transfert. Le suivi distinct ne crée ni personnalité juridique ni compte bancaire autonome.

**C3.** Les membres votent les cotisations, le budget et les changements aux prestations. Le comité exécute dans ses délégations. Un vote ne dispense pas des approbations du commandant ou des autorités financières compétentes. La présente révision nʼautorise automatiquement aucun transfert entre fonds. Les bénéficiaires et plafonds existants des cadeaux sont conservés dans la section financière de la constitution, sous réserve de leur admissibilité aux règles applicables.
## Suivi des fonds

**C5.** Le trésorier présente distinctement pour chaque fonds concerné les soldes dʼouverture et de clôture, les sources de revenus, les dépenses et les engagements. Chaque opération indique source, objet, bénéficiaire, justificatif, vote ou délégation et approbations. Les livres demeurent tenus par un tiers selon lʼarticle 39 et les exigences de paiement et de double signature de lʼarticle 46 sont maintenues.

**C6.** Avant mise en place ou modification du financement du fonds dʼunité ou du fonds cadeau, le comité obtient confirmation écrite de la qualification BNP, des sources admissibles, de la destination et des autorités dʼapprobation. Il soumet aux membres une proposition chiffrée identifiant les comptes ou suivis concernés. Cette clause nʼautorise ni cotisation nouvelle, ni prélèvement, ni transfert. Les articles 105 à 111 conservent leurs bénéficiaires et plafonds; leur déplacement ne vaut pas autorisation nouvelle de dépense.
"@
Save 'constitution-consolidee.md' ("# Constitution du Mess et Instituts du 9e Escadron du génie`n`n$status`n`nManège militaire de Rouyn-Noranda, 97, rue Perreault Est, Rouyn-Noranda, Québec.`n`nLa constitution établit les droits, les organes et les garanties; les quatre règlements en précisent les modalités. Les articles historiques absents de cette constitution sont reproduits dans les règlements, selon la concordance.`n`n"+(Blocks @($core|Where-Object{$_ -notin @(36,37,38,39,41)}))+"`n`n"+$funds+"`n`n## Tâches et responsabilités`n`n"+(Blocks @(36,37,38,39,41)))
$extra2=@"
## Provenance et dons

**R2.1.** Le vice-président tient un inventaire distinguant biens du Mess, de la Couronne, du fonds dʼunité et de tiers. Chaque fiche indique description, emplacement, provenance, date dʼentrée, propriétaire, valeur connue, justificatif et conditions dʼutilisation ou de restitution. Une provenance incertaine est signalée et vérifiée avant disposition.

**R2.2.** Avant acceptation dʼun don, le comité documente le donateur, le bien, les conditions, la destination et les coûts dʼentretien. Il obtient les approbations exigées selon la nature et la propriété du bien. Aucun reçu fiscal, avantage ou transfert de propriété nʼest promis sans autorité. Les coordonnées personnelles sont protégées dans la version du registre destinée aux membres.
"@
$extra3=@"
## Procédure et déroulement des assemblées

Les principes des assemblées, leur fréquence, le quorum, les droits des membres, les règles de majorité, les délais minimaux de convocation et les pouvoirs du comité figurent dans la constitution. Le présent règlement en organise la mise en œuvre. Les articles 13 et 15 à 22 précisent la convocation, la vérification du quorum, la préparation et le déroulement; ils ne délèguent aucun pouvoir supplémentaire au comité.

**R3.7.** Lors du scrutin, le président fait procéder au décompte des voix. En cas d’égalité, il ordonne un recomptage; si l’égalité subsiste, il exerce la voix prépondérante prévue à l’article 23 de la constitution. Un vote erroné fait l’objet d’un nouveau vote. Le procès-verbal consigne le texte de la proposition, le résultat, les abstentions et l’application éventuelle d’un seuil particulier.

**R3.8.** Le secrétaire vérifie et consigne le quorum au début de la séance et lorsqu’une perte de quorum est signalée. Si le quorum n’est pas atteint 30 minutes après l’heure prévue, l’assemblée est annulée et une nouvelle convocation est organisée conformément à la constitution. Si le quorum est perdu pendant la séance, aucune nouvelle décision n’est prise; les points non décidés sont reportés et les membres en sont informés.

**R3.9.** Pour un vote par internet autorisé par la constitution, le comité étudie et communique la proposition avant le scrutin. L’avis indique le texte exact, les membres admissibles, les dates d’ouverture et de clôture et le moyen de voter. La participation reste facultative. Le secrétaire vérifie l’admissibilité et le quorum et conserve le texte, les dates, le décompte et la preuve du quorum; il communique le résultat en précisant les approbations encore attendues.

## Déroulement des réunions du comité

**R3.10.** Pour une réunion du comité convoquée selon la constitution, le secrétaire communique la date, le lieu ou le moyen de connexion, les sujets et les pièces utiles aux participants. Le président présente les points à traiter, distribue la parole et fait préciser les suites à donner. Le compte rendu distingue décisions relevant de la délégation du comité, tâches de préparation et recommandations à présenter à l’assemblée. Il désigne un responsable et une échéance pour chaque suivi. Les décisions et recommandations communicables sont diffusées aux membres conformément aux règles documentaires ci-dessous. Cette procédure ne crée ni quorum ni pouvoir de décision nouveau pour le comité.

## Gestion documentaire et continuité

**R3.1.** Le secrétaire tient un répertoire structuré : constitution, règlements, convocations, ordres du jour, procès-verbaux, décisions, budgets, rapports financiers, inventaires et correspondance officielle. Chaque document porte date, version, statut et preuves dʼadoption et dʼapprobation requises. Le registre des décisions précise responsable, échéance et suivi. Les dossiers du comité et ceux des assemblées sont distincts et reliés par les recommandations et décisions correspondantes.

**R3.2.** Le secrétaire et un suppléant désigné disposent dʼun accès de continuité. Une sauvegarde indépendante du répertoire courant est effectuée au moins mensuellement et après toute adoption ou approbation. La restauration est vérifiée au moins annuellement et lors de la relève du secrétaire. La relève comprend inventaire des dossiers, transfert sécurisé des accès et décisions en cours. Les documents sont conservés selon les exigences applicables; aucune durée réglementaire non vérifiée nʼest créée ici.

**R3.3.** Tous les membres ont accès aux documents de gouvernance. Coordonnées, dossiers individuels, données médicales, renseignements de sécurité et finances personnelles sont protégés. Une version expurgée permet la consultation du contenu collectif. Toute restriction est expliquée au demandeur, qui peut la soumettre au président puis à lʼautorité compétente. La confidentialité ne permet pas de cacher une décision collective ou son incidence financière.

**R3.4.** Les comptes rendus du comité destinés aux membres distinguent les décisions prises dans sa délégation et les recommandations à voter, avec les mêmes précautions de confidentialité. Le site public diffuse les textes autorisés. Les documents réservés aux membres et les pièces confidentielles restent dans un répertoire interne aux accès appropriés et ne sont pas publiés sur GitHub.


"@
$extra4=@"
## Application du service responsable

**R4.1.** Le présent règlement porte sur la préparation, la vente, le service et la fermeture du bar. Les règles de réservation des locaux, les pouvoirs administratifs et les autorisations financières figurent dans la constitution; la conduite générale et la propreté des lieux relèvent du R1.

**R4.2.** Le serveur demeure sobre pendant son service, observe les clients et applique sans délai les refus prévus aux articles 59 et 68. En cas de doute sur la capacité d’une personne à consommer sans danger, il suspend le service et consulte le responsable. Une difficulté de santé ou de communication ne doit pas être assimilée automatiquement à l’ébriété; si une personne semble en détresse, le responsable organise l’aide appropriée.

**R4.3.** Le refus est expliqué calmement. Le responsable appuie le serveur, propose au besoin de l’eau ou une boisson sans alcool et aide à organiser un retour sécuritaire. En cas de menace, de malaise ou de danger immédiat, il suspend le service et appelle les services d’urgence appropriés. Un relevé factuel de l’incident est transmis à l’autorité prévue à l’article 61 et conservé avec un accès restreint.

**R4.4.** Avant l’ouverture, le responsable vérifie la présence de personnel autorisé, l’hygiène, les stocks, les prix affichés et les conditions applicables au service. À la fermeture, le personnel cesse les ventes, sécurise boissons, caisse et accès, nettoie le matériel et signale tout écart ou incident au régisseur. Les ventes à emporter et les formats de vente mentionnés à l’article 40 ne peuvent être pratiqués que si les autorisations applicables les permettent.
"@
$titles=@('R1 Tenue et comportement','R2 Mobilier décorations souvenirs provenance et dons','R3 Assemblées et réunions','R4 Service de bar')
$groups=@($r1,$r2,$r3,$r4);$extras=@('',$extra2,$extra3,$extra4)
$full="# Règlement intégral consolidé du Mess et Instituts du 9e Escadron du génie`n`n$status`n`nLes quatre règlements suivants constituent le texte intégral proposé. Les droits et garanties de la constitution leur sont applicables.`n`n"
for($i=0;$i -lt 4;$i++){$b=(Blocks $groups[$i])+"`n`n"+$extras[$i];if($i -eq 0){$b=(Blocks @($r1|Where-Object{$_ -ne 57}))+"`n`n## Tâches et responsabilités`n`n"+(Blocks @(57))};if($i -eq 1){$inventory=[regex]::Match($extra2,'(?s)\*\*R2\.1\..*?(?=\*\*R2\.2\.)').Value.Trim();$donation=[regex]::Match($extra2,'(?s)\*\*R2\.2\..*').Value.Trim();$b=(Blocks $r2)+"`n`n## Provenance et dons`n`n"+$donation+"`n`n## Tâches et responsabilités`n`n"+$inventory};if($i -eq 2){$records=[regex]::Match($extra3,'(?s)\*\*R3\.1\..*?(?=\*\*R3\.3\.)').Value.Trim();$procedures=$extra3.Replace($records,'').Replace('## Gestion documentaire et continuité','## Accès aux documents et communication');$b="## Préparation et déroulement`n`n"+(Blocks @($r3|Where-Object{$_ -ne 16}))+"`n`n"+$procedures+"`n`n## Tâches et responsabilités`n`n"+(Blocks @(16))+"`n`n"+$records};if($i -eq 3){$b="## Règles de service`n`n"+(Blocks @(56,58,59,61,68))+"`n`n"+$extra4+"`n`n## Rôles et responsabilités`n`n"+(Blocks @(40,42,60))};Save ("R{0}-proposition.md" -f ($i+1)) ("# $($titles[$i])`n`n$status`n`n"+$b);$full+="## $($titles[$i])`n`n$b`n`n"}
Save 'reglement-consolide.md' $full
Save 'lettre-presentation.md' @"
# Présentation de la révision des documents du Mess

28 octobre 2026 — Version 0.2.3 proposée

Aux membres du Mess et Instituts du 9e Escadron du génie,

Je vous soumets une révision visant à rendre nos documents plus simples à consulter et notre administration plus facile à suivre.

La constitution actuelle mêle les droits des membres à de nombreux détails pratiques, ce qui rend les règles essentielles difficiles à repérer. La proposition conserve les droits, les pouvoirs et les garanties financières dans la constitution et regroupe les modalités dans quatre règlements. Ceux-ci restent soumis au vote des membres et aux approbations requises : cette organisation facilite la consultation et les mises à jour sans donner au comité le pouvoir de modifier seul les règles.

La confusion entre comité et assemblée peut rendre incertain le lieu où une décision doit être prise. La proposition distingue la préparation et la gestion courante du comité des décisions réservées aux membres. La constitution conserve expressément la fréquence trimestrielle, le quorum, les droits de vote, les délais minimaux de convocation et les pouvoirs des membres; le R3 précise la procédure et le déroulement des assemblées.

Des dossiers dispersés ou conservés sans être communiqués nuisent à la continuité et à la participation. Dans le prolongement des assemblées et réunions, le R3 prévoit classement commun, sauvegardes, relève documentée et communication proactive des avis, décisions et documents accessibles aux membres. Chacun pourra consulter les textes, comprendre les décisions et se sentir inclus, avec protection des renseignements personnels.

Enfin, le suivi distinct du fonds dʼunité, du fonds cadeau et des opérations du Mess clarifie lʼorigine et lʼutilisation des sommes. Toute nouvelle affectation demeure conditionnelle à la vérification des règles BNP et aux approbations nécessaires.

Le tableau Avant Après Pourquoi présente uniquement les changements. Les propositions séparées et les textes consolidés permettent dʼexaminer leur mise en œuvre avant le vote et lʼapprobation du commandant.
"@
$rows=@(
@('Organisation','116 articles dans un seul texte','Constitution et quatre règlements','Les droits essentiels sont difficiles à repérer parmi les détails. La séparation facilite lecture et mise à jour en maintenant les approbations.','Art. 1; concordance'),
@('Assemblées','Art. 5 : trimestrielles ou selon décision; exclusion estivale art. 13','Une assemblée par trimestre, sans exclusion estivale','Un report ou une réunion du comité pourrait remplacer la participation des membres. La fréquence devient explicite.','Constitution art. 5, 7, 8, 12, 14, 23, 25, 35 et C4; R3 art. 13, 15 à 22 et R3.7 à R3.9'),
@('Quorum','Art. 8 : plus de 50 %; art. 15 : nombre des présents','Seuil unique de lʼart. 8','Deux formulations rendent incertaine la validité des décisions. Le renvoi maintient la garantie existante.','Art. 15'),
@('Avis','Art. 17 : 7 jours; art. 25 : 2 semaines ou annonce; art. 115 : 15 jours','Avis 14 jours; documents 7 jours; amendements 15 jours','Les délais concurrents compliquent la préparation. Leur articulation donne aux membres le temps de préparer leurs questions.','Art. 17, 25'),
@('Pouvoir de décision','Art. 20 et 22 parlent du Comité; majorité formulée 50 % plus un','Assemblée compétente et majorité strictement supérieure à la moitié des voix exprimées','Le vocabulaire peut suggérer un transfert de pouvoir et rendre le calcul ambigu. Le texte précise qui décide et comment.','Art. 20, 22, 23, 35'),
@('Biens et dons','Approbation du conseil aux art. 79 et 81; pas de registre de provenance détaillé','Comité dans ses délégations; propriété, provenance et conditions documentées','La présence au Mess ne prouve pas la propriété. Le registre prévient les dispositions contraires aux dons et prêts.','Art. 79, 81; R2.1 et R2.2'),
@('Communication','Tableau, livre et copie des textes aux art. 73, 83, 85 à 89','Canal direct, accès commun, avis de mise à jour et relevé sous 14 jours','Un document déposé peut demeurer inconnu des membres absents. La communication proactive permet une participation informée et inclusive.','Art. 73, 83, 85 à 89; R3.3 et R3.4'),
@('Continuité','Garde des registres et correspondance à lʼart. 38','Répertoire, suivi, suppléant, sauvegarde mensuelle et après adoption, restauration annuelle','La relève du comité peut entraîner perte de dossiers et de contexte. Des responsabilités et sauvegardes explicites assurent la continuité.','R3.1 et R3.2'),
@('Fonds et BNP','Cotisations réservées au Mess; cadeaux aux art. 105 à 111; fonds dʼunité sans cadre distinct','Suivis séparés et confirmation préalable des sources, qualification et approbations; plafonds conservés','Confondre les fonds masque la destination des sommes. La traçabilité évite de prendre un vote pour une autorisation suffisante.','C1 à C3, C5 et C6')
)
$tab="# Tableau des modifications Avant Après Pourquoi`n`n$status`n`nSeuls les changements de fond et la réorganisation figurent ici. Les simples déplacements sont détaillés dans la concordance. Les délais nouveaux sont proposés à lʼadoption, et ne sont pas attribués à une décision antérieure inaccessible.`n`n| Sujet | Avant | Après | Problème et pourquoi | Mise en œuvre |`n|---|---|---|---|---|`n"
foreach($r in $rows){$tab+='| '+($r -join ' | ')+" |`n"};Save 'tableau-modifications.md' $tab
$map="# Concordance des 116 articles`n`nVersion 0.2.3 du 28 octobre 2026. Source : constitution.md au commit 8362362. Les clauses C1 à C6, R2.1 à R2.2, R3.1 à R3.4 et R3.7 à R3.10, ainsi que R4.1 à R4.4 sont nouvelles. Les numéros historiques sont conservés.`n`n| Article source | Destination | Traitement |`n|---|---|---|`n"
foreach($n in 1..116){$dest=if($n -in $core){'Constitution'}elseif($n -in $r1){'R1'}elseif($n -in $r2){'R2'}elseif($n -in $r3){'R3'}else{'R4'};$action=if($edit.ContainsKey($n)){'Modifié — voir tableau'}else{'Texte conservé'};$map+="| $n | $dest | $action |`n"};Save 'concordance.md' $map
Save 'index.md' @"
---
layout: default
title: Révision des documents du Mess du 28 octobre 2026
---

# Révision des documents du Mess

**Version 0.2.3 du 28 octobre 2026 — Proposition à discuter et à adopter.**

Les droits des membres et les assemblées trimestrielles sont maintenus. La révision simplifie lʼorganisation des textes et renforce lʼaccès aux documents ainsi que leur communication proactive.

- [Courte lettre de présentation](lettre-presentation.md)
- [Tableau Avant Après Pourquoi des seules modifications](tableau-modifications.md)
- [R1 Tenue et comportement](R1-proposition.md)
- [R2 Mobilier décorations souvenirs provenance et dons](R2-proposition.md)
- [R3 Assemblées et réunions](R3-proposition.md)
- [R4 Service de bar](R4-proposition.md)
- [Constitution intégrale consolidée](constitution-consolidee.md)
- [Règlement intégral consolidé réunissant R1 à R4](reglement-consolide.md)
- [Concordance des 116 articles](concordance.md)
- [Sources et validations](notes-revision.md)
- [Transcription actuelle conservée](../../constitution.md)
"@
Save 'notes-revision.md' @"
# Sources et validations de la révision

Version 0.2.3 du 28 octobre 2026

## Sources consultées

Le dépôt identifié est https://github.com/shocktubeM81/mess-9eg, branche main, commit de départ 8362362. La transcription constitution.md comporte 116 articles, un texte adopté le 10 septembre 2022 et un avant-propos du 20 août 2024. Aucun PDF source nʼest présent : la transcription ne peut pas être vérifiée contre les images originales. README.md, index.md et _config.yml décrivent le site Jekyll et son thème Cayman.

La conversation « Références constitution fonds unité » a été consultée. Les demandes utilisateur sont accessibles, mais les réponses de lʼassistant sont représentées par des références sans texte exploitable. La lettre est une nouvelle rédaction conforme aux demandes visibles, pas une reproduction de la dernière lettre inaccessible. Les consignes de la présente conversation déterminent les quatre règlements, les pouvoirs des membres et la séparation des fonds.

## Modalités proposées et statut

La version nʼest pas adoptée. Les délais documentaires de 14 jours, la sauvegarde mensuelle et la vérification annuelle sont des modalités proposées. Lʼharmonisation des avis et du quorum doit être votée. Aucun montant existant nʼest revalorisé. Les articles non modifiés conservent leurs formulations et références anciennes; cela ne vaut pas vérification de leur conformité actuelle.

## Validations avant adoption

1. Relire la transcription contre le PDF original, notamment les catégories de membres et la représentation du comité.
2. Faire confirmer les références militaires et financières applicables, la qualification BNP, les sources admissibles et les autorités dʼapprobation du fonds dʼunité et du fonds cadeau. Le texte ne crée pas dʼautorisation financière automatique.
3. Vérifier lʼadmissibilité des prestations, les règles de rémunération, de service, dʼalcool et dʼutilisation des locaux. Relire ensemble les articles 63 et 77 à 78 sur la responsabilité en cas de dommages; leur déplacement ne crée aucune responsabilité automatique nouvelle.
4. Communiquer les amendements au moins 15 jours avant leur étude, voter avec quorum puis obtenir lʼapprobation du commandant. Inscrire ensuite les dates réelles dʼadoption et dʼentrée en vigueur.
5. Désigner le répertoire interne, le canal commun, les responsables et les accès. Les listes de membres et pièces confidentielles ne doivent pas être publiées sur GitHub.

## Présentation web

La transcription actuelle, lʼaccueil, le thème et le domaine sont conservés. La version proposée possède son propre index dans versions/2026-10-28-v0.2 et est préparée sur une autre branche. Aucune fusion ni modification de la publication actuelle nʼest automatique. Une fusion future permettrait de publier ces nouvelles pages avec le thème existant.
"@
Write-Output "Version créée avec 116 articles répartis."
$refs=@"

## Références officielles repérées

- [Ressources pour les mess des SBMFC](https://cfmws.ca/about-us/resources-for-messes) : répertoire des manuels et guides.
- [Questions financières sur les mess des SBMFC](https://cfmws.ca/about-us/policies-and-publications/frequently-asked-questions/messes) : opérations et prestations des mess.
- [Audit de gestion des mess du ministère de la Défense nationale](https://www.canada.ca/en/department-national-defence/corporate/reports-publications/audit-evaluation/non-public-property-audit-mess-management.html) : difficultés constatées pour distinguer les biens publics des BNP.

Ces sources éclairent la vérification à effectuer; elles ne constituent pas une validation particulière du financement proposé pour le 9 EG.
"@
$note=Join-Path $dir 'notes-revision.md'
[IO.File]::AppendAllText($note,$refs,$enc)
foreach($f in Get-ChildItem -LiteralPath $dir -Filter '*.md'){
 $text=[IO.File]::ReadAllText($f.FullName)
 if(-not $text.StartsWith('---')){
  $title=([regex]::Match($text,'(?m)^# (.+)$')).Groups[1].Value.Trim()
  [IO.File]::WriteAllText($f.FullName,"---`nlayout: default`ntitle: $title`n---`n`n"+$text,$enc)
 }
}

$letterBody=[IO.File]::ReadAllText((Join-Path $dir 'lettre-presentation.md'))
$letterBody=[regex]::Replace($letterBody,'(?s)\A---\r?\n.*?\r?\n---\r?\n','')
[IO.File]::WriteAllText((Join-Path $dir 'lettre-contenu.html'),$letterBody.Trim()+"`n",$enc)

$update=@"

## Ajustement de la répartition des assemblées

Version 0.2.3 du 28 octobre 2026. Par rapport à la version 0.2, les articles 12, 14, 23, 25 et 35 rejoignent la constitution. Le seuil de quorum reste à son article 8; le délai de 30 minutes et le contrôle pendant la séance passent au R3.8. Le calendrier pratique de l’article 13 rejoint le R3. La règle de majorité et les garanties du vote restent constitutionnelles; recomptage et consignation sont précisés au R3.7, et les modalités du vote par internet au R3.9. La clause C4 confirme cette limite entre les deux textes. Les articles 16 à 22 restent au R3 pour la préparation et le déroulement.

Cette répartition conserve quatre règlements et ne réduit aucun quorum, délai minimal, droit de vote, seuil particulier ou pouvoir réservé aux membres. Elle constitue une proposition à adopter et à approuver.
"@
[IO.File]::AppendAllText((Join-Path $dir 'notes-revision.md'),$update,$enc)
$tableRow="| Principes et procédure des assemblées | Règles de gouvernance et déroulement regroupés dans le même texte source | Principes dans la constitution; procédure et déroulement dans le R3 distinct | Les droits et pouvoirs doivent rester repérables dans la constitution. Séparer les modalités facilite leur consultation sans permettre au règlement de modifier ces garanties. | Constitution art. 5 à 12, 14, 23 à 25, 35 et C4; R3 art. 13, 15 à 22 et R3.7 à R3.9 |`n"
[IO.File]::AppendAllText((Join-Path $dir 'tableau-modifications.md'),$tableRow,$enc)

$clarification=@"

## Périmètre des règlements 3 et 4

La version 0.2.2 retient les titres courts « R3 Assemblées et réunions » et « R4 Service de bar ». Le R3 explique leur tenue et leur suivi : préparation, prise de parole, motions, scrutins, comptes rendus, archivage, sauvegarde et communication proactive. Les principes, les pouvoirs administratifs et les finances sont dans la constitution. Les anciennes clauses R3.5 et R3.6 y deviennent C5 et C6.

Les réservations et les modalités financières des réceptions privées figurent également dans la constitution. Les articles sur la propreté, les dommages et le comportement pendant les jeux passent au R1; le contrôle de leur matériel passe au R2. Le R4 se limite au service du bar : personnel, stocks, hygiène, refus de service, protection des mineurs et incidents. Les plafonds de rémunération existants restent dans les dispositions financières constitutionnelles.

La rédaction du refus de service a été vérifiée à partir des [indications de la RACJ sur les obligations du titulaire de permis](https://www.racj.gouv.qc.ca/alcool/vendre-ou-servir-des-boissons-alcooliques-pour-consommation-sur-place/permis-accessoire), qui rappellent l’interdiction de vendre à une personne en état d’ivresse. Les règles proposées pour le Mess précisent la conduite du personnel; elles ne prétendent pas établir le permis particulier applicable aux locaux.
"@
[IO.File]::AppendAllText((Join-Path $dir 'notes-revision.md'),$clarification,$enc)
$rowsAdded=@"
| Périmètre du R3 | Assemblées, administration et finances mêlées dans le texte source | R3 Assemblées et réunions : modalités pratiques et suivi documentaire; principes, administration et finances dans la constitution | Un règlement de procédure doit expliquer comment les séances ont lieu sans redéfinir les pouvoirs constitutionnels. Les communications et sauvegardes restent rattachées au suivi des séances. | Constitution; R3 art. 13, 15 à 22, 73, 83 à 89 et clauses documentaires et de procédure |
| Service de bar | Art. 59 : autorité de ne pas servir une personne en état d’ébriété; art. 68 : interdiction de consommation aux moins de 18 ans | Refus obligatoire et immédiat; arrêt du service; soutien au serveur; vérification de l’âge et prévention du contournement; R4 limité au bar | Une simple faculté peut laisser le personnel hésiter ou subir des pressions. Une conduite claire facilite un service responsable et uniforme. | R4 art. 59 et 68; R4.1 à R4.4 |
"@
[IO.File]::AppendAllText((Join-Path $dir 'tableau-modifications.md'),$rowsAdded+"`n",$enc)
$summary=@"

## Simplification de la version 0.2.3

Les textes proposés ne fixent plus de période estivale exclue ni de dates limites au 30 mai ou au 30 août. Les dates sont indiquées dans les convocations; la fréquence trimestrielle et les délais minimaux constitutionnels restent applicables. L’article 13 du R3 est remplacé en ce sens. Le déroulement type et les indications de prise de parole sont raccourcis.

Les tâches sont regroupées en fin de texte : responsabilités administratives dans la constitution, discipline au R1, inventaire au R2, présidence et tenue des dossiers au R3; les rôles du service de bar restent à la fin du R4. Ce déplacement facilite la consultation des règles avant la lecture des tâches attribuées.
"@
[IO.File]::AppendAllText((Join-Path $dir 'notes-revision.md'),$summary,$enc)
$summaryRow=@"
| Calendrier et lisibilité | Art. 13 source : exclusion du 30 mai au 30 août; consignes de séance et tâches dispersées | Suppression de l’exclusion estivale; déroulement raccourci; tâches regroupées à la fin des textes | Les contraintes saisonnières rigidifient inutilement la planification. Lire les règles avant les tâches permet de comprendre plus vite le fonctionnement, tout en conservant les assemblées trimestrielles et les délais de convocation. | R3 art. 13, 15, 16, 18 et 19; sections finales des tâches et responsabilités |
"@
[IO.File]::AppendAllText((Join-Path $dir 'tableau-modifications.md'),$summaryRow+"`n",$enc)
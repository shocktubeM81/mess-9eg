param([Parameter(Mandatory=$true)][string]$Document, [Parameter(Mandatory=$true)][string]$Pdf)
$ErrorActionPreference = 'Stop'
$wordApplication = $null
$wordDocument = $null
try {
    $wordApplication = New-Object -ComObject Word.Application
    $wordApplication.Visible = $false
    $wordApplication.DisplayAlerts = 0
    $wordApplication.AutomationSecurity = 3
    $wordDocument = $wordApplication.Documents.Open($Document, $false, $true, $false)
    $wordDocument.Repaginate()
    $wordDocument.Fields.Update() | Out-Null
    foreach ($section in $wordDocument.Sections) {
        foreach ($footer in $section.Footers) { $footer.Range.Fields.Update() | Out-Null }
    }
    $wordDocument.ExportAsFixedFormat($Pdf, 17)
} finally {
    if ($null -ne $wordDocument) {
        $wordDocument.Close(0)
        [void][Runtime.InteropServices.Marshal]::ReleaseComObject($wordDocument)
    }
    if ($null -ne $wordApplication) {
        $wordApplication.Quit()
        [void][Runtime.InteropServices.Marshal]::ReleaseComObject($wordApplication)
    }
}

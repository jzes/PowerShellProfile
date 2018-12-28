$OriginalForegroundColor = $Host.UI.RawUI.ForegroundColor

$CompressedList = @(".7z", ".gz", ".rar", ".tar", ".zip")

$Language = @(".bat", ".cmd", ".pl", ".ps1",
                    ".psm1", ".vbs", ".rb", ".reg", ".fsx", 
                    ".sh", ".cs", ".go", ".py")

$DllPdbList = @(".dll", ".pdb")

$Executaveis = @(".exe")

$TextList = @(".csv", ".log", ".markdown", ".rst", ".txt", ".md")

$ConfigsList = @(".cfg", ".conf", ".config", ".ini", ".json")

$ColorTable = @{}

$ColorTable.Add('Default', $OriginalForegroundColor) 
$ColorTable.Add('Directory', "Green") 


ForEach($Extension in $Executaveis){
    $ColorTable.Add($Extension, "Red")
}

ForEach ($Extension in $CompressedList) {
    $ColorTable.Add($Extension, "Yellow")
}

ForEach ($Extension in $Language ) {
    $ColorTable.Add($Extension, "Blue")
}

ForEach ($Extension in $TextList) {
    $ColorTable.Add($Extension, "Cyan")
}

ForEach ($Extension in $DllPdbList) {
    $ColorTable.Add($Extension, "DarkGreen")
}

ForEach ($Extension in $ConfigsList) {
    $ColorTable.Add($Extension, "DarkYellow")
}


Function Get-Color($Item) {
    $Key = 'Default'

    If ($Item.GetType().Name -eq 'DirectoryInfo') {
        $Key = 'Directory'
    } Else {
        If ($Item.PSobject.Properties.Name -contains "Extension") {
            If ($ColorTable.ContainsKey($Item.Extension)) {
                $Key = $Item.Extension
            }
        }
    }

    $Color = $ColorTable[$Key]
    Return $Color
}


function lsc([string] $Path = ""){
    $command = "Get-ChildItem -Path `"$Path`" $Args"
    $files = Invoke-Expression $command 
    foreach($file in $files){
        $Host.UI.RawUI.ForegroundColor = Get-Color $file
        $file
        $Host.UI.RawUI.ForegroundColor = $OriginalForegroundColor
    }
}


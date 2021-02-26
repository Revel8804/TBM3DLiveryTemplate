function New-Livery {
    if (-not (Test-Path $livloc)) {
        Write-Host "Making Folders"
        New-Item -Path "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\MODEL.$airfold" -ItemType Directory
        New-Item -Path "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\MODEL.AI_$airfold" -ItemType Directory
        New-Item -Path "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\TEXTURE.$airfold" -ItemType Directory
        New-Item -Path "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\PANEL.$airfold" -ItemType Directory
    }
}
function Move-Files {
    Write-Host "Moving Files"
    $moveddsfile = Get-ChildItem -Path $PSScriptRoot\texture -Filter *.dds
    foreach ($item in $moveddsfile) {
        Copy-Item "$PSScriptRoot\texture\json\$item.json" -destination "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\TEXTURE.$airfold"
    }
    Copy-Item "$PSScriptRoot\Files\model.cfg" "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\PANEL.$airfold\PANEL.CFG"
    Copy-Item "$PSScriptRoot\Files\model.cfg" "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\PANEL.$airfold\PANEL.XML"
    Copy-Item "$PSScriptRoot\Files\manifest.json" "$livloc\manifest.json"
    Copy-Item "$PSScriptRoot\Files\layout.json" "$livloc\layout.json"
    Copy-Item "$PSScriptRoot\Files\aircraft.cfg" "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\aircraft.cfg"
    Copy-Item "$PSScriptRoot\Files\model.cfg" "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\MODEL.$airfold\model.cfg"
    Copy-Item "$PSScriptRoot\Files\model.cfg" "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\MODEL.AI_$airfold\model.cfg"
    Copy-Item "$PSScriptRoot\Files\texture.cfg" "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\TEXTURE.$airfold\texture.cfg"
    Get-ChildItem -path "$PSScriptRoot\texture" -filter *.dds | Copy-Item -destination "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\TEXTURE.$airfold"
}

function Update-ManifestJson {
    Write-Host "Updating Manifest.json"
    $file = Get-content -path $livloc\manifest.json
    $newfile = $file -replace 'AIRLINE', ("$airline")
    $newfile | Set-content -path $livloc\manifest.json
    $file = Get-content -path $livloc\manifest.json
    $newfile = $file -replace 'PERSONA', ("$name")
    $newfile | Set-content -path $livloc\manifest.json
}

function Update-AircraftConfig {
    # Im sure there is a better way, but this worked.
    Write-Host "Updating Aircraft.cfg"
    $file = Get-content -path "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\aircraft.cfg"
    $newfile = $file -replace 'AIRFOLD" ', ("$airfold" + '" ')
    $newfile | Set-content -path "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\aircraft.cfg"
    $file = Get-content -path "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\aircraft.cfg"
    $newfile = $file -replace 'AIRLINE" ', ("$airline" + '" ')
    $newfile | Set-content -path "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\aircraft.cfg"
    $file = Get-content -path "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\aircraft.cfg"
    $newfile = $file -replace 'PERSONA" ', ("$name" + '" ')
    $newfile | Set-content -path "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\aircraft.cfg"
    $file = Get-content -path "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\aircraft.cfg"
    $newfile = $file -replace 'ATCID" ', ("$atcid" + '" ')
    $newfile | Set-content -path "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\aircraft.cfg"
    $file = Get-content -path "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\aircraft.cfg"
    $newfile = $file -replace 'ICAO" ', ("$icao" + '" ')
    $newfile | Set-content -path "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\aircraft.cfg"
    $file = Get-content -path "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\aircraft.cfg"
    $newfile = $file -replace '##" ', ("$flightnumber" + '" ')
    $newfile | Set-content -path "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\aircraft.cfg"
    $file = Get-content -path "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\aircraft.cfg"
    $newfile = $file -replace 'AIRFOLD Livery" ', ("$airfold" + ' Livery')
    $newfile | Set-content -path "$livloc\SimObjects\Airplanes\Asobo_TBM930_Livery$airfold\aircraft.cfg"
}

function Convert-ToDDS {
    Write-Host "Converting Files to DDS"
    $convertfile = Get-ChildItem -Path $PSScriptRoot\texture -Include *.png -Recurse | Where-Object {$_.LastWriteTime -gt (get-date).AddMonths(-1)}
    magick.exe mogrify -format DDS $convertfile
}
function Update-LayoutJson {
    Start-Process -FilePath $PSScriptRoot\Files\MSFSLayoutGenerator.exe -ArgumentList $livloc\layout.json
}

function Install-NeededPrograms {
    Write-Host "Installing Programs and registry changes"
    $long = Get-ItemPropertyValue -Path HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem -Name LongPathsEnabled
    if ($long -eq "0") {
        Write-Host "Enabling Long File Paths"
        Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem -Name LongPathsEnabled -Value 1
        $long = Get-ItemPropertyValue -Path HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem -Name LongPathsEnabled
    }
    $imagemagick = $null -ne (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "*ImageMagick*" })
    $blender = $null -ne (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "*Blender*" })
    if (-not (Test-Path "C:\ProgramData\chocolatey\choco.exe")) {
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
    if (-not $imagemagick) {
        Choco install ImageMagick -y
    }
    if (-not $blender) {
        Choco install Blender -y
    }
}

function Open-Blender {
    Write-Host "Opening Blender"
    $blenderloc = Get-ChildItem -Path "C:\Program Files\Blender Foundation\" -Include blender.exe -File -Recurse -ErrorAction SilentlyContinue
    Start-Process -FilePath $blenderloc.FullName -ArgumentList $PSScriptRoot\tbm.blend
    Write-Host "Waiting until you are complete with editing the files"
    Pause
}

function Expand-BlenderFile {
    Write-Host "Expanding TBM.zip"
    Expand-Archive "$PSScriptRoot\TBM.zip" -DestinationPath $PSScriptRoot -Force
    $timechange = Get-ChildItem -path $PSScriptRoot\texture -recurse -ErrorAction SilentlyContinue | Where-Object {! $_.PSIsContainer}
    foreach ($item in $timechange) {
        $item.LastWriteTime=("31 December 1999 23:59:47")
    }
}

function Get-SteamLoc {
    Write-host "Future Use"
    if (-not (Test-Path $steamloc)) {
        Write-host "I have no clue where your stuff is."
        EXIT
    }
}

function Get-PackageLoc {
    $app = Get-AppxPackage -Name Microsoft.FlightSimulator
    $appname = $app.PackageFamilyName
    $apploc = "$env:LOCALAPPDATA\Packages\$appname\"
    if (-not (Test-Path $apploc)) {
        Get-SteamLoc
    }
    $usercfgloc = "$apploc\LocalCache\UserCfg.opt"
    $maybe = Get-Content $usercfgloc | Where-Object {$_ -match "[a-zA-Z]\:\\"}
    $finally = $maybe.Split(" ")
    $script:livloc = $finally[1].Replace('"',"") + "\Community" + "\$name-tbm930-livery-$airfold"
}

# Form boxes working on making it one box.
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$script:name = [Microsoft.VisualBasic.Interaction]::InputBox("Enter your persona name", "Persona").toupper()
$script:airline = [Microsoft.VisualBasic.Interaction]::InputBox("Enter your airline or livery name", "Airline").toupper()
$script:atcid = [Microsoft.VisualBasic.Interaction]::InputBox("Enter your airline ATC ID (Tail Number)", "ATC ID").toupper()
$script:icao = [Microsoft.VisualBasic.Interaction]::InputBox("Enter your airline ICAO name", "ICAO").toupper()
$script:flightnumber = [Microsoft.VisualBasic.Interaction]::InputBox("Enter your airline flight number", "Flight Number").toupper()
$script:airfold = $airline.replace(' ','')

# Run functions
Get-PackageLoc
Install-NeededPrograms
Expand-BlenderFile
Open-Blender
New-Livery
Convert-ToDDS
Move-Files
Update-ManifestJson
Update-AircraftConfig
Update-LayoutJson

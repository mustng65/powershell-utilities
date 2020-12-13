

[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $Path
)

$Action = 'Write-Output "The watched file was changed"'
$global:FileChanged = $false


function Wait-NextChange {
    while ($global:FileChanged -eq $false) {

        if ([Console]::KeyAvailable) {
            $key = [Console]::ReadKey($true)
            if ($key.key -eq "q") { 

                Unregister-Event -SubscriptionId $global:eventId
                Write-Output "Good Bye!"
                exit
            }
        }

        Start-Sleep -Milliseconds 100
    }

    & $ScriptBlock 

    
    $global:FileChanged = $false

    Wait-NextChange
}

function Wait-FileChange {
    param(
        [string]$File,
        [string]$Action
    )

    Write-Host "Watching file: $File..."
    Write-Host "Press 'q' to quit."

    $FilePath = Split-Path $File -Parent
    $FileName = Split-Path $File -Leaf
    $ScriptBlock = [scriptblock]::Create($Action)

    $Watcher = New-Object IO.FileSystemWatcher $FilePath, $FileName -Property @{ 
        IncludeSubdirectories = $false
        EnableRaisingEvents   = $true
    }
    $onChange = Register-ObjectEvent $Watcher Changed -Action { $global:FileChanged = $true }
    $global:eventId = $onChange.Id

    Wait-NextChange
   
}

Wait-FileChange -File $Path -Action $Action
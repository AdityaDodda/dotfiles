# Directory Management
function trash($path) {
    $fullPath = (Resolve-Path -Path $path).Path

    if (Test-Path $fullPath) {
        $item = Get-Item $fullPath

        if ($item.PSIsContainer) {
          # Handle directory
            $parentPath = $item.Parent.FullName
        } else {
            # Handle file
            $parentPath = $item.DirectoryName
        }

        $shell = New-Object -ComObject 'Shell.Application'
        $shellItem = $shell.NameSpace($parentPath).ParseName($item.Name)

        if ($item) {
            $shellItem.InvokeVerb('delete')
            Write-Host "Item '$fullPath' has been moved to the Recycle Bin."
        } else {
            Write-Host "Error: Could not find the item '$fullPath' to trash."
        }
    } else {
        Write-Host "Error: Item '$fullPath' does not exist."
    }
}

# Admin Terminal
function admin {
    if ($args.Count -gt 0) {
        $argList = $args -join ' '
        Start-Process wt -Verb runAs -ArgumentList "pwsh.exe -NoExit -Command $argList"
    } else {
        Start-Process wt -Verb runAs
    }
}

# Quick File Creation
function touch { param($name) New-Item -ItemType "file" -Path . -Name $name }

## Listing
# Function to convert file size to human-readable format (KB, MB, GB)
function Convert-FileSize {
    param (
        [Parameter(Mandatory=$true)]
        [int64]$Size
    )
    
    if ($Size -gt 1GB) {
        return "{0:N2} GB" -f ($Size / 1GB)
    }
    elseif ($Size -gt 1MB) {
        return "{0:N2} MB" -f ($Size / 1MB)
    }
    elseif ($Size -gt 1KB) {
        return "{0:N2} KB" -f ($Size / 1KB)
    }
    else {
        return "$Size B"
    }
}

# Function to list files similar to ls -alh
function ll {
    Get-ChildItem -Force | Select-Object @{Name="Mode"; Expression={
        $mode = if ($_.PSIsContainer) { "d" } else { "-" }
        if ($_.Attributes -match "ReadOnly") { $mode += "r" }
        if ($_.Attributes -match "Hidden") { $mode += "h" }
        if ($_.Attributes -match "System") { $mode += "s" }
        $mode
    }}, LastWriteTime, @{Name="Size"; Expression={Convert-FileSize $_.Length}}, Name
}

## Navigation
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }
function ..... { Set-Location ../../../.. }
function ...... { Set-Location ../../../../.. }
function ....... { Set-Location ../../../../../.. }

# Starship Prompt
Invoke-Expression (&starship init powershell)

# Zoxide Configuration
Invoke-Expression (& { (zoxide init powershell | Out-String) })

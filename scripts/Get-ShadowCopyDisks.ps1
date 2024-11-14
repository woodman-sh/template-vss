# Get a list of volumes and their GUIDs
$volumes = Get-CimInstance -ClassName Win32_Volume | Where-Object { $_.DriveLetter -ne $null } | Select-Object DriveLetter, DeviceID

# Retrieve shadow copies and group them by volume GUIDs
$shadowCopies = Get-CimInstance -ClassName Win32_ShadowCopy | Group-Object VolumeName | ForEach-Object {
    # Create an object with VolumeName and the number of shadow copies
    [PSCustomObject]@{
        VolumeName = $_.Name
        Count = $_.Count
    }
}

# Create a list of objects for Zabbix LLD
$disks = @()

foreach ($volume in $volumes) {
    # Find the number of shadow copies for the current volume
    $shadowCopyInfo = $shadowCopies | Where-Object { $_.VolumeName -eq $volume.DeviceID }

    # If there is a shadow copy, add it to the result
    if ($shadowCopyInfo) {
        $disks += [PSCustomObject]@{
            "{#DISKNAME}" = $volume.DriveLetter
            "{#SHADOWCOPYCOUNT}" = $shadowCopyInfo.Count
        }
    }
}

# Convert to JSON
$jsonResult = $disks | ConvertTo-Json -Compress

# If there is only one item in the array, wrap it in square brackets
if ($disks.Count -eq 1) {
    $jsonResult = "[" + $jsonResult + "]"
}

# Output the result
Write-Output $jsonResult

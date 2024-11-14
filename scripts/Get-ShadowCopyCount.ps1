param ( 
    [string]$DriveLetter  # Accepting only DriveLetter as a parameter
)

# Checking if the drive letter was provided
if (-not $DriveLetter) {
    Write-Output 0
    exit 0
}

# Formatting DriveLetter for search
$volumePath = "$DriveLetter\"  # Adding a backslash for correct search

# Retrieve shadow copies and group them by volume GUIDs
$shadowCopies = Get-CimInstance -ClassName Win32_ShadowCopy | Group-Object VolumeName | ForEach-Object {
    # Create an object with VolumeName and the number of shadow copies
    [PSCustomObject]@{
        VolumeName = $_.Name
        Count = $_.Count
    }
}

# Retrieve information about the current volume
$selectedVolume = Get-CimInstance -ClassName Win32_Volume | Where-Object { $_.DriveLetter -eq $DriveLetter }

# Initialize variable to store the number of shadow copies
$shadowCopyCount = 0

# If the selected volume exists, find the number of shadow copies
if ($selectedVolume) {
    $shadowCopyInfo = $shadowCopies | Where-Object { $_.VolumeName -eq $selectedVolume.DeviceID }
    
    # If there is a shadow copy, retrieve its count
    if ($shadowCopyInfo) {
        $shadowCopyCount = $shadowCopyInfo.Count
    }
}

# Output only the number of shadow copies
Write-Output $shadowCopyCount

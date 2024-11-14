param (
    [string]$DriveLetter  # Accepting only the drive letter as a parameter
)

# Checking if the drive letter was provided
if (-not $DriveLetter) {
    Write-Output 0
    exit
}

# Formatting DriveLetter for search
$volumePath = "$DriveLetter\"

# Retrieve all shadow copies
$shadowCopies = Get-WmiObject -Class Win32_ShadowCopy

# Initialize variable to store the latest date
$latestCopyDate = $null

# Retrieve information about the current volume
$selectedVolume = Get-WmiObject -Class Win32_Volume | Where-Object { $_.DriveLetter -eq $DriveLetter }

# Check if the selected volume exists
if (-not $selectedVolume) {
    Write-Output 0
    exit
}

# Retrieve shadow copies for the selected volume
$volumeShadowCopies = $shadowCopies | Where-Object { $_.VolumeName -eq $selectedVolume.DeviceID }

# Check if there are shadow copies for the current volume
if ($volumeShadowCopies) {
    # Find the latest shadow copy
    $latestCopy = $volumeShadowCopies | Where-Object { $_.InstallDate -ne $null } | 
        Sort-Object { [Management.ManagementDateTimeConverter]::ToDateTime($_.InstallDate) } -Descending | 
        Select-Object -First 1

    # Check if a copy was found
    if ($latestCopy) {
        # Convert InstallDate to DateTime and output in the required format
        $installDateString = $latestCopy.InstallDate
        try {
            $installDate = [Management.ManagementDateTimeConverter]::ToDateTime($installDateString)
            Write-Output $installDate.ToString("yyyy-MM-dd HH:mm:ss")
        } catch {
            Write-Output 0
        }
    } else {
        Write-Output 0
    }
} else {
    Write-Output 0
}

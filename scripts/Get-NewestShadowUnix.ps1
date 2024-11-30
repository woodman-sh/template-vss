param (
    [string]$DriveLetter
)

if (-not $DriveLetter) {
    Write-Output 0
    exit
}

$volumePath = "$DriveLetter\" 

$shadowCopies = Get-WmiObject -Class Win32_ShadowCopy

$latestCopyDate = $null

$selectedVolume = Get-WmiObject -Class Win32_Volume | Where-Object { $_.DriveLetter -eq $DriveLetter }

if (-not $selectedVolume) {
    Write-Output 0
    exit
}

$volumeShadowCopies = $shadowCopies | Where-Object { $_.VolumeName -eq $selectedVolume.DeviceID }

if ($volumeShadowCopies) {
    $latestCopy = $volumeShadowCopies | Where-Object { $_.InstallDate -ne $null } | 
        Sort-Object { [Management.ManagementDateTimeConverter]::ToDateTime($_.InstallDate) } -Descending | 
        Select-Object -First 1

    if ($latestCopy) {
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

function Get-CommonTimeZone {
    [CmdletBinding()]
    param(
        [string]$Name,
        [int]$Offset
    )

    # Ensure that both 'Name' and 'Offset' parameters are not supplied simultaneously
    if ($Name -and $Offset) {
        Write-Error "You cannot supply both 'Name' and 'Offset' parameters simultaneously."
        return $null
    }

    # Validate the 'Offset' parameter
    if ($Offset -and ($Offset -lt -12 -or $Offset -gt 12)) {
        Write-Error "Invalid offset. Offset should be between -12 and 12."
        return $null
    }

    # Define the URL to the JSON file containing time zones
    $jsonUrl = "https://raw.githubusercontent.com/dmfilipenko/timezones.json/master/timezones.json"

    try {
        # Download the JSON data from the URL
        $timeZonesData = Invoke-RestMethod -Uri $jsonUrl -UseBasicParsing -ErrorAction Stop
        
        # convett from Json data into pharse
        $timeZonesDatanew =$timeZonesData | ConvertFrom-Json

        # Filter time zones by name if 'Name' parameter is provided
        if ($Name) {
            $timeZonesDatanewresult = $timeZonesDatanew | Where-Object { $_.Name -like "*$Name*" }
        }

        # Filter time zones by offset if 'Offset' parameter is provided
        if ($Offset) {
            $timeZonesDatanewresult = $timeZonesDatanew | Where-Object { $_.Offset -eq $Offset }
        }

        $timeZonesDatanewresult
    }
    catch {
        Write-Error "Failed to retrieve time zone data from GitHub. Please check your internet connection."
        return $null
    }
}

$timeZonesDatanewresult  = Get-CommonTimeZone


# NB: the git hub link which is provided is not working to test the script  

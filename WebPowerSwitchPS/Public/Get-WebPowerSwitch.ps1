function Get-WebPowerSwitch {
    <#
    .SYNOPSIS
    Gets settings of a Web Power Switch or other DLI device

    .DESCRIPTION
    Gets settings of a Web Power Switch or other DLI device

    .PARAMETER IPAddress
    The IP address of the device

    .PARAMETER Credential
    Username and password that has permissions to access the Rest API's

    .PARAMETER All
    Get all settings

    .PARAMETER HostName
    Get just the hostname

    .PARAMETER Ports
    Get just the http and https ports

    .PARAMETER Serial
    Get the serial number of the device

    .EXAMPLE
    Get-WebPowerSwitch -IPAddress "10.10.10.10" -All

    .NOTES
    General notes
    #>
    [CmdletBinding(DefaultParameterSetName = "All")]
    [OutputType([PSObject[]])]
    param(
        [Parameter(Mandatory = $true)]
        [Alias("Ip", "ComputerName")]
        [string[]]
        $IPAddress,
        [Parameter()]
        [pscredential]
        $Credential = $(Get-Credential -Message "Username and Password to access $IPAddress"),
        [Parameter(ParameterSetName = "All")]
        [switch]
        $All,
        [switch]
        $HostName,
        [switch]
        $Ports,
        [switch]
        $Serial
    )

    begin {
        if (-not $script:WPSCache) {
            $script:WPSCache = @{}
        }
        if ($home) {
            $WebPowerSwitchRoot = Join-Path $home -ChildPath ".WebPowerSwitchPS"
        }
    }

    process {
        #region Default to All Devices
        if (-not $IPAddress) {
            # If no -IPAddress was passed
            if ($home) {
                # Read all .twinkly.clixml files beneath your LightScript directory.
                Get-ChildItem -Path $WebPowerSwitchRoot -ErrorAction SilentlyContinue -Filter *.webpowerswitch.clixml -Force |
                Import-Clixml |
                ForEach-Object {
                    if (-not $_) { return }
                    $wpsConnection = $_
                    $script:WPSCache["$($wpsConnection.IPAddress)"] = $wpsConnection
                }

                $IPAddress = $script:WPSCache.Keys # The keys of the device cache become the -IPAddress.
            }
            if (-not $IPAddress) {
                # If we still have no -IPAddress
                return #  return.
            }
        }
        #endregion Default to All Devices

        $IPAddress | ForEach-Object {
            $Params = @{
                Method               = Get
                Uri                  = "https://$IPAddress/restapi/config/"
                Credential           = $Credential
                ContentType          = "application/json"
                Headers              = @{'dli-depth' = 1 }
                SkipCertificateCheck = $true
            }
            $Config = Invoke-RestMethod @Params
            if ($All) {
                return $Config
            }
            $Select = [System.Collections.ArrayList]::new()
            if ($HostName) {
                $Select.Add("hostname") | Out-Null
            }
            if ($Ports) {
                $Select.Add("http_ports") | Out-Null
                $Select.Add("https_ports") | Out-Null
            }
            if ($Serial) {
                $Select.Add("serial") | Out-Null
            }
            $Config | Select-Object -Property $Select
        }
    }

    end {
    }
}

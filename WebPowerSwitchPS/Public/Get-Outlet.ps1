function Get-Outlet {
    <#
    .SYNOPSIS
    Gets details about outlets, like current state

    .DESCRIPTION
    Gets details about outlets, like current state

    .PARAMETER IPAddress
    IPAddress of a Web Power Switch

    .PARAMETER Credential
    Credentials with permissions to get the states of outlets

    .PARAMETER Name
    Name of the outlet

    .PARAMETER Number
    Number of the outlet from 1 to 8

    .PARAMETER Filter
    Filter what properties or states of an outlet. This is an additive filter.
    "-Filter On, Off" will return On and Off, while "-Filter On" will return On.

    .EXAMPLE
    Get-Outlet -IPAddress "10.10.10.10"

    .EXAMPLE
    Get-Outlet -IPAddress "10.10.10.10" -Filter On

    .EXAMPLE
    Get-Outlet -IPAddress "10.10.10.10" -Filter On, Off

    .EXAMPLE
    Get-Outlet -Filter On

    .NOTES
    General notes
    #>
    [CmdletBinding(DefaultParameterSetName="Name")]
    [OutputType([PSObject])]
    param(
        [Parameter(ParameterSetName = "Name")]
        [Parameter(ParameterSetName = "Number")]
        [Parameter(ParameterSetName = "Filter")]
        [Alias("Ip", "ComputerName")]
        [string[]]
        $IPAddress,
        [Parameter(ParameterSetName = "Name")]
        [Parameter(ParameterSetName = "Number")]
        [Parameter(ParameterSetName = "Filter")]
        [pscredential]
        $Credential = $(Get-Credential -Message "Username and Password to access $IPAddress"),
        [Parameter(ParameterSetName = "Name")]
        [string]
        $Name,
        [Parameter(ParameterSetName = "Number")]
        [ValidateRange(1, 8)]
        [string]
        $Number,
        [Parameter(ParameterSetName = "Filter")]
        [ValidateSet("Critical", "Locked", "On", "Off")]
        [string[]]
        $Filter
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
            if ($home -and -not $script:WPSCache.Count) {
                # Read all .webpowerswitch.clixml files beneath your .WebPowerSwitchPS directory.
                Get-ChildItem -Path $WebPowerSwitchRoot -ErrorAction SilentlyContinue -Filter *.webpowerswitch.clixml -Force |
                Import-Clixml |
                ForEach-Object {
                    if (-not $_) { return }
                    $wpsConnection = $_
                    $script:WPSCache["$($wpsConnection.IPAddress)"] = $wpsConnection
                }

                $IPAddress = $script:WPSCache.Keys # The keys of the device cache become the -IPAddress.
            } elseif ($script:WPSCache.Count) {
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
                Method               = "Get"
                Uri                  = "https://$_/restapi/relay/outlets/"
                Credential           = $Credential
                ContentType          = "application/json"
                SkipCertificateCheck = $true
            }
            $Outlets = Invoke-RestMethod @Params

            if ($Name) {
                $Outlets | Where-Object { $_.name -like $Name }
            } elseif ($Number) {
                $Outlets[($Number - 1)]
            } elseif ($Filter) {
                $Outlets | Where-Object {
                    $(if ($Filter -contains "Critical") { $_.critical }) -or
                    $(if ($Filter -contains "Locked") { $_.locked }) -or
                    $(if ($Filter -contains "On") { $_.State }) -or
                    $(if ($Filter -contains "Off") { -not $_.State }) -or
                    $(if ($Filter.Count -eq 0) { $true })
                }
            } else{
                $Outlets
            }
        }
    }

    end {
    }
}

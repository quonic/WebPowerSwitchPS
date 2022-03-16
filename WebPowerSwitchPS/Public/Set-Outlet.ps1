function Set-Outlet {
    <#
    .SYNOPSIS
    Sets an outlets state or cycle it's state.

    .DESCRIPTION
    Sets an outlets state or cycle it's state.

    .PARAMETER IPAddress
    IP Address of a Web Power Switch

    .PARAMETER Credential
    Credentials with permissions to change the state of outlets

    .PARAMETER Name
    Name of the outlet

    .PARAMETER Number
    Number of the outlet from 1 to 8

    .PARAMETER Cycle
    Turns the outlet off, then on again after the cycle delay passes.
    Has no effect when the outlet is already off. Signals an error if the outlet is locked.
    Does not turn the outlet back on if it becomes locked

    .PARAMETER On
    Turns on the outlet. Saves configured state of the outlet. Cannot be changed if the outlet is locked

    .PARAMETER Off
    Turns off the outlet. Saves configured state of the outlet. Cannot be changed if the outlet is locked

    .EXAMPLE
    Set-Outlet -IPAddress "10.10.10.10" -Number 1 -On

    .EXAMPLE
    Set-Outlet -IPAddress "10.10.10.10" -Number 1 -Off

    .EXAMPLE
    Set-Outlet -IPAddress "10.10.10.10" -Name "Outlet 1" -Cycle

    .NOTES
    General notes
    #>
    [CmdletBinding(DefaultParameterSetName = "Name")]
    [OutputType([PSObject[]])]
    param(
        [Parameter(Mandatory = $true)]
        [Alias("Ip", "ComputerName")]
        [string[]]
        $IPAddress,
        [Parameter()]
        [pscredential]
        $Credential = $(Get-Credential -Message "Username and Password to access $IPAddress"),
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName, ParameterSetName = "Name")]
        [string]
        $Name,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName, ParameterSetName = "Number")]
        [ValidateRange(1, 8)]
        [int]
        $Number,
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Number")]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Name")]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Cycle")]
        [switch]
        $Cycle,
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Number")]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Name")]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "On")]
        [switch]
        $On,
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Number")]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Name")]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Off")]
        [switch]
        $Off
    )

    begin {
        $ErrorActionPreference = 'Stop'
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
                # Read all .twinkly.clixml files beneath your LightScript directory.
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
            $Outlet = if ($Name) {
                # Gets all outlets
                $Outlets = Get-Outlet -IPAddress $_ -Credential $Credential
                for ($i = 0; $i -lt $Outlets.Count; $i++) {
                    # Find the first name that matches
                    if ($Outlets[$i] -like $Name) { $i; break }
                }
                Write-Error "Outlet with the name ($Name) was not found."
            } elseif ($Number) {
                $Number - 1
            }
            $Value = if ($On) {
                "true"
            } elseif ($Off) {
                "false"
            }
            $Method = ""
            $State = if ($Cycle) {
                "cycle/"
                $Method = "Post"
            } else {
                "state/"
                $Method = "Put"
            }

            $Params = @{
                Method               = $Method
                Uri                  = "https://$_/restapi/relay/outlets/$Outlet/$State"
                Credential           = $Credential
                ContentType          = "application/json"
                Header               = @{ value = $Value }
                SkipCertificateCheck = $true
            }
            if ($Cycle) { $Params.Remove($Params.Header) }
            Invoke-RestMethod @Params
        }
    }

    end {}
}

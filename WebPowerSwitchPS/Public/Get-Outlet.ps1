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
    Get-Outlet -IPAddress "10.10.10.10" -Filter Locked

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    [OutputType([PSObject])]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $IPAddress,
        [Parameter()]
        [pscredential]
        $Credential = $(Get-Credential -Message "Username and Password to access $IPAddress"),
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Name")]
        [string]
        $Name,
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Number")]
        [ValidateRange(1, 8)]
        [string]
        $Number,
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Filter")]
        [ValidateSet("Critical", "Locked", "On", "Off")]
        [string[]]
        $Filter
    )

    begin {
    }

    process {
        $Params = @{
            Method               = "Get"
            Uri                  = "https://$IPAddress/restapi/relay/outlets/"
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
        }
    }

    end {
    }
}

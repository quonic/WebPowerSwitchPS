function Get-Outlet {
    [CmdletBinding()]
    [OutputType([PSObject])]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $IPAddress,
        [Parameter()]
        [pscredential]
        $Credential = $(Get-Credential -Message "Username and Password to access $IPAddress"),
        [int]
        $ByNumber,
        [string]
        $ByName,
        # Filter properties
        [Parameter()]
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
            Headers              = @{'dli-depth' = 1 }
            SkipCertificateCheck = $true
        }
        $Outlets = Invoke-RestMethod @Params

        $Outlets | Where-Object {
            $(if ($Filter -contains "Critical") { $_.critical }) -or
            $(if ($Filter -contains "Locked") { $_.locked }) -or
            $(if ($Filter -contains "On") { $_.State }) -or
            $(if ($Filter -contains "Off") { -not $_.State }) -or
            $(if ($Filter.Count -eq 0) { $true })
        }
    }

    end {
    }
}

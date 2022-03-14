function Get-WebPowerSwitch {
    [CmdletBinding()]
    [OutputType([PSObject])]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $IPAddress,
        [Parameter()]
        [pscredential]
        $Credential = $(Get-Credential -Message "Username and Password to access $IPAddress"),
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
    }

    process {
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
        return $($Config | Select-Object -Property $Select)
    }

    end {
    }
}

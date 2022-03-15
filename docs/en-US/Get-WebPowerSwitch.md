---
external help file: WebPowerSwitchPS-help.xml
Module Name: WebPowerSwitchPS
online version:
schema: 2.0.0
---

# Get-WebPowerSwitch

## SYNOPSIS
Gets settings of a Web Power Switch or other DLI device

## SYNTAX

```
Get-WebPowerSwitch -IPAddress <String[]> [-Credential <PSCredential>] [-All] [-HostName] [-Ports] [-Serial]
 [<CommonParameters>]
```

## DESCRIPTION
Gets settings of a Web Power Switch or other DLI device

## EXAMPLES

### EXAMPLE 1
```
Get-WebPowerSwitch -IPAddress "10.10.10.10" -All
```

## PARAMETERS

### -IPAddress
The IP address of the device

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Ip, ComputerName

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Username and password that has permissions to access the Rest API's

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $(Get-Credential -Message "Username and Password to access $IPAddress")
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
Get all settings

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -HostName
Get just the hostname

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Ports
Get just the http and https ports

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Serial
Get the serial number of the device

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject[]
## NOTES
General notes

## RELATED LINKS

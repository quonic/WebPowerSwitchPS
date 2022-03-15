---
external help file: WebPowerSwitchPS-help.xml
Module Name: WebPowerSwitchPS
online version:
schema: 2.0.0
---

# Get-Outlet

## SYNOPSIS
Gets details about outlets, like current state

## SYNTAX

### Name
```
Get-Outlet -IPAddress <String[]> [-Credential <PSCredential>] [-Name <String>] [<CommonParameters>]
```

### Number
```
Get-Outlet -IPAddress <String[]> [-Credential <PSCredential>] [-Number <String>] [<CommonParameters>]
```

### Filter
```
Get-Outlet -IPAddress <String[]> [-Credential <PSCredential>] [-Filter <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Gets details about outlets, like current state

## EXAMPLES

### EXAMPLE 1
```
Get-Outlet -IPAddress "10.10.10.10"
```

### EXAMPLE 2
```
Get-Outlet -IPAddress "10.10.10.10" -Filter On
```

### EXAMPLE 3
```
Get-Outlet -IPAddress "10.10.10.10" -Filter On, Off
```

### EXAMPLE 4
```
Get-Outlet -Filter On
```

## PARAMETERS

### -IPAddress
IPAddress of a Web Power Switch

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
Credentials with permissions to get the states of outlets

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

### -Name
Name of the outlet

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Number
Number of the outlet from 1 to 8

```yaml
Type: String
Parameter Sets: Number
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Filter
Filter what properties or states of an outlet.
This is an additive filter.
"-Filter On, Off" will return On and Off, while "-Filter On" will return On.

```yaml
Type: String[]
Parameter Sets: Filter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject
## NOTES
General notes

## RELATED LINKS

---
external help file: WebPowerSwitchPS-help.xml
Module Name: WebPowerSwitchPS
online version:
schema: 2.0.0
---

# Set-Outlet

## SYNOPSIS
Sets an outlets state or cycle it's state.

## SYNTAX

### Name
```
Set-Outlet -IPAddress <String[]> [-Credential <PSCredential>] -Name <String> [-Cycle] [-On] [-Off]
 [<CommonParameters>]
```

### Number
```
Set-Outlet -IPAddress <String[]> [-Credential <PSCredential>] -Number <Int32> [-Cycle] [-On] [-Off]
 [<CommonParameters>]
```

### Cycle
```
Set-Outlet -IPAddress <String[]> [-Credential <PSCredential>] [-Cycle] [<CommonParameters>]
```

### On
```
Set-Outlet -IPAddress <String[]> [-Credential <PSCredential>] [-On] [<CommonParameters>]
```

### Off
```
Set-Outlet -IPAddress <String[]> [-Credential <PSCredential>] [-Off] [<CommonParameters>]
```

## DESCRIPTION
Sets an outlets state or cycle it's state.

## EXAMPLES

### EXAMPLE 1
```
Set-Outlet -IPAddress "10.10.10.10" -Number 1 -On
```

### EXAMPLE 2
```
Set-Outlet -IPAddress "10.10.10.10" -Number 1 -Off
```

### EXAMPLE 3
```
Set-Outlet -IPAddress "10.10.10.10" -Name "Outlet 1" -Cycle
```

## PARAMETERS

### -IPAddress
IP Address of a Web Power Switch

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
Credentials with permissions to change the state of outlets

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

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Number
Number of the outlet from 1 to 8

```yaml
Type: Int32
Parameter Sets: Number
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Cycle
Turns the outlet off, then on again after the cycle delay passes.
Has no effect when the outlet is already off.
Signals an error if the outlet is locked.
Does not turn the outlet back on if it becomes locked

```yaml
Type: SwitchParameter
Parameter Sets: Name, Number, Cycle
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -On
Turns on the outlet.
Saves configured state of the outlet.
Cannot be changed if the outlet is locked

```yaml
Type: SwitchParameter
Parameter Sets: Name, Number, On
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Off
Turns off the outlet.
Saves configured state of the outlet.
Cannot be changed if the outlet is locked

```yaml
Type: SwitchParameter
Parameter Sets: Name, Number, Off
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
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

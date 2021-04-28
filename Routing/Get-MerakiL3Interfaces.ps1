<#
.SYNOPSIS
    Gets list of all L3 interfaces from stacked or standalone switches using Meraki API.

.DESCRIPTION
    Uses your Meraki API  key to export layer 3 interfaces from a Meraki dashboard.

.PARAMETER APIKey
    Your Meraki API key.

.PARAMETER InputFile
    File with list of standalone switches. Expects there to be a 'SwitchSerial' and/or 'SwitchStackID' field.

.PARAMETER ExportFile
    File to export the switch interface data to.

.PARAMETER Stack
    Enable L3 standalone switch interface export. Requires the NetworkID parameter.

.PARAMETER NetworkID
    Enable L3 standalone switch interface export. Requires the NetworkID parameter.

.PARAMETER StandAlone
    Enable L3 switch stack interface export.

.EXAMPLE
    ./Get-MerakiL3Interfaces.ps1 -APIKey 0000000000000000000000000000000000000000 -InputFile switch_list.csv -ExportFile L3Interfaces -Stack -Standalone

    Two files will be created. L3InterfacesSA.csv will contain standalone switch interfaces, and L3InterfacesStack.csv will contain stacked switch interfaces.
#>

[CmdletBinding()]
param (
    [Parameter(
        Mandatory = $true
    )]
    [string]$APIKey,
    [Parameter(
        Mandatory = $true
    )]
    [string]$InputFile,
    [Parameter(
        Mandatory = $true
    )]
    [string]$ExportFile,
    [Parameter(
        ParameterSetName='Stack',
        Mandatory=$false
    )]
    [switch]$Stack,
    [Parameter(
        ParameterSetName='Stack',
        Mandatory=$true
    )]
    [string]$NetworkID,
    [Parameter(
        ParameterSetName='SA',
        Mandatory=$false
    )]
    [switch]$StandAlone
)
if ( !$StandAlone -and !$Stack ) {
    Get-Help $MyInvocation.MyCommand.Definition
    return
}
if ( $StandAlone ) {
    $count = 0
    $serials = Import-Csv $InputFile | Select-Object -ExpandProperty SwitchSerial -Unique
    $total = $serials.Count

    $interfaces = foreach ( $s in $serials ) {
        $count++
        Write-Progress -Activity "Getting switch interfaces" -Status (“{0:P0}” -f ($count/$total)) -PercentComplete ($count/$total*100) -CurrentOperation "$s"
        curl --silent --location --request GET "https://api.meraki.com/api/v1/devices/$s/switch/routing/interfaces" `
    --header "X-Cisco-Meraki-API-Key: $APIKey" | ConvertFrom-Json
    }

    $interfaces | Export-Csv -Path "$ExportFile"

}
if ( $Stack ) {
    $count = 0
    $stackIDs = Import-Csv $InputFile | Select-Object -ExpandProperty SwitchStackID -Unique
    $total = $stackIDs.Count

    $interfaces = foreach ( $s in $stackIDs ) {
        $count++
        Write-Progress -Activity "Getting switch interfaces" -Status (“{0:P0}” -f ($count/$total)) -PercentComplete ($count/$total*100) -CurrentOperation "$s"
        curl --silent --location --request GET "https://api.meraki.com/api/v1/networks/$NetworkID/switch/stacks/$s/routing/interfaces" `
    --header "X-Cisco-Meraki-API-Key: $APIKey" | ConvertFrom-Json
    }

    $interfaces | Export-Csv -Path "$ExportFile"
}

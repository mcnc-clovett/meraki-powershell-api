<#
.SYNOPSIS
    Gets list of all L3 interfaces from switch stacks using Meraki API.

.DESCRIPTION
    Uses your Meraki API key to export layer 3 interfaces from a Meraki dashboard.

.PARAMETER APIKey
    Your Meraki API key.

.PARAMETER networkId
    Network ID.

.PARAMETER id
    L3 switch stack ID.

.EXAMPLE
    ./Get-MerakiL3Interfaces.ps1 -APIKey 0000000000000000000000000000000000000000 -networkId <network ID> -id <stack ID>

    Outputs all layer 3 interfaces on the switch.
#>

[CmdletBinding()]
param (
    [Parameter(
        Position = 0,
        Mandatory = $true
    )][string]$APIKey,
    [Parameter(
        Position = 1,
        Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true
    )][string[]]$networkId,
    [Parameter(
        Position = 2,
        Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true
    )][string[]]$id
)
begin{}
process{
    $interfaces = curl --silent --location --request GET "https://api.meraki.com/api/v1/networks/$networkId/switch/stacks/$id/routing/interfaces" `
         --header "X-Cisco-Meraki-API-Key: $APIKey" | ConvertFrom-Json
    foreach ($i in $interfaces) {
        $i | Add-Member -MemberType NoteProperty -Name networkId -Value ([string]$networkId)
        $i | Add-Member -MemberType NoteProperty -Name switchStackId -Value ([string]$id)
    }
    $interfaces
}
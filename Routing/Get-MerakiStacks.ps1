<#
.SYNOPSIS
    Lists switch stacks in a Meraki network.

.DESCRIPTION
    Outputs a full list of switch stacks given a specific Meraki network.

.PARAMETER APIKey
    Your Meraki API key.

.PARAMETER networkId
    Network from which you want to list stacks.

.EXAMPLE
    ./Get-MerakiStacks.ps1 -APIKey 0000000000000000000000000000000000000000 -networkId <orgnumber>

    Outputs all switch stacks in the network.
#>

[CmdletBinding()]
param (
    [Parameter(
        Position = 0,
        Mandatory = $true
    )][string]$APIKey,
    [Parameter(
        Position = 1,
        Mandatory = $true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true
    )][string[]]$networkId
)
begin{}
process{
    curl --silent --location --request GET "https://api.meraki.com/api/v1/networks/$networkId/switch/stacks" `
         --header "X-Cisco-Meraki-API-Key: $APIKey" | ConvertFrom-Json
}
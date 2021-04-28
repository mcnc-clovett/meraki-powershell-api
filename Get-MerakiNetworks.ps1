<#
.SYNOPSIS
    Lists networks in a Meraki organization.

.DESCRIPTION
    Outputs a full list of networks given a specific Meraki organization.

.PARAMETER APIKey
    Your Meraki API key.

.PARAMETER Organization
    Organization from which you want to list networks.

.EXAMPLE
    ./Get-MerakiNetworks.ps1 -APIKey 0000000000000000000000000000000000000000 -Organization <orgnumber>

    Outputs all networks in the organization.
#>

[CmdletBinding()]
param (
    [Parameter(
        Position = 0,
        Mandatory = $true
    )][string]$APIKey,
    [Parameter(
        Position = 1,
        Mandatory = $true
    )][string]$Organization
)
begin{}
process{
    curl --silent --location --request GET "https://api.meraki.com/api/v1/organizations/$Organization/networks" `
         --header "X-Cisco-Meraki-API-Key: $APIKey" | ConvertFrom-Json
}
<#
.SYNOPSIS
    Lists devices in a Meraki organization.

.DESCRIPTION
    Outputs a full list of devices given a specific Meraki organization.

.PARAMETER APIKey
    Your Meraki API key.

.PARAMETER organizationId
    Organization ID from which you want to list devices.

.EXAMPLE
    ./Get-MerakiDevices.ps1 -APIKey 0000000000000000000000000000000000000000 -Organization <orgnumber>

    Outputs all devices in the organization.
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
    )][string]$organizationId
)
begin{}
process{
    curl --silent --location --request GET "https://api.meraki.com/api/v1/organizations/$organizationId/devices" `
         --header "X-Cisco-Meraki-API-Key: $APIKey" | ConvertFrom-Json
}
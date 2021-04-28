<#
.SYNOPSIS
    Lists all Meraki Organizations your API has access to.

.DESCRIPTION
    Lists all Meraki Organizations your API has access to.

.PARAMETER APIKey
    Your Meraki API key.

.EXAMPLE
    ./Get-MerakiL3Interfaces.ps1 -APIKey 0000000000000000000000000000000000000000

    id                 name                              url
    --                 ----                              ---
    123456             Organization Name                 https://something.meraki.com/o/blahblah/manage/organization/overview
#>

[CmdletBinding()]
param (
    [Parameter(
        Mandatory = $true
    )]
    [string]$APIKey
)
begin{}
process{
    curl --silent --location --request GET "https://api.meraki.com/api/v1/organizations" `
         --header "X-Cisco-Meraki-API-Key: $APIKey" | ConvertFrom-Json
}
<#
.SYNOPSIS
    Audit, then optionally apply a small Windows 11 cloud-VM security baseline.
.DESCRIPTION
    Default behavior is read-only. With -Apply, enables Windows Firewall,
    requires RDP Network Level Authentication, and restricts existing inbound
    TCP/UDP 3389 rules to one trusted source IP or CIDR.

    This does not change Azure/AWS security groups, install a Windows license,
    configure account lockout, or disable Windows services. Keep provider-level
    RDP restrictions in place as well.
.EXAMPLE
    .\Set-Win11CloudBaseline.ps1
.EXAMPLE
.\Set-Win11CloudBaseline.ps1 -Apply -RdpAllowedRemoteAddress "YOUR_TRUSTED_PUBLIC_IP/32"
.EXAMPLE
    .\Set-Win11CloudBaseline.ps1 -Apply -RdpAllowedRemoteAddress "203.0.113.10/32" -WhatIf
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$Apply,

    [string]$RdpAllowedRemoteAddress
)

$ErrorActionPreference = 'Stop'

function Test-IpOrCidr {
    param([Parameter(Mandatory)][string]$Value)

    if ($Value -in @('Any', '0.0.0.0/0', '::/0')) { return $false }

    $parts = $Value.Split('/', 2)
    $address = $null
    if (-not [System.Net.IPAddress]::TryParse($parts[0], [ref]$address)) { return $false }

    if ($parts.Count -eq 1) { return $true }

    $prefix = 0
    if (-not [int]::TryParse($parts[1], [ref]$prefix)) { return $false }
    $maximum = if ($address.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork) { 32 } else { 128 }
    # Only accept one host, not a broad network range.
    return ($prefix -eq $maximum)
}

function Get-RdpInboundRules {
    Get-NetFirewallRule -Direction Inbound | ForEach-Object {
        $rule = $_
        $portFilters = @(Get-NetFirewallPortFilter -AssociatedNetFirewallRule $rule)
        $usesRdpPort = $false

        foreach ($filter in $portFilters) {
            $localPorts = @($filter.LocalPort | ForEach-Object { [string]$_ })
            if ($localPorts -contains '3389') {
                $usesRdpPort = $true
                break
            }
        }

        if ($usesRdpPort) { $rule }
    }
}

$currentPrincipal = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Run PowerShell as Administrator.'
}

$nlaPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp'
$nlaValue = (Get-ItemProperty -Path $nlaPath -Name UserAuthentication).UserAuthentication
$firewallProfiles = Get-NetFirewallProfile
$rdpRules = @(Get-RdpInboundRules)

Write-Host 'Windows 11 cloud VM baseline audit' -ForegroundColor Cyan
Write-Host "NLA enabled: $([bool]$nlaValue)"
$firewallProfiles | Select-Object Name, Enabled | Format-Table -AutoSize
if ($rdpRules.Count -eq 0) {
    Write-Warning 'No inbound firewall rule with local port 3389 was found.'
} else {
    $rdpRules | Select-Object DisplayName, Enabled, Profile, Action | Format-Table -AutoSize
}

if (-not $Apply) {
    Write-Host 'Audit only. Re-run with -Apply and a trusted -RdpAllowedRemoteAddress to make changes.'
    return
}

if ([string]::IsNullOrWhiteSpace($RdpAllowedRemoteAddress) -or -not (Test-IpOrCidr -Value $RdpAllowedRemoteAddress)) {
    throw 'Supply one trusted IP or CIDR with -RdpAllowedRemoteAddress. Wildcards and all-address ranges are rejected.'
}

$enabledRdpRules = @($rdpRules | Where-Object { $_.Enabled -eq 'True' -and $_.Action -eq 'Allow' })
if ($enabledRdpRules.Count -eq 0) {
    throw 'No enabled inbound RDP firewall rule was found; refusing to enable the firewall without a verified RDP path.'
}

Write-Warning 'Use a provider console or have console recovery ready. A wrong source IP can disconnect your RDP session.'
Write-Warning 'Apply the same source-IP restriction in the cloud network security group/firewall.'

if ($PSCmdlet.ShouldProcess('Windows Firewall and RDP rules', "Enable firewall, require NLA, restrict RDP to $RdpAllowedRemoteAddress")) {
    foreach ($rule in $rdpRules) {
        $addressFilters = @(Get-NetFirewallAddressFilter -AssociatedNetFirewallRule $rule)
        foreach ($addressFilter in $addressFilters) {
            Set-NetFirewallAddressFilter -InputObject $addressFilter -RemoteAddress $RdpAllowedRemoteAddress
        }
    }

    Set-ItemProperty -Path $nlaPath -Name UserAuthentication -Value 1
    Set-NetFirewallProfile -Profile Domain, Private, Public -Enabled True
    Write-Host 'Baseline applied. Confirm RDP and provider-level rules from a second session before closing console access.' -ForegroundColor Green
}

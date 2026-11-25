# Windows 11 in the Cloud: Free Trials, Licensing, and Safe Setup

> A source-backed guide to legitimate ways to try a Windows 11 cloud desktop without confusing a time-limited credit with a permanently free VPS.

**Research checked:** 25 November 2026  
**Status:** Community guide; provider offers and licensing can change. Verify current terms before deployment.

## Quick answer

There is no official, unlimited, always-free Windows 11 VPS offer identified in the sources reviewed for this guide. The practical no-cost route is a **time-limited cloud credit** or an **eligible education/development offer**. Windows 11 images also have licensing and usage restrictions. Treat the VM as a test environment, watch the credit balance, and delete every resource when finished.

### Best legitimate starting points

| Route | What can be free | Windows 11 caveat |
| --- | --- | --- |
| [Azure Free Account](https://azure.microsoft.com/en-us/pricing/purchase-options/azure-account) | Up to **US$200 of credit for 30 days** for new Azure customers | Microsoft says Student and Free Trial accounts can deploy Windows 11 images for development/testing. The Windows client image and VM size must be available to the subscription. Credit is temporary; it is not a free VPS plan. |
| [Azure for Students](https://azure.microsoft.com/en-us/free/students/) | **US$100 credit for 12 months**, no credit card, for eligible full-time university students | Windows 11 use is for development/testing. The monthly free VM sizes may not meet Windows 11 hardware requirements; price and size the actual VM before creating it. |
| [AWS WorkSpaces Free Tier](https://aws.amazon.com/workspaces/desktop-as-a-service/pricing/) | A limited trial: up to two Standard AutoStop desktops, 40 combined hours/month for up to three billing cycles | This is a managed virtual desktop, not a general-purpose VPS. The included free Windows offer is Windows Server. Windows 11 is supported through BYOL and requires an eligible license under Microsoft terms, so this is not a free Windows 11 license. |

## Azure: the most direct trial route

Microsoft's Azure deployment guidance says Student and Free Trial accounts can deploy Windows 11 images for development/testing. Windows client images and sizes are subscription-dependent, so confirm that the `Windows-11` image is visible in your Azure subscription before planning around it.

1. Check that you qualify for a new Azure Free Account or Azure for Students offer. Do not create duplicate accounts to obtain more credits.
2. In the Azure portal, confirm that a Windows 11 client image is available to your subscription and that the intended use is development/testing.
3. Check the VM size against [Windows 11 hardware requirements](https://learn.microsoft.com/en-us/windows/whats-new/windows-11-requirements). Do not assume the smallest free monthly VM size is sufficient.
4. Estimate the VM, disk, public IP, bandwidth, and any related services in the [Azure pricing calculator](https://azure.microsoft.com/en-us/pricing/calculator/) before deployment.
5. Set a budget/usage alert, use auto-shutdown, and keep the VM stopped when idle. Stopped VMs can still incur storage and other resource costs.
6. When the test is over, delete the VM and its attached or separately billed resources (disks, public IPs, snapshots, networking, and related services). Verify the resource group is empty.

The Azure Free Account offers up to $200 for 30 days and is limited to new customers. Signup asks for a phone number and a non-prepaid credit or debit card; a temporary $1 verification authorization may appear. Microsoft says it will not charge the payment method unless the account is moved to pay-as-you-go; at the end of the credit or 30-day period, the account and services are disabled unless upgraded. Read the current offer terms before signing up.

Azure for Students is different: it offers $100 of credit for 12 months to eligible full-time university students, with no credit card required. Microsoft requires student verification and sets eligibility conditions. The free monthly VM quotas are not a promise that a Windows 11-capable VM will be free; a suitable size can consume the credit.

## AWS WorkSpaces: useful distinction

AWS WorkSpaces offers a limited free tier for certain desktop configurations and hours. It is a managed virtual desktop, not a general-purpose VPS. Its pricing page describes the included Windows desktops as Windows Server. AWS separately documents Windows 10/11 support through Bring Your Own License (BYOL), subject to Microsoft's licensing terms. AWS also requires a paid account plan for access to the WorkSpaces console and may require payment details. Therefore:

- Do not describe the free Windows Server desktop as a Windows 11 VPS.
- Do not assume AWS trial credits grant a Windows 11 license.
- Use Windows 11 only if you already have an eligible license and confirm the WorkSpaces BYOL requirements and current pricing.
- The free period is limited; excess use and use after the offer ends can be billed.

## Licensing and intended use

Microsoft's Azure documentation distinguishes development/test use from production use. Student and Free Trial access to Windows 11 images is described for development/testing. Production Windows 11 deployments on Azure require qualifying subscription rights, such as eligible Microsoft 365, Windows Enterprise, Windows VDA, or Windows Education entitlements.

This guide is for lawful, personal experimentation and software testing. It does not provide activation bypasses, fake-account tactics, quota evasion, or instructions to repurpose CI runners as free desktops. Follow the cloud provider's acceptable-use rules and Microsoft's license terms.

## Included scripts

These scripts are deliberately **preflight and hardening tools**, not a one-click “free VPS” installer. A cloud VM can incur charges, and Windows 11 image access depends on the account's license and offer.

### 1. Check Azure Windows 11 images in a region

The read-only Azure CLI script lists Windows 11 marketplace image SKUs for a region. It creates or changes no cloud resources:

```bash
chmod +x scripts/list-azure-win11-images.sh
./scripts/list-azure-win11-images.sh francecentral
```

This is only an inventory check. It does not confirm that your subscription may deploy an image, that a VM size is eligible, or that the VM will fit within free credits. Verify licensing and estimate cost in the Azure portal before creating anything.

### 2. Audit and harden an existing Windows 11 VM

Run PowerShell as Administrator. By default, the script only reports firewall, NLA, and RDP-rule status:

```powershell
.\scripts\Set-Win11CloudBaseline.ps1
```

To apply the baseline, supply one trusted IPv4/IPv6 host address (or a `/32` or `/128` host CIDR) and use `-Apply`:

```powershell
.\scripts\Set-Win11CloudBaseline.ps1 -Apply -RdpAllowedRemoteAddress "YOUR_TRUSTED_PUBLIC_IP/32"
```

The script enables Windows Firewall, requires Network Level Authentication, and restricts existing inbound RDP rules to that source. Replace the placeholder with your real trusted host address; the placeholder is intentionally invalid, so it cannot be copied and applied as-is. Also restrict RDP in the cloud provider's network rules. Run from a provider console or ensure you have console recovery access: a wrong address can cut off RDP. `-WhatIf` previews changes.

The script does not disable Windows services or set an account lockout threshold. Disabling services can break features and updates; aggressive lockout policies can let an attacker lock you out. Source-IP restrictions, NLA, strong unique credentials, and MFA where available are safer starting points.

## Remote access safety checklist

- Prefer the provider's supported remote desktop client, a private network, or a managed bastion.
- Avoid exposing TCP 3389 to the entire internet. If direct RDP is unavoidable, restrict the source IP and remove the rule after use.
- Use a unique strong password and MFA where supported; never put credentials or access tokens in a public repository.
- Enable automatic shutdown and cost alerts before installing software.
- Back up only data you need, then remove the VM and all billable leftovers.
- Re-check the offer, regional availability, licensing, and pricing on the provider's official pages on the day you deploy.

## Why there is no one-click “free deployment” script

The suggested Azure command can create billable resources immediately. Trial credit is a budget, not a guarantee that a Windows 11 VM is free: image eligibility, license rights, VM size, disk, IP, region, and usage all matter. The suggested `Windows_Client` license flag also must not be treated as a way to obtain a license; use it only where you have the required entitlement. The supplied script also fetched a public IP from a third-party service and passed an administrator password as a command-line argument. This repository avoids both behaviors. It stops at read-only image discovery and asks users to review licensing, pricing, and network access before deployment.

No Oracle Windows 11 image-conversion script is included: this research did not establish a supported, license-compliant free Windows 11 path on Oracle Cloud.

## Sources

See [docs/research-sources.md](docs/research-sources.md) for the official sources, the claims they support, and the limits of this research. See [CONTRIBUTING.md](CONTRIBUTING.md) before proposing changes and [SECURITY.md](SECURITY.md) to report a security issue.

## Contributions

Corrections and source updates are welcome. Please include an official provider or Microsoft source and the date you checked it. Do not submit methods that bypass licensing, account eligibility, free-tier limits, or provider abuse controls.

## License

Documentation is licensed under the MIT License; see [LICENSE](LICENSE).

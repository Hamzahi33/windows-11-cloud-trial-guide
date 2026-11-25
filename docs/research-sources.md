# Research sources

Checked on 2026-11-25. This is a snapshot, not a guarantee that an offer remains available. Always re-check provider pricing and terms before signup or deployment.

## Microsoft Azure

1. [Azure Free Account / account options](https://azure.microsoft.com/en-us/pricing/purchase-options/azure-account)
   - States the Azure Free Account is for new customers and includes up to US$200 for 30 days.
   - Describes spending protection, identity verification, the temporary authorization, and that services are disabled unless the customer moves to pay-as-you-go after credit or 30 days.
2. [Use Windows client images in Azure for dev/test](https://learn.microsoft.com/en-us/azure/virtual-machines/windows/client-images)
   - Describes Windows 10/11 Enterprise images for development/test and subscription eligibility, including qualifying Visual Studio offer IDs.
3. [Deploy Windows 11 on Azure](https://learn.microsoft.com/en-us/azure/virtual-machines/windows/windows-desktop-multitenant-hosting-deployment)
   - Says Student and Free Trial accounts can deploy Windows 11 images for development/testing.
   - Lists qualifying subscription entitlements for production Windows 11 image use.
4. [Azure for Students](https://azure.microsoft.com/en-us/free/students/)
   - Describes the US$100 credit, 12-month period, no-credit-card signup, and full-time university student eligibility.
5. [Azure for Students offer details](https://azure.microsoft.com/en-us/pricing/offers/ms-azr-0170p/)
   - Sets eligibility, including age 18+, full-time enrollment at an accredited degree-granting institution, and student verification.
6. [Windows 11 commercial licensing overview](https://learn.microsoft.com/en-us/windows/whats-new/windows-licensing)
   - Summarizes Windows 11 commercial licensing offerings and virtual desktop access rights.
7. [Windows 11 system requirements](https://learn.microsoft.com/en-us/windows/whats-new/windows-11-requirements)
   - Lists the minimum CPU, memory, storage, UEFI/Secure Boot, and TPM requirements; a VM SKU must still support them.

## Amazon Web Services

8. [Amazon WorkSpaces DaaS pricing](https://aws.amazon.com/workspaces/desktop-as-a-service/pricing/)
   - Describes the limited WorkSpaces Free Tier, including usage caps and duration.
   - Describes Windows 11 as BYOL; Windows Server is listed in the included Windows Free Tier configurations.
9. [Amazon WorkSpaces FAQs](https://aws.amazon.com/workspaces-family/workspaces/faqs/)
   - Lists Windows Server images supplied by AWS and Windows 10/11 under Bring Your Own License.
10. [Oracle Cloud Free Tier](https://www.oracle.com/cloud/free/)
   - Lists the current free compute offerings and trial credits. It does not establish an always-free Windows 11 VPS path.

## Interpretation and limits

- No official, unlimited, always-free Windows 11 cloud VPS was identified in these sources.
- Azure's $200 trial credit can offset eligible Azure service costs for a limited time; it does not remove Windows licensing/use restrictions or make a VM permanently free.
- Azure for Students can help eligible students cover cloud costs, but the listed free monthly VM sizes may not meet Windows 11's hardware requirements. The user must check actual SKU eligibility and cost.
- AWS WorkSpaces' free Windows configurations are not a blanket Windows 11 license offer. Windows 11 use is BYOL and subject to Microsoft's current license terms.
- This guide does not assess account-specific eligibility, region availability, quotas, or exact VM costs. Use official calculators and account portals for those details.

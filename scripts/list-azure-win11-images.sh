#!/usr/bin/env bash
# Read-only Azure Marketplace image discovery for Windows 11.
# This script does not create, modify, or delete Azure resources.
set -euo pipefail

if ! command -v az >/dev/null 2>&1; then
  echo "Azure CLI (az) is required. Install it from https://learn.microsoft.com/cli/azure/install-azure-cli" >&2
  exit 1
fi

LOCATION="${1:-}"
if [[ -z "$LOCATION" ]]; then
  read -r -p "Azure region (for example, francecentral): " LOCATION
fi

if [[ ! "$LOCATION" =~ ^[a-zA-Z0-9-]+$ ]]; then
  echo "Invalid region name. Use letters, numbers, and hyphens only." >&2
  exit 2
fi

if ! az account show --only-show-errors --output none; then
  echo "No active Azure login. Run 'az login' and select the intended subscription first." >&2
  exit 3
fi

echo "Windows 11 Marketplace images in: $LOCATION"
echo "Publisher: MicrosoftWindowsDesktop | Offer: Windows-11"
echo ""
echo "This is an inventory lookup only; it does not verify licensing, quota, VM-size eligibility, or cost."
echo ""

az vm image list   --location "$LOCATION"   --publisher MicrosoftWindowsDesktop   --offer Windows-11   --all   --query "[].{SKU:sku, Version:version}"   --output table   --only-show-errors

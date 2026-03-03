#!/usr/bin/env bash
# Install additional cask apps not in the Brewfile.
# Currently all apps are in the Brewfile, so this is a placeholder
# for any apps that need special install logic.
set -euo pipefail

echo "All apps are installed via Brewfile in step 01."
echo "Verifying key apps ..."

apps=("Ghostty" "Visual Studio Code" "Telegram" "Slack" "WhatsApp" "Microsoft Outlook")
for app in "${apps[@]}"; do
  if [[ -d "/Applications/$app.app" ]] || [[ -d "$HOME/Applications/$app.app" ]]; then
    echo "  OK: $app"
  else
    echo "  MISSING: $app (may need manual install or different bundle name)"
  fi
done

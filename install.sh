#!/bin/sh
set -eu

CONTROL_URL="https://raw.githubusercontent.com/parussel/fhem-style-153er-netz/main/controls_153er_netz_theme.txt"

printf '%s\n' \
  "In die FHEM-Befehlszeile kopieren:" \
  "update add $CONTROL_URL" \
  "update check 153er_netz_theme" \
  "update all 153er_netz_theme" \
  "Danach unter Select Style: 153er_netz auswählen."

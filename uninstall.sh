#!/bin/sh
set -eu

FHEM_ROOT="${1:-/opt/fhem}"

case "$FHEM_ROOT" in
  /|""|/opt|/usr|/var) echo "Unsicheres Zielverzeichnis: $FHEM_ROOT" >&2; exit 2 ;;
esac

if [ ! -d "$FHEM_ROOT/www/pgm2" ]; then
  echo "Kein FHEM-www/pgm2 unter $FHEM_ROOT gefunden." >&2
  exit 2
fi

rm -f \
  "$FHEM_ROOT/www/pgm2/153er_netzstyle.css" \
  "$FHEM_ROOT/www/pgm2/153er_netzfloorplanstyle.css" \
  "$FHEM_ROOT/www/pgm2/153er_netzsvg_style.css" \
  "$FHEM_ROOT/www/pgm2/153er_netzsvg_defs.svg" \
  "$FHEM_ROOT/www/pgm2/153er_netz.js"
rm -rf "$FHEM_ROOT/www/153er-netz" "$FHEM_ROOT/www/images/153er_netz"

echo "Dateien der 153er-netz.de Edition wurden aus $FHEM_ROOT entfernt."

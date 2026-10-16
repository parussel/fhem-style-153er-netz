#!/bin/sh
set -eu

usage() {
  cat <<'EOF'
Verwendung:
  sh uninstall.sh --dry-run [FHEM-Verzeichnis]
  sudo sh uninstall.sh --remove [FHEM-Verzeichnis]

Ohne --remove wird nichts geloescht.
EOF
}

MODE=${1:-}
case "$MODE" in
  --dry-run|--remove) shift ;;
  -h|--help) usage; exit 0 ;;
  *) usage >&2; exit 2 ;;
esac

FHEM_ROOT_INPUT=${1:-/opt/fhem}
if [ "$#" -gt 1 ]; then
  usage >&2
  exit 2
fi

case "$FHEM_ROOT_INPUT" in
  /|""|/opt|/usr|/var) echo "Unsicheres Zielverzeichnis: $FHEM_ROOT_INPUT" >&2; exit 2 ;;
esac

if [ ! -d "$FHEM_ROOT_INPUT" ]; then
  echo "Zielverzeichnis nicht gefunden: $FHEM_ROOT_INPUT" >&2
  exit 2
fi

FHEM_ROOT=$(CDPATH= cd -- "$FHEM_ROOT_INPUT" && pwd -P)
case "$FHEM_ROOT" in
  /|""|/opt|/usr|/var) echo "Unsicheres Zielverzeichnis: $FHEM_ROOT" >&2; exit 2 ;;
esac

if [ ! -f "$FHEM_ROOT/fhem.pl" ] || [ ! -d "$FHEM_ROOT/www/pgm2" ]; then
  echo "Kein vollstaendiges FHEM-Verzeichnis unter $FHEM_ROOT gefunden." >&2
  exit 2
fi

PACKAGE_FILES='www/153er-netz/images/153er_netz.png
www/153er-netz/images/bg_wrapper.jpg
www/images/153er_netz/doorhandle.svg
www/images/153er_netz/favicon.ico
www/images/153er_netz/heater.svg
www/images/153er_netz/off.svg
www/images/153er_netz/on.svg
www/images/153er_netz/plug.svg
www/images/153er_netz/power.svg
www/images/153er_netz/router.svg
www/images/153er_netz/smartphone.svg
www/images/153er_netz/tv.svg
www/images/153er_netz/weather.svg
www/pgm2/153er_netz.js
www/pgm2/153er_netzfloorplanstyle.css
www/pgm2/153er_netzstyle.css
www/pgm2/153er_netzsvg_defs.svg
www/pgm2/153er_netzsvg_style.css'

if [ "$MODE" = "--dry-run" ]; then
  echo "Vorschau: Folgende vorhandene Dateien wuerden entfernt:"
  printf '%s\n' "$PACKAGE_FILES" | while IFS= read -r relative; do
    if [ -e "$FHEM_ROOT/$relative" ]; then
      echo "  $FHEM_ROOT/$relative"
    fi
  done
  echo "Es wurde nichts geloescht. Eigene Dateien in den Verzeichnissen bleiben auch bei --remove erhalten."
  exit 0
fi

printf '%s\n' "$PACKAGE_FILES" | while IFS= read -r relative; do
  rm -f -- "$FHEM_ROOT/$relative"
done

# Nur jetzt leere Edition-Verzeichnisse entfernen. Eigene Dateien verhindern rmdir.
rmdir -- "$FHEM_ROOT/www/153er-netz/images" 2>/dev/null || true
rmdir -- "$FHEM_ROOT/www/153er-netz" 2>/dev/null || true
rmdir -- "$FHEM_ROOT/www/images/153er_netz" 2>/dev/null || true

echo "Die 18 Paketdateien der 153er-netz.de Edition wurden entfernt. Andere Dateien blieben erhalten."

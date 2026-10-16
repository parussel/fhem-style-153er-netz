#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROJECT_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
TEST_ROOT=$(mktemp -d)
trap 'rm -rf -- "$TEST_ROOT"' EXIT HUP INT TERM

mkdir -p \
  "$TEST_ROOT/www/pgm2" \
  "$TEST_ROOT/www/153er-netz/images" \
  "$TEST_ROOT/www/images/153er_netz"
touch "$TEST_ROOT/fhem.pl"

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

printf '%s\n' "$PACKAGE_FILES" | while IFS= read -r relative; do
  printf 'package file\n' > "$TEST_ROOT/$relative"
done

printf 'keep me\n' > "$TEST_ROOT/www/pgm2/otherstyle.css"
printf 'keep me\n' > "$TEST_ROOT/www/153er-netz/user-note.txt"
printf 'keep me\n' > "$TEST_ROOT/www/images/153er_netz/user-icon.svg"

sh "$PROJECT_ROOT/uninstall.sh" --dry-run "$TEST_ROOT"

printf '%s\n' "$PACKAGE_FILES" | while IFS= read -r relative; do
  if [ ! -f "$TEST_ROOT/$relative" ]; then
    echo "FAIL: preview removed $relative" >&2
    exit 1
  fi
done

sh "$PROJECT_ROOT/uninstall.sh" --remove "$TEST_ROOT"

printf '%s\n' "$PACKAGE_FILES" | while IFS= read -r relative; do
  if [ -e "$TEST_ROOT/$relative" ]; then
    echo "FAIL: package file remains after removal: $relative" >&2
    exit 1
  fi
done

for preserved in \
  www/pgm2/otherstyle.css \
  www/153er-netz/user-note.txt \
  www/images/153er_netz/user-icon.svg; do
  if [ ! -f "$TEST_ROOT/$preserved" ]; then
    echo "FAIL: unrelated user file was removed: $preserved" >&2
    exit 1
  fi
done

if sh "$PROJECT_ROOT/uninstall.sh" --remove / >/dev/null 2>&1; then
  echo 'FAIL: filesystem root was accepted' >&2
  exit 1
fi

echo 'UNINSTALL_SAFETY_TESTS_OK'

#!/bin/sh
set -eu

OUT="controls_153er_netz_theme.txt"
STAMP="$(date '+%Y-%m-%d_%H:%M:%S')"
: > "$OUT"

find ./www -type f \( \
  -path './www/pgm2/153er_netz*' -o \
  -path './www/153er-netz/*' -o \
  -path './www/images/153er_netz/*' \
\) -print | LC_ALL=C sort | while IFS= read -r file; do
  size="$(wc -c < "$file" | tr -d ' ')"
  clean="${file#./}"
  printf 'UPD %s %s %s\n' "$STAMP" "$size" "$clean" >> "$OUT"
done

printf 'Generated %s\n' "$OUT"

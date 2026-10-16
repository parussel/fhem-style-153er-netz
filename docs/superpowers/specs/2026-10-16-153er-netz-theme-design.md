# FHEM Style – 153er Netz Edition Design

## Goal

Create an independently installable FHEM theme derived from Kleinor's `version-2` release 2.19 while preserving every layout dimension, spacing rule, selector behavior, and JavaScript interaction.

## Visual design

- Keep the fixed 220 × 120 px logo area in the upper-left corner.
- Logo composition: fish, cross, and fishing net on the left; `153er-` on the upper right and `netz.de` below it.
- Use a dark navy background with softly blurred warm-gold nodes and faint connecting lines.
- Animate only the decorative background layers with slow, low-amplitude movement. Disable the animation for `prefers-reduced-motion: reduce`.
- Replace the orange primary accent with warm gold while preserving all status, plot, neutral, and readability colors.
- Until an official source logo is supplied, keep the current emblem explicitly documented as a concept asset, not an official original.

## Isolation and compatibility

- Runtime namespace: `153er_netz`.
- Do not overwrite the upstream `hausautomatisierung_com` theme.
- Preserve all geometry and behavior from version 2.19.
- Do not add version-3 responsive behavior.
- The existing menu link for reporting theme errors points to the new GitHub repository.
- The logo is not made clickable; the displayed domain provides attribution without adding behavior.

## Distribution

- Install through `controls_153er_netz_theme.txt` using FHEM `update add`, `update check`, and `update all`.
- Document switching back to another style before uninstalling.
- Document `update delete <control-file-url>` as repository deregistration only.
- Provide an explicit uninstall script/list that removes only files owned by this edition.
- Preserve the upstream MIT license and attribution; document separate asset provenance.

## Acceptance

- Generated CSS differs from upstream only in namespace paths, approved colors, logo/background presentation, and isolated background animation.
- JavaScript behavior stays identical except the theme version/name and GitHub issue URL.
- Installation and uninstall manifests contain only edition-owned paths.
- No running FHEM instance or migration data is changed during development.

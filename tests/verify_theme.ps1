$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if (-not (Test-Path (Join-Path $root 'README.md'))) { $root = Split-Path -Parent $PSScriptRoot }

$required = @(
    'www/pgm2/153er_netzstyle.css',
    'www/pgm2/153er_netzfloorplanstyle.css',
    'www/pgm2/153er_netzsvg_style.css',
    'www/pgm2/153er_netz.js',
    'www/153er-netz/images/153er_netz.png',
    'www/153er-netz/images/bg_wrapper.jpg',
    'controls_153er_netz_theme.txt',
    'install.sh',
    'uninstall.sh',
    'ASSETS.md'
)

$failures = [System.Collections.Generic.List[string]]::new()
foreach ($relative in $required) {
    if (-not (Test-Path -LiteralPath (Join-Path $root $relative))) {
        $failures.Add("Missing required file: $relative")
    }
}

$varsPath = Join-Path $root 'sass/_vars.scss'
$basePath = Join-Path $root 'sass/_base.scss'
$menuPath = Join-Path $root 'sass/_menu.scss'
$vars = Get-Content -Raw $varsPath
$base = Get-Content -Raw $basePath
$menu = Get-Content -Raw $menuPath

$upstreamFavicon = (Get-FileHash (Join-Path $root 'www/images/hausautomatisierung_com/favicon.ico') -Algorithm SHA256).Hash
$editionFavicon = (Get-FileHash (Join-Path $root 'www/images/153er_netz/favicon.ico') -Algorithm SHA256).Hash
if ($upstreamFavicon -eq $editionFavicon) { $failures.Add('Edition still contains the upstream branded favicon') }

foreach ($layoutRule in @('$menuWidth: 300px;', '$maxWidthContent: 1000px;', '$default-fontsize: 13px;', '$large-fontsize: 16px;')) {
    if (-not $vars.Contains($layoutRule)) { $failures.Add("Layout constant changed or missing: $layoutRule") }
}
foreach ($layoutRule in @('height: 120px;', 'width: 220px;', 'margin-left: 40px;', 'margin-top: 10px;', 'left: 320px;')) {
    if (-not $base.Contains($layoutRule)) { $failures.Add("Base layout rule changed or missing: $layoutRule") }
}
foreach ($layoutRule in @('margin-left: 20px;', 'margin-top: 140px;', 'width: $menuWidth - 40px;')) {
    if (-not $menu.Contains($layoutRule)) { $failures.Add("Menu layout rule changed or missing: $layoutRule") }
}
if ($base -notmatch 'prefers-reduced-motion:\s*reduce') { $failures.Add('Missing reduced-motion fallback') }
if ($base -notmatch '@keyframes\s+netzWabern') { $failures.Add('Missing background animation') }
if ($vars -notmatch '\$primary-color:\s*#d6a62e;') { $failures.Add('Primary gold accent is not synchronized') }
if ($menu -match 'rgb\(229,\s*101,\s*36\)') { $failures.Add('Legacy orange remains in menu arrows') }
if ($base -match '#e56524') { $failures.Add('Legacy orange remains in base form border') }
if ($base -match '@media\s*\(max-width:\s*798px\)') { $failures.Add('Forbidden version-3 responsive breakpoint found') }

$controlPath = Join-Path $root 'controls_153er_netz_theme.txt'
if (Test-Path $controlPath) {
    $control = Get-Content -Raw $controlPath
    if ($control -match 'hausautomatisierung_com') { $failures.Add('Control manifest would overwrite upstream theme files') }
    foreach ($relative in $required[0..5]) {
        if (-not $control.Contains($relative)) { $failures.Add("Control manifest missing runtime file: $relative") }
    }
    foreach ($line in (Get-Content $controlPath)) {
        if ($line -notmatch '^UPD\s+\S+\s+(\d+)\s+(.+)$') { $failures.Add("Invalid control line: $line"); continue }
        $declaredSize = [int64]$Matches[1]
        $relative = $Matches[2]
        $target = Join-Path $root $relative
        if (-not (Test-Path -LiteralPath $target)) { $failures.Add("Control target missing: $relative"); continue }
        if ((Get-Item -LiteralPath $target).Length -ne $declaredSize) { $failures.Add("Control size mismatch: $relative") }
    }
}

$jsPath = Join-Path $root 'www/pgm2/153er_netz.js'
if (Test-Path $jsPath) {
    $js = Get-Content -Raw $jsPath
    if (-not $js.Contains('parussel/fhem-style-153er-netz/issues')) { $failures.Add('JavaScript issue link is not namespaced') }
    $upstreamJs = Get-Content -Raw (Join-Path $root 'www/pgm2/hausautomatisierung_com.js')
    $normalizedJs = $js.Replace("var themeVersion = '1.0.0';", "var themeVersion = '2.19';").Replace(
        'https://github.com/parussel/fhem-style-153er-netz/issues/',
        'https://github.com/klein0r/fhem-style-haus-automatisierung/issues/'
    )
    $normalizeWhitespace = { param($text) (($text -replace "`r`n", "`n") -replace '(?m)[ \t]+$', '').TrimEnd() }
    if ((& $normalizeWhitespace $upstreamJs) -ne (& $normalizeWhitespace $normalizedJs)) { $failures.Add('JavaScript behavior differs beyond approved identity strings') }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "PASS: $($required.Count) required files and layout/package invariants verified."

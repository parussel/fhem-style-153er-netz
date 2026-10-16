# FHEM Style – 153er-netz.de Edition

Eigenständig installierbare Edition des FHEM-Styles von [Matthias Kleine (Kleinor)](https://github.com/klein0r/fhem-style-haus-automatisierung), basierend auf Version 2.19. Layout, Abstände, Größen und Bedienfunktionen bleiben unverändert. Geändert sind Theme-Namespace, Logo, Hintergrund und die primäre Akzentfarbe.

![Vorschau des FHEM Styles – 153er-netz.de Edition](preview.png)

> Das derzeit enthaltene Fisch-Kreuz-Netz-Logo ist ein freigegebener Konzeptentwurf. Es wird durch das offizielle Original ersetzt, sobald dieses als freigestellte Quelldatei vorliegt.

## Installation per Copy & Paste

Die folgenden Befehle einzeln und in dieser Reihenfolge im FHEM-Kommandoeingabefeld ausführen. Nach jedem Befehl die Rückmeldung abwarten; nicht alle Befehle gemeinsam kopieren.

```text
update add https://raw.githubusercontent.com/parussel/fhem-style-153er-netz/main/controls_153er_netz_theme.txt
```

```text
update check 153er_netz_theme
```

Erst wenn die Vorschau ausschließlich Dateien mit `153er-netz` beziehungsweise `153er_netz` nennt, die Installation ausführen:

```text
update all 153er_netz_theme
```

Wenn FHEM nach der Installation `shutdown restart` empfiehlt, FHEM damit neu starten und warten, bis die Oberfläche wieder erreichbar ist.

Danach unter **Select Style** den Style `153er_netz` auswählen. Auf der anschließenden Meldungsseite nicht wiederholt den Browser-Neuladen-Knopf verwenden, da dadurch der Auswahlbefehl erneut aufgerufen werden kann. Stattdessen auf das FHEM-Logo beziehungsweise die Startseite wechseln oder die FHEM-Adresse ohne einen Zusatz hinter `/fhem` öffnen. Falls der Browser noch alte Style-Dateien zwischengespeichert hat, dort einmal mit `Strg` + `F5` vollständig neu laden.

Optionale Einstellungen wie beim Original (für den Style nicht erforderlich):

Vorher die bestehenden Werte einzeln prüfen:

```text
list WEB JavaScripts
```

```text
list WEB codemirrorParam
```

```text
list WEB roomIcons
```

Die folgenden Ergänzungen nur ausführen, wenn der jeweilige Bestandteil noch nicht vorhanden ist. `JavaScripts` und `roomIcons` werden mit `attr -a` ergänzt, damit andere vorhandene Einträge erhalten bleiben:

```text
attr -a WEB JavaScripts codemirror/fhem_codemirror.js
```

```text
attr -a WEB roomIcons Save.config:message_attention
```

`codemirrorParam` ist dagegen ein zusammenhängender Einstellungswert. Der folgende Befehl ersetzt einen eventuell vorhandenen Wert vollständig und sollte daher nur nach Prüfung beziehungsweise Sicherung des bisherigen Werts verwendet werden:

```text
attr WEB codemirrorParam { "theme": "blackboard", "lineNumbers":true, "lineWrapping": true, "height": "auto", "autocomplete": true }
```

## Rückwechsel und Deinstallation

1. Unter **Select Style** zuerst einen anderen installierten Style auswählen.
2. Über das FHEM-Logo beziehungsweise die FHEM-Startseite prüfen, dass der andere Style vollständig geladen wurde.
3. Falls FHEM eine ungespeicherte Änderung anzeigt, `save` ausführen.
4. Erst danach die Updatequelle im FHEM-Kommandoeingabefeld abmelden:

```text
update delete https://raw.githubusercontent.com/parussel/fhem-style-153er-netz/main/controls_153er_netz_theme.txt
```

Das Deinstallationsskript ist bewusst nicht Bestandteil der FHEM-Installation. Es wird für die Prüfung direkt aus diesem Repository nach `/tmp` geladen:

```sh
curl -fL --proto '=https' --tlsv1.2 -o /tmp/uninstall-153er-netz.sh https://raw.githubusercontent.com/parussel/fhem-style-153er-netz/main/uninstall.sh
```

Zuerst nur anzeigen, welche vorhandenen Dateien entfernt würden:

```sh
sh /tmp/uninstall-153er-netz.sh --dry-run /opt/fhem
```

Erst wenn diese Vorschau ausschließlich die Dateien der `153er-netz.de Edition` enthält, die Entfernung ausdrücklich starten:

```sh
sudo sh /tmp/uninstall-153er-netz.sh --remove /opt/fhem
```

Das Skript entfernt einzeln genau die 18 ausgelieferten Theme-Dateien. Verzeichnisse werden nur entfernt, wenn sie anschließend leer sind. Eigene oder später hinzugefügte Dateien bleiben dadurch erhalten.

### Optionale Einstellungen zurücknehmen

Die drei oben genannten `WEB`-Einstellungen sind vom Style unabhängig, stören nach dessen Entfernung nicht und werden daher nicht automatisch verändert. Wer sie ausschließlich für diese Installation ergänzt hat, kann die beiden ergänzten Bestandteile gezielt entfernen:

```text
attr -r WEB JavaScripts codemirror/fhem_codemirror.js
```

```text
attr -r WEB roomIcons Save.config:message_attention
```

`codemirrorParam` nur dann vollständig entfernen, wenn das Attribut vorher nicht vorhanden war und ausschließlich durch die obige Empfehlung gesetzt wurde:

```text
deleteattr WEB codemirrorParam
```

Anschließend die angezeigte Konfigurationsänderung mit `save` sichern. Wenn frühere eigene Werte vorhanden waren, diese statt einer Löschung aus der eigenen Sicherung wiederherstellen.

## Hintergrundanimation

Der Hintergrund bewegt sich langsam über einen 52-Sekunden-Zyklus. Menüs, Tabellen und Steuerelemente bewegen sich nicht. Bei `prefers-reduced-motion: reduce` ist die Animation deaktiviert.

## Entwicklung und Prüfung

```powershell
powershell -ExecutionPolicy Bypass -File tests/verify_theme.ps1
```

```sh
sh tests/test_uninstall.sh
```

## Dank

Ein besonderer Dank gilt [Matthias Kleine (Kleinor)](https://github.com/klein0r/fhem-style-haus-automatisierung). Sein FHEM-Style und seine weitere Arbeit rund um FHEM haben meine eigene Hausautomation und dieses Projekt entscheidend vorangebracht. Diese Edition wäre ohne seine sorgfältige Vorarbeit nicht entstanden.

Auch wenn sein heutiger Schwerpunkt bei anderen Bereichen der Haus- und Gebäudeautomation liegt, arbeitet er weiterhin an zahlreichen Smart-Home-Projekten. Vielen Dank für die investierte Zeit, das offen geteilte Wissen und die hervorragende Arbeit.

## Herkunft und Lizenz

Quellcode unter MIT-Lizenz, abgeleitet von [klein0r/fhem-style-haus-automatisierung](https://github.com/klein0r/fhem-style-haus-automatisierung), Version 2.19. Bildquellen stehen in [ASSETS.md](ASSETS.md).

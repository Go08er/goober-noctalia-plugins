# Goober Noctalia Plugins

Third-party Noctalia plugin registry.

## Plugins

- `hydra-update-examiner`: bar widget that estimates NixOS/Nixpkgs channel readiness from Hydra eval and channel gate status.

## Repository Layout

```text
registry.json
hydra-update-examiner/
  manifest.json
  preview.png
  README.md
  Main.qml
  BarWidget.qml
  Settings.qml
  i18n/
    en.json
  scripts/
    hydra-unstable-progress
```

## Noctalia Source

After this repository is published, add it to Noctalia's plugin sources:

```json
{
  "enabled": true,
  "name": "Goober Noctalia Plugins",
  "url": "https://github.com/Go08er/goober-noctalia-plugins"
}
```

Noctalia expects `registry.json` at the repository root and plugin directories named by plugin id.


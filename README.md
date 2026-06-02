# Goober Noctalia Plugins

Custom plugin source for [Noctalia](https://github.com/noctalia-dev/noctalia-shell).

This repository is structured for Noctalia's plugin manager: `registry.json` lives
at the repository root, and each plugin is stored in a directory named after its
plugin id.

## Plugins

- `hydra-update-examiner`: bar widget that estimates NixOS/Nixpkgs channel
  readiness from Hydra eval and channel gate status.

## Add This Source

Add this repository as a custom plugin source in Noctalia:

```json
{
  "enabled": true,
  "name": "Goober Noctalia Plugins",
  "url": "https://github.com/Go08er/goober-noctalia-plugins"
}
```

After adding the source, install `Hydra Update Examiner` through Noctalia's
plugin interface.

## Repository Contents

- `registry.json`: source index consumed by Noctalia.
- `hydra-update-examiner/`: installable plugin package.
- `hydra-update-examiner/manifest.json`: plugin metadata.
- `hydra-update-examiner/preview.png`: store preview image.
- `hydra-update-examiner/README.md`: plugin documentation.

## Repository Layout

```text
registry.json
hydra-update-examiner/
  manifest.json
  LICENSE
  preview.png
  README.md
  Main.qml
  BarWidget.qml
  Settings.qml
  i18n/
    en.json
  scripts/
    hydra-channel-progress
```

## Updating The Registry

When a plugin changes, update the plugin directory, bump the plugin version in
both `manifest.json` and `registry.json`, then push the repository. Noctalia
users receive the updated package from this source.

## License

This repository is MIT licensed. Plugins may also include a plugin-local
license file when useful for plugin-manager packaging; `Hydra Update Examiner`
is MIT licensed.

# Goober Noctalia Plugins

Custom plugin source for [Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell).

This repository is structured for Noctalia's plugin manager. `registry.json`
lives at the repository root, and each plugin is stored in a directory named
after its plugin id.

## Available Plugins

| Plugin | Description |
| --- | --- |
| `hydra-update-examiner` | Bar widget that estimates NixOS/Nixpkgs channel readiness from Hydra evaluation and channel-gate status. |

## Install Source

Add this repository as a custom plugin source in Noctalia:

```json
{
  "enabled": true,
  "name": "Goober Noctalia Plugins",
  "url": "https://github.com/Go08er/goober-noctalia-plugins"
}
```

Then install `Hydra Update Examiner` through Noctalia's plugin interface.

If the plugin does not appear immediately, refresh the plugin source list or
restart Noctalia Shell.

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

## Maintenance

When a plugin changes:

1. Update the plugin package directory.
2. Bump the version in both `hydra-update-examiner/manifest.json` and `registry.json`.
3. Validate JSON and script syntax.
4. Push to `main`.
5. Create a matching GitHub release tag, such as `v1.3.0`.

Version tags are used as release notes for users and as a clear update boundary
for the custom source.

## Support

This is a community-maintained plugin source. File issues on this repository
with:

- Noctalia version.
- Plugin version.
- Channel being monitored.
- Screenshot or copied tooltip text.
- Output from `hydra-update-examiner/scripts/hydra-channel-progress --channel <channel>` when relevant.

Pull requests are welcome when they keep the plugin source layout compatible
with Noctalia's plugin manager.

## License

This repository is MIT licensed. Unless a plugin says otherwise, plugin QML,
scripts, documentation, and preview assets in this repository are MIT licensed.

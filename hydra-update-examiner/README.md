# Hydra Update Examiner

Noctalia bar widget for estimating how close a NixOS or Nixpkgs channel is to
publishing its next update.

![Hydra Update Examiner preview](preview.png)

## What It Does

Hydra Update Examiner checks public NixOS Hydra and channel endpoints on demand.
It displays a readiness score in the Noctalia bar and switches to `Launched`
when the latest visible evaluation revision matches the public channel revision.

The score combines:

- Candidate evaluation progress.
- Channel-gate status, such as `tested` or `unstable`.
- Failed and pending gate constituent builds.
- Published channel revision from `channels.nixos.org`.

This is a heuristic. Hydra does not publish a single authoritative “channel will
advance in N minutes” value.

## Data Sources

The plugin uses Hydra's JSON API for evaluation metadata, channel-gate build
status, and gate constituent counts. Candidate-wide progress still reads
Hydra's evaluation summary page because the JSON evaluation payload exposes the
full build-id list, not Hydra's grouped queued/succeeded/failed summary.

Normal exact-channel refreshes currently use several public `GET` requests:

- `channels.nixos.org/<channel>/git-revision`
- `hydra.nixos.org/jobset/<project>/<jobset>/evals`
- `hydra.nixos.org/eval/<eval-id>`
- `hydra.nixos.org/eval/<eval-id>/job/<gate>`
- `hydra.nixos.org/build/<build-id>/constituents`

Stable aliases also query the public Nix channel listing from
`nix-channels.s3.amazonaws.com`.

The widget has a short client-side refresh cooldown so repeated clicks do not
hammer public infrastructure.

## Install

Install through Noctalia's plugin manager after adding this custom source:

```json
{
  "enabled": true,
  "name": "Goober Noctalia Plugins",
  "url": "https://github.com/Go08er/goober-noctalia-plugins"
}
```

Restart Noctalia Shell if the widget is not loaded immediately.

## Runtime Requirements

Requires Noctalia `4.6.6` or newer.

Required commands:

- `bash`
- `curl`
- `jq`
- `perl`
- `grep`
- `awk`
- `sed`
- `timeout`
- `xdg-open`

On NixOS, most of these are usually already available. Add the missing user
tools if needed:

```nix
environment.systemPackages = with pkgs; [
  curl
  jq
  xdg-utils
];
```

To test the helper script in a temporary Nix shell:

```bash
nix shell nixpkgs#curl nixpkgs#jq nixpkgs#perl nixpkgs#gnugrep nixpkgs#gawk nixpkgs#gnused nixpkgs#coreutils
./scripts/hydra-channel-progress --channel nixos-unstable
```

## Settings

- Channel preset: `nixos-unstable`, `nixos-unstable-small`, current stable NixOS, current stable small, `nixpkgs-unstable`, or an exact supported channel.
- Refresh interval in minutes.
- Noctalia color keys for running, stalled, close, and launched states.
- Icon names for running, stalled, close, and launched states.
- Close threshold, defaulting to 90%.
- Percent text display: follow Noctalia hover behavior, always show percent, or icon only.

Supported exact channel names:

| Channel | Hydra jobset | Gate job |
| --- | --- | --- |
| `nixos-unstable` | `nixos:unstable` | `tested` |
| `nixos-unstable-small` | `nixos:unstable-small` | `tested` |
| `nixos-stable` | Resolves to the current supported `nixos-YY.MM` channel | `tested` |
| `nixos-stable-small` | Resolves to the current supported `nixos-YY.MM-small` channel | `tested` |
| `nixos-YY.MM` | `nixos:release-YY.MM` | `tested` |
| `nixos-YY.MM-small` | `nixos:release-YY.MM-small` | `tested` |
| `nixpkgs-unstable` | `nixpkgs:unstable` | `unstable` |

The exact-channel field is not a generic third-party Hydra URL. It accepts only
public NixOS/Nixpkgs channels whose Hydra project, jobset, and publication gate
are mapped by the script.

## Troubleshooting

`ERR` usually means a required command is missing, a channel is unsupported, or
Hydra/channel infrastructure was unreachable.

`HYD` means the script reached Hydra but could not identify or parse the current
evaluation.

If the widget does not load:

1. Confirm the plugin is installed and enabled in Noctalia.
2. Restart Noctalia Shell.
3. Run the helper script directly:

   ```bash
   ~/.config/noctalia/plugins/hydra-update-examiner/scripts/hydra-channel-progress --channel nixos-unstable
   ```

Frequent manual refreshes, short refresh intervals, network proxies, TLS
inspection, captive portals, or Hydra gateway timeouts can all produce temporary
error states. The plugin does not use credentials and only performs read-only
public requests, but public services still see normal client metadata such as IP
address and user agent.

## Notes

The estimate follows the newest visible candidate evaluation for the selected
channel. It does not search backward for an older publishable evaluation if a
newer evaluation is still queued or blocked.

`100%` means the candidate appears ready or publication is imminent. `Launched`
means the latest visible evaluation revision is already the public channel
revision and users can update.

## AI Assistance

This plugin was developed with AI assistance from OpenAI Codex. The maintainer
reviewed the implementation and accepts responsibility for the published code
and packaging.

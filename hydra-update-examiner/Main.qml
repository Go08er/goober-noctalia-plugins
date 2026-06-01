import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Item {
  id: root

  property var pluginApi: null

  readonly property string scriptPath: decodeURIComponent(Qt.resolvedUrl("scripts/hydra-unstable-progress").toString().replace("file://", ""))
  readonly property var cfg: pluginApi?.pluginSettings || ({})
  readonly property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})
  readonly property int refreshIntervalMinutes: Math.max(1, cfg.refreshIntervalMinutes ?? defaults.refreshIntervalMinutes ?? 60)
  readonly property string channelPreset: cfg.channelPreset ?? defaults.channelPreset ?? "nixos-unstable"
  readonly property string customChannel: cfg.customChannel ?? defaults.customChannel ?? ""
  readonly property string selectedChannel: channelPreset === "custom" ? customChannel : channelPreset
  readonly property string runningColor: cfg.runningColor ?? defaults.runningColor ?? "secondary"
  readonly property string stalledColor: cfg.stalledColor ?? defaults.stalledColor ?? "error"
  readonly property string closeColor: cfg.closeColor ?? defaults.closeColor ?? "tertiary"
  readonly property string launchedColor: cfg.launchedColor ?? defaults.launchedColor ?? "primary"
  readonly property string runningIcon: cfg.runningIcon ?? defaults.runningIcon ?? "server-bolt"
  readonly property string stalledIcon: cfg.stalledIcon ?? defaults.stalledIcon ?? "server-off"
  readonly property string closeIcon: cfg.closeIcon ?? defaults.closeIcon ?? "server-spark"
  readonly property string launchedIcon: cfg.launchedIcon ?? defaults.launchedIcon ?? "rocket"
  readonly property int closeThreshold: Math.max(1, Math.min(100, cfg.closeThreshold ?? defaults.closeThreshold ?? 90))

  property string statusText: "HYD"
  property string statusIcon: "server"
  property string statusTooltip: pluginApi?.tr("widget.notFetched")
  property string statusIconColor: "none"
  property string statusTextColor: "none"
  property string statusUrl: "https://hydra.nixos.org/jobset/nixos/unstable/evals"
  property bool loading: false
  property string lastUpdated: ""

  IpcHandler {
    target: "plugin:hydra-update-examiner"

    function refresh() {
      root.refresh()
    }

    function open() {
      root.openHydra()
    }
  }

  Timer {
    id: refreshTimer
    interval: root.refreshIntervalMinutes * 60 * 1000
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  Process {
    id: statusProc
    stdout: StdioCollector {}
    stderr: StdioCollector {}

    onExited: (exitCode) => {
      root.loading = false
      if (exitCode !== 0) {
        const err = String(stderr.text).trim()
        root.statusText = "ERR"
        root.statusIcon = "server-off"
        root.statusTooltip = err ? pluginApi?.tr("widget.commandFailedWithError", { "error": err }) : pluginApi?.tr("widget.commandFailed")
        root.statusIconColor = "error"
        root.statusTextColor = "error"
        root.statusUrl = ""
        return
      }

      try {
        const parsed = JSON.parse(String(stdout.text).trim())
        root.statusText = parsed.text || "HYD"
        root.statusIcon = parsed.icon || "server"
        root.statusTooltip = parsed.tooltip || pluginApi?.tr("widget.unavailable")
        root.statusIconColor = parsed.iconColor || "none"
        root.statusTextColor = parsed.textColor || "none"
        root.statusUrl = parsed.url !== undefined ? parsed.url : root.statusUrl
        root.lastUpdated = new Date().toLocaleTimeString()
      } catch (e) {
        Logger.w("HydraUnstableProgress", "Failed to parse status JSON: " + e)
        root.statusText = "ERR"
        root.statusIcon = "server-off"
        const raw = String(stdout.text).trim()
        root.statusTooltip = raw ? pluginApi?.tr("widget.invalidJsonWithOutput", { "output": raw.slice(0, 500) }) : pluginApi?.tr("widget.invalidJson")
        root.statusIconColor = "error"
        root.statusTextColor = "error"
        root.statusUrl = ""
      }
    }
  }

  function refresh() {
    if (statusProc.running)
      return
    root.loading = true
    statusProc.command = [
      root.scriptPath,
      "--channel", root.selectedChannel,
      "--running-color", root.runningColor,
      "--stalled-color", root.stalledColor,
      "--close-color", root.closeColor,
      "--launched-color", root.launchedColor,
      "--running-icon", root.runningIcon,
      "--stalled-icon", root.stalledIcon,
      "--close-icon", root.closeIcon,
      "--launched-icon", root.launchedIcon,
      "--close-threshold", String(root.closeThreshold)
    ]
    statusProc.running = true
  }

  function openHydra() {
    if (!root.statusUrl)
      return
    Quickshell.execDetached(["xdg-open", root.statusUrl])
  }

  function openDocumentation() {
    Quickshell.execDetached(["xdg-open", Qt.resolvedUrl("README.md").toString()])
  }
}

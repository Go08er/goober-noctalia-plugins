import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root

  property var pluginApi: null
  property var cfg: pluginApi?.pluginSettings || ({})
  property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

  property int editRefreshIntervalMinutes: Math.max(1, cfg.refreshIntervalMinutes ?? defaults.refreshIntervalMinutes ?? 60)
  property string editChannelPreset: cfg.channelPreset ?? defaults.channelPreset ?? "nixos-unstable"
  property string editCustomChannel: cfg.customChannel ?? defaults.customChannel ?? ""
  property string editRunningColor: cfg.runningColor ?? defaults.runningColor ?? "secondary"
  property string editStalledColor: cfg.stalledColor ?? defaults.stalledColor ?? "error"
  property string editCloseColor: cfg.closeColor ?? defaults.closeColor ?? "tertiary"
  property string editLaunchedColor: cfg.launchedColor ?? defaults.launchedColor ?? "primary"
  property string editRunningIcon: cfg.runningIcon ?? defaults.runningIcon ?? "server-bolt"
  property string editStalledIcon: cfg.stalledIcon ?? defaults.stalledIcon ?? "server-off"
  property string editCloseIcon: cfg.closeIcon ?? defaults.closeIcon ?? "server-spark"
  property string editLaunchedIcon: cfg.launchedIcon ?? defaults.launchedIcon ?? "rocket"
  property int editCloseThreshold: Math.max(1, Math.min(100, cfg.closeThreshold ?? defaults.closeThreshold ?? 90))
  property string editPercentDisplayMode: {
    const mode = cfg.percentDisplayMode ?? defaults.percentDisplayMode ?? "onhover"
    return mode === "auto" ? "onhover" : mode
  }

  readonly property var channelModel: [
    { "key": "nixos-unstable", "name": pluginApi?.tr("channels.nixosUnstable") },
    { "key": "nixos-unstable-small", "name": pluginApi?.tr("channels.nixosUnstableSmall") },
    { "key": "nixos-stable", "name": pluginApi?.tr("channels.nixosStable") },
    { "key": "nixos-stable-small", "name": pluginApi?.tr("channels.nixosStableSmall") },
    { "key": "nixpkgs-unstable", "name": pluginApi?.tr("channels.nixpkgsUnstable") },
    { "key": "custom", "name": pluginApi?.tr("channels.custom") }
  ]

  readonly property var percentDisplayModeModel: [
    { "key": "onhover", "name": pluginApi?.tr("percent.onHover") },
    { "key": "alwaysShow", "name": pluginApi?.tr("percent.alwaysShow") },
    { "key": "alwaysHide", "name": pluginApi?.tr("percent.iconOnly") }
  ]

  spacing: Style.marginM

  RowLayout {
    Layout.fillWidth: true

    NLabel {
      Layout.fillWidth: true
      label: pluginApi?.tr("settings.title")
      description: pluginApi?.tr("settings.titleDescription")
    }

    NButton {
      text: pluginApi?.tr("settings.documentation")
      icon: "external-link"
      onClicked: root.openDocumentation()
    }
  }

  NDivider {
    Layout.fillWidth: true
  }

  NLabel {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.source.label")
    description: pluginApi?.tr("settings.source.description")
  }

  NComboBox {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.channel.label")
    description: pluginApi?.tr("settings.channel.description")
    model: root.channelModel
    currentKey: root.editChannelPreset
    onSelected: key => root.editChannelPreset = key
  }

  NTextInput {
    visible: root.editChannelPreset === "custom"
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.customChannel.label")
    description: pluginApi?.tr("settings.customChannel.description")
    placeholderText: "nixos-unstable"
    text: root.editCustomChannel
    onTextChanged: root.editCustomChannel = text.trim()
  }

  NSpinBox {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.refresh.label")
    description: pluginApi?.tr("settings.refresh.description")
    from: 1
    to: 1440
    stepSize: 1
    value: root.editRefreshIntervalMinutes
    onValueChanged: if (value !== root.editRefreshIntervalMinutes) root.editRefreshIntervalMinutes = value
  }

  NComboBox {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.percent.label")
    description: pluginApi?.tr("settings.percent.description")
    model: root.percentDisplayModeModel
    currentKey: root.editPercentDisplayMode
    onSelected: key => root.editPercentDisplayMode = key
  }

  NDivider {
    Layout.fillWidth: true
  }

  NLabel {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.colors.label")
    description: pluginApi?.tr("settings.colors.description")
  }

  NColorChoice {
    label: pluginApi?.tr("settings.states.running")
    currentKey: root.editRunningColor
    onSelected: key => root.editRunningColor = key
    defaultValue: "secondary"
  }

  NColorChoice {
    label: pluginApi?.tr("settings.states.stalled")
    description: pluginApi?.tr("settings.stalled.description")
    currentKey: root.editStalledColor
    onSelected: key => root.editStalledColor = key
    defaultValue: "error"
  }

  NColorChoice {
    label: pluginApi?.tr("settings.states.close")
    description: pluginApi?.tr("settings.close.description")
    currentKey: root.editCloseColor
    onSelected: key => root.editCloseColor = key
    defaultValue: "tertiary"
  }

  NColorChoice {
    label: pluginApi?.tr("settings.states.launched")
    description: pluginApi?.tr("settings.launched.description")
    currentKey: root.editLaunchedColor
    onSelected: key => root.editLaunchedColor = key
    defaultValue: "primary"
  }

  NSpinBox {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.closeThreshold.label")
    description: pluginApi?.tr("settings.closeThreshold.description")
    from: 1
    to: 100
    stepSize: 1
    value: root.editCloseThreshold
    onValueChanged: if (value !== root.editCloseThreshold) root.editCloseThreshold = value
  }

  NDivider {
    Layout.fillWidth: true
  }

  NLabel {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.icons.label")
    description: pluginApi?.tr("settings.icons.description")
  }

  RowLayout {
    Layout.fillWidth: true

    NLabel {
      Layout.fillWidth: true
      label: pluginApi?.tr("settings.icons.running")
      description: root.editRunningIcon || "server-bolt"
    }

    NIcon {
      Layout.alignment: Qt.AlignVCenter
      icon: root.editRunningIcon || "server-bolt"
      pointSize: Style.fontSizeXL
    }

    NButton {
      text: pluginApi?.tr("settings.icons.browse")
      icon: "search"
      onClicked: runningIconPicker.open()
    }
  }

  RowLayout {
    Layout.fillWidth: true

    NLabel {
      Layout.fillWidth: true
      label: pluginApi?.tr("settings.icons.launched")
      description: root.editLaunchedIcon || "rocket"
    }

    NIcon {
      Layout.alignment: Qt.AlignVCenter
      icon: root.editLaunchedIcon || "rocket"
      pointSize: Style.fontSizeXL
    }

    NButton {
      text: pluginApi?.tr("settings.icons.browse")
      icon: "search"
      onClicked: launchedIconPicker.open()
    }
  }

  RowLayout {
    Layout.fillWidth: true

    NLabel {
      Layout.fillWidth: true
      label: pluginApi?.tr("settings.icons.stalled")
      description: root.editStalledIcon || "server-off"
    }

    NIcon {
      Layout.alignment: Qt.AlignVCenter
      icon: root.editStalledIcon || "server-off"
      pointSize: Style.fontSizeXL
    }

    NButton {
      text: pluginApi?.tr("settings.icons.browse")
      icon: "search"
      onClicked: stalledIconPicker.open()
    }
  }

  RowLayout {
    Layout.fillWidth: true

    NLabel {
      Layout.fillWidth: true
      label: pluginApi?.tr("settings.icons.close")
      description: root.editCloseIcon || "server-spark"
    }

    NIcon {
      Layout.alignment: Qt.AlignVCenter
      icon: root.editCloseIcon || "server-spark"
      pointSize: Style.fontSizeXL
    }

    NButton {
      text: pluginApi?.tr("settings.icons.browse")
      icon: "search"
      onClicked: closeIconPicker.open()
    }
  }

  NIconPicker {
    id: runningIconPicker
    initialIcon: root.editRunningIcon || "server-bolt"
    onIconSelected: iconName => root.editRunningIcon = iconName
  }

  NIconPicker {
    id: stalledIconPicker
    initialIcon: root.editStalledIcon || "server-off"
    onIconSelected: iconName => root.editStalledIcon = iconName
  }

  NIconPicker {
    id: closeIconPicker
    initialIcon: root.editCloseIcon || "server-spark"
    onIconSelected: iconName => root.editCloseIcon = iconName
  }

  NIconPicker {
    id: launchedIconPicker
    initialIcon: root.editLaunchedIcon || "rocket"
    onIconSelected: iconName => root.editLaunchedIcon = iconName
  }

  function saveSettings() {
    if (!pluginApi) {
      Logger.e("HydraUpdateExaminer", "Cannot save settings: pluginApi is null")
      return
    }

    pluginApi.pluginSettings.refreshIntervalMinutes = Math.max(1, root.editRefreshIntervalMinutes)
    pluginApi.pluginSettings.channelPreset = root.editChannelPreset
    pluginApi.pluginSettings.customChannel = root.editCustomChannel
    pluginApi.pluginSettings.runningColor = root.editRunningColor
    pluginApi.pluginSettings.stalledColor = root.editStalledColor
    pluginApi.pluginSettings.closeColor = root.editCloseColor
    pluginApi.pluginSettings.launchedColor = root.editLaunchedColor
    pluginApi.pluginSettings.runningIcon = root.editRunningIcon || "server-bolt"
    pluginApi.pluginSettings.stalledIcon = root.editStalledIcon || "server-off"
    pluginApi.pluginSettings.closeIcon = root.editCloseIcon || "server-spark"
    pluginApi.pluginSettings.launchedIcon = root.editLaunchedIcon || "rocket"
    pluginApi.pluginSettings.closeThreshold = Math.max(1, Math.min(100, root.editCloseThreshold))
    pluginApi.pluginSettings.percentDisplayMode =
      root.editPercentDisplayMode === "alwaysShow" || root.editPercentDisplayMode === "alwaysHide"
        ? root.editPercentDisplayMode
        : "onhover"
    pluginApi.saveSettings()
    pluginApi.mainInstance?.refresh?.()
  }

  function openDocumentation() {
    const docsUrl = Qt.resolvedUrl("README.md").toString()
    Quickshell.execDetached(["xdg-open", docsUrl])
  }
}

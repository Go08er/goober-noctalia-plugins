import QtQuick
import Quickshell
import qs.Commons
import qs.Modules.Bar.Extras
import qs.Services.UI
import qs.Widgets

Item {
  id: root

  property var pluginApi: null
  property ShellScreen screen
  property string widgetId: ""
  property string section: ""
  property int sectionWidgetIndex: -1
  property int sectionWidgetsCount: 0

  readonly property var main: pluginApi?.mainInstance ?? ({})
  readonly property var cfg: pluginApi?.pluginSettings || ({})
  readonly property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})
  readonly property string percentDisplayMode: {
    const mode = cfg.percentDisplayMode ?? defaults.percentDisplayMode ?? "onhover"
    return mode === "auto" ? "onhover" : mode
  }

  implicitWidth: pill.width
  implicitHeight: pill.height

  NPopupContextMenu {
    id: contextMenu
    screen: root.screen

    model: [
      {
        "label": pluginApi?.tr("menu.refresh"),
        "action": "refresh",
        "icon": "refresh"
      },
      {
        "label": pluginApi?.tr("menu.openHydra"),
        "action": "open",
        "icon": "external-link"
      },
      {
        "label": pluginApi?.tr("menu.settings"),
        "action": "settings",
        "icon": "settings"
      },
      {
        "label": pluginApi?.tr("menu.documentation"),
        "action": "docs",
        "icon": "external-link"
      }
    ]

    onTriggered: (action) => {
      contextMenu.close()
      PanelService.closeContextMenu(root.screen)

      if (action === "refresh")
        main.refresh?.()
      else if (action === "open")
        main.openHydra?.()
      else if (action === "settings" && pluginApi?.manifest)
        BarService.openPluginSettings(root.screen, pluginApi.manifest)
      else if (action === "docs")
        main.openDocumentation?.()
    }
  }

  BarPill {
    id: pill

    screen: root.screen
    oppositeDirection: BarService.getPillDirection(root)
    autoHide: false
    icon: main.loading ? "reload" : (main.statusIcon ?? "server")
    text: main.loading && !(main.statusText ?? "") ? "..." : (main.statusText ?? "HYD")
    tooltipText: main.statusTooltip ?? pluginApi?.tr("widget.unavailable")
    customIconColor: Color.resolveColorKeyOptional(main.statusIconColor ?? "none")
    customTextColor: Color.resolveColorKeyOptional(main.statusTextColor ?? "none")
    forceOpen: root.percentDisplayMode === "alwaysShow"
    forceClose: root.percentDisplayMode === "alwaysHide"

    onClicked: main.refresh?.()
    onRightClicked: PanelService.showContextMenu(contextMenu, pill, screen)
  }
}

{
  config,
  pkgs,
  theme,
  ...
}: let
  inherit (builtins) toString;
  # inherit
  # (config.home-manager.users.${username}.wayland.windowManager.hyprland.settings.general)
  # gaps_out
  # ;
  gaps_out = theme.windowManager.gapsSize * 2;
  inherit (config.kkts.hardware) monitors;
  inherit (config.kkts.system) username;
  inherit (config.stylix.base16Scheme) base00 base02 base07 base0E;
  monitor = monitors.monitors.${monitors.primaryMonitor};
in {
  imports = [./scripts.nix];
  home-manager.users.${username} = {
    home.packages = [pkgs.eww];
    xdg.configFile = {
      "eww/theme.scss" = {
        text = ''
          $foreground: #${base07};
          $background: #${base00};
          $border: #${base02};
          $accent: #${base0E};
        '';
      };
      "eww/windows.yuck".text =
        # yuck
        ''
          (defwindow statusbar
            :stacking "fg"
            :exclusive true
            :geometry (geometry
              :x "${toString gaps_out}px"
              :height "${toString (monitor.resolution.h - gaps_out * 2)}px"
              :anchor "left center")
            (centerbox
              :orientation "vertical"
              (box
                :valign "start"
                :space-evenly false
                :spacing 8
                :orientation "vertical"
                (workspaces))
              (box
                :valign "center"
                :space-evenly false
                :spacing 8
                :orientation "vertical"
                (clock))
              (box
                :valign "end"
                :space-evenly false
                :spacing 8
                :orientation "vertical"
                (notifications)
                (wlp_status)
                (enp_status)
                (hci_status))))

          (defvar fuckjson "[\"test1\", \"test2\", \"test3\", \"test4\"]")
          (defvar fuckeww false)
          (defwindow notifications
            :stacking "fg"
            :geometry (geometry
              :y "${toString (gaps_out * 2)}px"
              :height "10%"
              :width "20%"
              :anchor "top center")
            (box
              :valign "top"
              :space-evenly false
              :spacing 8
              :orientation "vertical"
              (for entry in fuckjson
                (notification
                  :title "Test Notification"
                  :text entry
                  :rev { entry != "test4" ? true : fuckeww }))))

          (defwidget notification [title text rev]
            (revealer
              :transition "slidedown"
              :reveal rev
              :duration "150ms"
              (box
                :class "notification"
                :valign "center"
                :space-evenly false
                :spacing 8
                :orientation "vertical"
                (label :text title)
                (label :text text))))
        '';
      "eww/eww.scss".text =
        # css
        ''
          @use "theme" as *;

          * {all: unset;}

          .statusbar, .notification {
            background-color: $background;
            border: 2px solid $border;
            color: $foreground;
            font-family: "DM Mono Medium", "Symbols Nerd Font Mono";
            padding: 6px 4px;
          }

        '';
      "eww/eww.yuck".text =
        # yuck
        ''
          (include "windows.yuck")

          (deflisten active_workspace `~/.config/eww/scripts/active_workspace`)
          (defwidget workspaces []
            (box
              :spacing 4
              :orientation "vertical"
              (label :text { active_workspace == 1 ? "" : "" })
              (label :text { active_workspace == 2 ? "" : "" })
              (label :text { active_workspace == 3 ? "" : "" })
              (label :text { active_workspace == 4 ? "" : "" })
              (label :text { active_workspace == 5 ? "" : "" })
              (label :text { active_workspace == 6 ? "" : "" })
              (label :text { active_workspace == 7 ? "" : "" })
              (label :text { active_workspace == 8 ? "" : "" })))

          (defvar do_not_disturb false) ; TODO
          (defvar unread_notification false) ; TODO
          (defwidget notifications []
            (label :text { do_not_disturb == true ? "󱏨" :
              unread_notification == true ? "󰅸" : "󰂜" }))

          (deflisten wlp_up :initial false `~/.config/eww/scripts/wlp_up`)
          (deflisten wlp_rssi :initial 0 `~/.config/eww/scripts/wlp_rssi`)
          (defwidget wlp_status []
            (label :text { !wlp_up ? "󰤮" :
              wlp_rssi < -80 ? "󰤯" :
                wlp_rssi < -70 ? "󰤟" :
                  wlp_rssi < -60 ? "󰤢" :
                    wlp_rssi < -50 ? "󰤥" : "󰤨" }))

          (deflisten enp_up :initial false `~/.config/eww/scripts/enp_up`)
          (defwidget enp_status []
            (label :text { enp_up ? "󰈁" : "󰈂" }))

          (deflisten hci_up :initial false `~/.config/eww/scripts/hci_up`)
          (defwidget hci_status []
            (label :text { hci_up ? "󰂯" : "󰂲" }))

          (defwidget clock []
            (box
              :orientation "vertical"
              (label :text { formattime(EWW_TIME, "%H") })
              (label :text { formattime(EWW_TIME, "%M") })
              (label :text { formattime(EWW_TIME, "%S") })))
        '';
    };
  };
}

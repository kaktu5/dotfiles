{
  config,
  pkgs,
  ...
}: let
  inherit (builtins) toString;
  inherit
    (config.home-manager.users.${username}.wayland.windowManager.hyprland.settings.general)
    gaps_out
    ;
  inherit (config.kkts.hardware) monitors;
  inherit (config.kkts.system) username;
  inherit (config.stylix.base16Scheme) base00 base02 base07 base0E;
  monitor = monitors.monitors.${monitors.primaryMonitor};
in {
  imports = [./scripts.nix];
  home-manager.users.${username} = {
    home.packages = [pkgs.eww];
    xdg.configFile = {
      "eww" = {
        recursive = true;
        source = ../../../resources/configs/eww;
      };
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
    };
  };
}

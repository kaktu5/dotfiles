{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.system) username;
  inherit (lib) getExe;
  awk = getExe pkgs.gawk;
  dash = getExe pkgs.dash;
  hcitool = "${pkgs.bluez}/bin/hcitool";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  jq = getExe pkgs.jq;
  socat = getExe pkgs.socat;
  stdbuf = "${pkgs.coreutils}/bin/stdbuf";
in {
  home-manager.users.${username} = {
    xdg.configFile = {
      "eww/scripts/active_workspace" = {
        executable = true;
        text =
          # bash
          ''
            #!${dash}
            ${hyprctl} monitors -j | ${jq} '.[] | select(.focused) | .activeWorkspace.id'
            ${socat} -u "/run/user/`id -u`/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - \
              | ${stdbuf} -o0 \
              ${awk} -F '>>|,' -e '/^workspace>>/ {print $2}' -e '/^focusedmon>>/ {print $3}'
          '';
      };
      "eww/scripts/enp_up" = {
        executable = true;
        text = ''
          #!${dash}
          ENP_DEVICE='enp5s0'
          PREV_UP='''
          while true; do
            ENP_UP=`${awk} '{print ($1 == 1 ? "true" : "false")}' \
              "/sys/class/net/$ENP_DEVICE/carrier"`
            [ "$ENP_UP" != "$PREV_UP" ] && PREV_UP="$ENP_UP" && echo "$ENP_UP"
            sleep 2
          done
        '';
      };
      "eww/scripts/hci_up" = {
        executable = true;
        text = ''
          #!${dash}
          HCI_DEVICE='hci0'
          PREV_UP='''
          while true; do
            HCI_UP=`${hcitool} -i "$HCI_DEVICE" con \
              | ${awk} 'NF > 1 {up=1} END {print (up ? "true" : "false")}'`
            [ "$HCI_UP" != "$PREV_UP" ] && PREV_UP="$HCI_UP" && echo "$HCI_UP"
            sleep 2
          done
        '';
      };
      "eww/scripts/wlp_up" = {
        executable = true;
        text = ''
          #!${dash}
          WLP_DEVICE='wlp4s0'
          PREV_UP='''
          while true; do
            WLP_UP=`${awk} '{print ($1 == 1 ? "true" : "false")}' \
              "/sys/class/net/$WLP_DEVICE/carrier"`
            [ "$WLP_UP" != "$PREV_UP" ] && PREV_UP="$WLP_UP" && echo "$WLP_UP"
            sleep 2
          done
        '';
      };
      "eww/scripts/wlp_rssi" = {
        executable = true;
        text = ''
          #!${dash}
          WLP_DEVICE='wlp4s0'
          PREV_RSSI='''
          while true; do
            WLP_RSSI=`${awk} '$1 == "'"$WLP_DEVICE"':" {print substr($4, 1, length($4) - 1)}' \
              '/proc/net/wireless'`
            [ "$WLP_RSSI" != "$PREV_RSSI" ] && PREV_RSSI="$WLP_RSSI" && echo "$WLP_RSSI"
            sleep 5
          done
        '';
      };
    };
  };
}

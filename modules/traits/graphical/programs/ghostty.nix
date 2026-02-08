{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.theme.colors) hex;
  inherit (config.kkts.theme.fonts.fonts) monospace;
  inherit (config.kkts.theme.fonts.sizes) pt;
  inherit (lib.generators) toKeyValue;
  inherit (lib.kkts.systemd) mkGraphicalTargetService;
  inherit (lib.lists) range;
  inherit (lib.meta) getExe;
  inherit (pkgs) ghostty;
in {
  users.users.${userName}.packages = [ghostty];

  hjem.users.${userName} = {
    systemd.services.ghostty = mkGraphicalTargetService {
      aliases = ["app-com.mitchellh.ghostty.service"];
      after = ["dbus.socket"];
      requires = ["dbus.socket"];

      enableDefaultPath = false;

      serviceConfig = {
        Type = "notify-reload";
        ReloadSignal = "SIGUSR2";
        BusName = "com.mitchellh.ghostty";
        ExecStart = "${getExe ghostty} --initial-window=false";
      };
    };

    xdg.config.files."ghostty/config.ghostty" = {
      generator = toKeyValue {listsAsDuplicateKeys = true;};
      value = {
        font-family = monospace.name;
        font-size = pt.medium;

        background = hex.bg0;
        foreground = hex.fg0;

        selection-clear-on-copy = true;

        palette = range 0 15 |> map (i: "${i}=${hex."${i}"}");

        cursor-color = "cell-foreground";

        window-padding-x = 4;
        window-padding-y = 4;

        resize-overlay = "never";

        right-click-action = "ignore";

        confirm-close-surface = false;

        quit-after-last-window-closed = false;

        shell-integration = "none";

        bell-features = ["no-attention" "no-title"];

        app-notifications = ["no-clipboard-copy" "no-config-reload"];

        gtk-single-instance = true;
      };
    };
  };
}

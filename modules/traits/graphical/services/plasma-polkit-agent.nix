{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.hjem.users.${userName}.environment) sessionVariables;
  inherit (config.kkts.meta) userName;
  inherit (lib.generators) toINI;
  inherit (lib.kkts.systemd) mkGraphicalTargetService;
  inherit (pkgs.kdePackages) polkit-kde-agent-1;
in {
  hjem.users.${userName} = {
    systemd.services.plasma-polkit-agent = mkGraphicalTargetService {
      environment = {
        inherit (sessionVariables) QT_PLUGIN_PATH QT_QPA_PLATFORMTHEME;
      };

      serviceConfig = {
        ExecStart = polkit-kde-agent-1 + /libexec/polkit-kde-authentication-agent-1;
        BusName = "org.kde.polkit-kde-authentication-agent-1";
        Slice = "background.slice";
      };
    };

    xdg.data.files."knotifications6/polkit-kde-authentication-agent-1.notifyrc" = {
      generator = toINI {};
      value."Event/authenticate".Action = "None";
    };
  };
}

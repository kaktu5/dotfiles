{
  config,
  pkgs,
  ...
}: let
  inherit (config.hjem.users.${userName}.environment) sessionVariables;
  inherit (config.kkts.meta) userName;
  inherit (pkgs.kdePackages) polkit-kde-agent-1;
in {
  hjem.users.${userName}.systemd.services.plasma-polkit-agent = {
    after = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];

    environment = {
      inherit (sessionVariables) QT_PLUGIN_PATH QT_QPA_PLATFORMTHEME;
    };

    serviceConfig = {
      ExecStart = polkit-kde-agent-1 + /libexec/polkit-kde-authentication-agent-1;
      BusName = "org.kde.polkit-kde-authentication-agent-1";
      Slice = "background.slice";
      Restart = "on-failure";
    };
  };
}

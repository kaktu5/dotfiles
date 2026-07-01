{config, ...}: let
  inherit (config.kkts.meta) userName;
in {
  hjem.users.${userName}.environment.sessionVariables.GTK_THEME = "Adwaita:dark";
}

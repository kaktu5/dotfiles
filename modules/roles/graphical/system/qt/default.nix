{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.theme.fonts.fonts) monospace serif;
  inherit (config.kkts.theme.fonts.sizes) pt;
  inherit (lib.generators) toJSON;
  inherit (pkgs) qtengine;
  inherit (pkgs.kdePackages) breeze;

  colorScheme = import ./colorscheme.nix {inherit config lib pkgs;};
in {
  users.users.${userName}.packages = [breeze qtengine];

  hjem.users.${userName} = {
    environment.sessionVariables.QT_QPA_PLATFORMTHEME = "qtengine";

    xdg.config.files."qtengine/config.json" = {
      generator = toJSON {};
      value = {
        theme = {
          inherit colorScheme;
          iconTheme = "breeze-dark";
          style = "breeze";

          font = {
            family = serif.name;
            size = pt.medium;
            weight = -1;
          };

          fontFixed = {
            family = monospace.name;
            size = pt.medium;
            weight = -1;
          };
        };

        misc = {
          singleClickActivate = false;
          menusHaveIcons = true;
          shortcutsForContextMenus = true;
        };
      };
    };
  };
}

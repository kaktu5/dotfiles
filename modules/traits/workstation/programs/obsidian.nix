{
  config,
  inputs',
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.theme.fonts.fonts) monospace sansSerif;
  inherit (config.users.users.${userName}) home;
  inherit (inputs'.obsidian-bases-tasks.packages) obsidian-bases-tasks;
  inherit (lib.generators) toJSON;
  inherit (pkgs) linkFarm obsidian;

  generator = toJSON {};

  vault = "documents/obsidian";
in {
  persistence.users.${userName}.directories = [".config/obsidian"];

  users.users.${userName}.packages = [obsidian];

  hjem.users.${userName} = {
    xdg.config.files."obsidian/obsidian.json" = {
      inherit generator;
      value.vaults."0000000000000000" = {
        path = "${home}/${vault}";
        ts = 0;
        open = true;
      };
    };

    files = {
      "${vault}/.obsidian/app.json" = {
        inherit generator;
        value = {
          userIgnorePlugins = false;
          vimMode = true;
        };
      };

      "${vault}/.obsidian/appearance.json" = {
        inherit generator;
        value = {
          interfaceFontFamily = sansSerif.name;
          monospaceFontFamily = monospace.name;
          textFontFamily = monospace.name;
        };
      };

      "${vault}/.obsidian/plugins".source =
        [obsidian-bases-tasks]
        |> map (drv: {
          name = drv.pname;
          path = drv;
        })
        |> linkFarm "obsidian-plugins";
    };
  };
}

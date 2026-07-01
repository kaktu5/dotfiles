{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.users.users.${userName}) home;
  inherit (lib.generators) toJSON;
  inherit (pkgs) obsidian;

  path = "${home}/documents/obsidian";
in {
  persistence.users.${userName}.directories = [".config/obsidian"];

  users.users.${userName}.packages = [obsidian];

  hjem.users.${userName}.xdg.config.files."obsidian/obsidian.json" = {
    generator = toJSON {};
    value.vaults."0000000000000000" = {
      inherit path;
      ts = 0;
      open = true;
    };
  };

  systemd.tmpfiles.rules = ["d ${path} 0755 ${userName} users - -"];
}

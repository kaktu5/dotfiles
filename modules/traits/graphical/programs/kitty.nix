{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.theme.colors) hex';
  inherit (config.kkts.theme.fonts.fonts) monospace;
  inherit (config.kkts.theme.fonts.sizes) pt;
  inherit (lib.attrsets) listToAttrs nameValuePair;
  inherit (lib.generators) mkKeyValueDefault toKeyValue;
  inherit (lib.kkts.systemd) mkGraphicalTargetService;
  inherit (lib.lists) range;
  inherit (lib.meta) getExe;
  inherit (pkgs) kitty;
  inherit (pkgs.writers) writeText;

  kittyConfig =
    writeText "kitty-config"
    <| toKeyValue {
      mkKeyValue = mkKeyValueDefault {} " ";
    } ({
        background = hex'.bg0;
        foreground = hex'.fg0;
      }
      // (range 0 15 |> map (i: nameValuePair "color${i}" hex'."${i}") |> listToAttrs));
in {
  hjem.users.${userName}.systemd.services.kitty = mkGraphicalTargetService {
    enableDefaultPath = false;

    serviceConfig.ExecStart = "${getExe kitty} --config ${kittyConfig} --single-instance --start-as hidden";
  };
}

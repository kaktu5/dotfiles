{
  config,
  lib,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.theme.colors) hex';
  inherit (config.networking) hostName;
  inherit (lib.kkts.dag) entryAnywhere;
  inherit (lib.kkts.strings) replaceVars;
in {
  kkts.programs.nushell.extraEntries.prompt =
    entryAnywhere
    <| replaceVars ./prompt.nu {
      inherit hostName userName;
      inherit (hex') bg0 blue fg0 purple red;
    };
}

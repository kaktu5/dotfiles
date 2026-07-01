{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption;

  cfg = config.kkts.profiles.gaming;
in {
  imports = [
    ./config.nix
    ./steam.nix
  ];

  options.kkts.profiles.gaming = {
    enable = mkEnableOption "gaming profile";
    steam.enable = mkEnableOption "steam";
  };
}

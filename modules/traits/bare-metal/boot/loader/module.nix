{lib, ...}: let
  inherit (lib.modules) mkDefault;
  inherit (lib.options) mkOption;
  inherit (lib.types) enum;
in {
  imports = [./lanzaboote.nix ./limine.nix];

  options.kkts.boot.loader = mkOption {
    type = enum ["lanzaboote" "limine"];
    default = "lanzaboote";
  };

  config.boot.loader.efi.canTouchEfiVariables = mkDefault true;
}

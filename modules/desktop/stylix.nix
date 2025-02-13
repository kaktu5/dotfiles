{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) str;

  mkStrOption = value: mkOption {type = str;} // {default = value;};

  cfg = config.kkts.colors;
in {
  imports = [inputs.stylix.nixosModules.stylix];
  options.kkts.colors = {
    bg0 = mkStrOption "000000"; # ----
    bg1 = mkStrOption "0d0e14"; # ---
    bg2 = mkStrOption "1b1c28"; # --
    bg3 = mkStrOption "292b3d"; # -
    fg0 = mkStrOption "c0caf5"; # ++++
    fg1 = mkStrOption "afb8e0"; # +++
    fg2 = mkStrOption "9fa7cc"; # ++
    fg3 = mkStrOption "8f96b7"; # +

    red = mkStrOption "ee6d85";
    orange = mkStrOption "f6955b";
    yellow = mkStrOption "d7a65f";
    green = mkStrOption "95c561";
    lightblue = mkStrOption "9fbbf3";
    blue = mkStrOption "7199ee";
    purple = mkStrOption "a485dd";
    brown = mkStrOption "773440";

    accent = mkStrOption cfg.purple;
    success = mkStrOption cfg.green;
    warning = mkStrOption cfg.yellow;
    error = mkStrOption cfg.red;

    base00 = mkStrOption cfg.bg0;
    base01 = mkStrOption cfg.bg1;
    base02 = mkStrOption cfg.bg2;
    base03 = mkStrOption cfg.bg3;
    base04 = mkStrOption cfg.fg3;
    base05 = mkStrOption cfg.fg2;
    base06 = mkStrOption cfg.fg1;
    base07 = mkStrOption cfg.fg0;
    base08 = mkStrOption cfg.red;
    base09 = mkStrOption cfg.orange;
    base0A = mkStrOption cfg.yellow;
    base0B = mkStrOption cfg.green;
    base0C = mkStrOption cfg.lightblue;
    base0D = mkStrOption cfg.blue;
    base0E = mkStrOption cfg.purple;
    base0F = mkStrOption cfg.brown;
  };

  config.stylix = {
    enable = true;
    autoEnable = false;
    image = ./.;
    base16Scheme = with cfg; {
      inherit base00;
      inherit base01;
      inherit base02;
      inherit base03;
      inherit base04;
      inherit base05;
      inherit base06;
      inherit base07;
      inherit base08;
      inherit base09;
      inherit base0A;
      inherit base0B;
      inherit base0C;
      inherit base0D;
      inherit base0E;
      inherit base0F;
    };
  };
}

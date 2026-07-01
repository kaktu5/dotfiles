{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (inputs) lanzaboote;
  inherit (lib.lists) singleton;
  inherit (pkgs) sbctl;

  cfg = config.boot.lanzaboote;
in {
  imports = [lanzaboote.nixosModules.default];

  preservation.preserveAt."/persist".directories = singleton {
    directory = cfg.pkiBundle;
    mode = "u=rwx,g=,o=";
  };

  users.users.${userName}.packages = [sbctl];

  boot = {
    loader.efi.canTouchEfiVariables = true;

    lanzaboote = {
      enable = true;

      configurationLimit = 8;

      pkiBundle = "/var/lib/sbctl";

      settings = {
        timeout = 0;
        console-mode = "max";
        editor = false;
      };

      bootCounting.initialTries = 2;

      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };
    };
  };
}

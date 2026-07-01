{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (inputs) lanzaboote;
  inherit (lib.lists) optional singleton;
  inherit (pkgs) sbctl tpm2-tools;

  cfg = config.boot.lanzaboote;
in {
  imports = [lanzaboote.nixosModules.default];

  persistence = {
    directories =
      singleton {
        target = cfg.pkiBundle;
        mode = "700";
      }
      ++ optional cfg.measuredBoot.enable {
        target = cfg.measuredBoot.pcrlockDirectory;
        mode = "700";
      };

    files = optional cfg.measuredBoot.enable {
      target = cfg.measuredBoot.pcrlockPolicy;
      mode = "600";
    };
  };

  users.users.${userName}.packages = [sbctl tpm2-tools];

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

      measuredBoot.enable = true;
    };
  };
}

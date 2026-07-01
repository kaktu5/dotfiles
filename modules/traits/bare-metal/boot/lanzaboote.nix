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

  preservation.preserveAt."/persist" = {
    directories =
      singleton {
        directory = cfg.pkiBundle;
        mode = "u=rwx,g=,o=";
      }
      ++ optional cfg.measuredBoot.enable {
        directory = cfg.measuredBoot.pcrlockDirectory;
        mode = "u=rwx,g=,o=";
      };

    files = optional cfg.measuredBoot.enable {
      file = cfg.measuredBoot.pcrlockPolicy;
      mode = "u=rw,g=,o=";
      configureParent = true;
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

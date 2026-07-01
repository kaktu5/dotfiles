{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (inputs) lanzaboote;
  inherit (lib.lists) optionals singleton;
  inherit (lib.modules) mkIf;
  inherit (pkgs) sbctl tpm2-tools;

  enable = config.kkts.boot.loader == "lanzaboote";

  cfg = config.boot.lanzaboote;
in {
  imports = [lanzaboote.nixosModules.default];

  persistence = mkIf enable {
    directories =
      singleton {
        target = cfg.pkiBundle;
        mode = "700";
      }
      ++ optionals cfg.measuredBoot.enable [
        {
          target = cfg.measuredBoot.pcrlockDirectory;
          mode = "700";
        }
        {
          target = dirOf cfg.measuredBoot.pcrlockPolicy;
          mode = "700";
        }
      ];
  };

  users.users.${userName}.packages = optionals enable [sbctl tpm2-tools];

  boot.lanzaboote = {
    inherit enable;

    configurationLimit = 4;

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

    measuredBoot = {
      enable = true;

      # systemd-pcrlock fails if the file is persisted directly (it initializes as empty), so we persist the parent
      # directory instead
      pcrlockPolicy = "/var/lib/systemd/pcrlock/policy.json";
    };
  };
}

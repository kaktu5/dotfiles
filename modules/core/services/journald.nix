{
  config,
  lib,
  ...
}: let
  inherit (config.kkts.persistence) store;
  inherit (lib.modules) mkDefault mkIf;

  isPersistent = config.services.journald.settings.Journal.Storage == "persistent";
in {
  fileSystems."/var/log/journal" = mkIf isPersistent {
    device = "${store}/var/log/journal";
    fsType = "none";
    options = ["bind"];
  };

  services.journald.settings.Journal = {
    Storage = mkDefault "persistent";
    MaxRetentionSec = "2week";
  };
}

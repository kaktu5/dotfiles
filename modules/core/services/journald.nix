{
  config,
  lib,
  ...
}: let
  inherit (lib.lists) optional;
  inherit (lib.modules) mkDefault;
  isPersistent = config.services.journald.settings.Journal.Storage == "persistent";
in {
  persistence.directories = optional isPersistent "/var/log/journal";

  services.journald.settings.Journal = {
    Storage = mkDefault "persistent";
    MaxRetentionSec = "2week";
  };
}

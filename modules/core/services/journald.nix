{
  config,
  lib,
  ...
}: let
  inherit (lib.lists) optional;
  inherit (lib.modules) mkDefault;

  isVolatile = config.services.journald.settings.Journal.Storage == "volatile";
in {
  persistence.directories = optional isVolatile "/var/log/journal";

  services.journald.settings.Journal = {
    Storage = mkDefault "persistent";
    MaxRetentionSec = "2week";
  };
}

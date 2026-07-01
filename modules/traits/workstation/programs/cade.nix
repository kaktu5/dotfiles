{
  config,
  inputs',
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (inputs'.cade.packages) cade;
  inherit (lib.kkts.dag) entryAnywhere;
  inherit (lib.meta) getExe;
  inherit (pkgs) runCommand;
  inherit (pkgs.writers) writeTOML;

  cadeConfig = writeTOML "cade-config" {
    verbosity = "normal";
    long_running_warning_ms = 15 * 1000;
    shell_gc_root_ttl_seconds = 14 * 24 * 60 * 60;
  };

  nushellHook = runCommand "cade-hook-nu" {} "${getExe cade} --config ${cadeConfig} hook nushell > $out";
in {
  persistence.users.${userName}.directories = [".local/state/cade"];

  users.users.${userName}.packages = [cade];

  kkts.programs.nushell.extraEntries.cade = entryAnywhere "source ${nushellHook}";
}

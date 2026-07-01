{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config.hjem.users.${userName}.xdg) state;
  inherit (config.kkts.meta) userName;
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (config.users.users.${userName}) home;
  inherit (inputs.cade.packages.${system}) cade;
  inherit (lib.kkts.dag) entryAnywhere;
  inherit (lib.meta) getExe;
  inherit (lib.strings) removePrefix;
  inherit (pkgs) runCommand;
  inherit (pkgs.writers) writeTOML;

  stripHome = removePrefix "${home}/";

  cadeConfig = writeTOML "cade-config" {
    verbosity = "normal";
    long_running_warning_ms = 15 * 1000;
    shell_gc_root_ttl_seconds = 14 * 24 * 60 * 60;
  };

  nushellHook = runCommand "cade-hook-nu" {} "${getExe cade} --config ${cadeConfig} hook nushell > $out";
in {
  preservation.preserveAt."/persist".users.${userName}.directories = [(stripHome "${state.directory}/cade")];

  users.users.${userName}.packages = [cade];

  kkts.programs.nushell.extraEntries.cade = entryAnywhere "source ${nushellHook}";
}

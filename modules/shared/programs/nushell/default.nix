{
  config,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.programs.nushell) finalConfig;
  inherit (pkgs) nushell;
in {
  imports = [./config.nix];

  preservation.preserveAt."/persist".users.${userName}.files = [".config/nushell/history.sqlite3"];

  environment.shells = [nushell];
  users.users.${userName}.shell = nushell;

  hjem.users.${userName}.xdg.config.files."nushell/config.nu".text = finalConfig;
}

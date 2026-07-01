{
  config,
  pkgs,
  ...
}: let
  inherit (config.hjem.users.${userName}) xdg;
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.programs.nushell) finalConfig;
  inherit (pkgs) nushell;
in {
  imports = [./completions.nix ./config.nix];

  preservation.preserveAt."/persist".users.${userName}.files = [
    "${xdg.config.directory}/nushell/history.sqlite3"
    "${xdg.config.directory}/nushell/history.sqlite3-wal"
  ];

  environment.shells = [nushell];
  users.users.${userName}.shell = nushell;

  hjem.users.${userName}.xdg.config.files."nushell/config.nu".text = finalConfig;
}

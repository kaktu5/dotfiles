{
  config,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (pkgs) nushell;
in {
  imports = [./env.nix];

  environment.shells = [nushell];

  users.users.${userName}.shell = nushell;
}

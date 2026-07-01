{
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (inputs.affinity-nix.overlays.default {} pkgs) affinity-v3;
in {
  persistence.users.${userName}.directories = [".local/share/affinity-v3" ".local/state/affinity-v3"];

  users.users.${userName}.packages = [affinity-v3];
}

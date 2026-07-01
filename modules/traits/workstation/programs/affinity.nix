{
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (inputs.affinity-nix.overlays.default {} pkgs) affinity-v3;
in {
  persistence.users.${userName}.directories = [
    {
      target = ".local/share/affinity-v3";
      method = "symlink";
    }
    {
      target = ".local/state/affinity-v3";
      method = "symlink";
    }
  ];

  users.users.${userName}.packages = [affinity-v3];
}

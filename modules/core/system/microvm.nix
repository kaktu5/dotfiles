{
  config,
  inputs,
  ...
}: let
  inherit (inputs) microvm-nix;

  cfg = config.microvm;
in {
  imports = [microvm-nix.nixosModules.host];

  microvm.host = {
    enable = cfg.vms != {};

    startupTimeout = 2 * 60;

    useNotifySockets = true;
  };
}

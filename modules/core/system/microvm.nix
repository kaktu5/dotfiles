{
  config,
  inputs,
  ...
}: let
  inherit (inputs) microvm;

  cfg = config.microvm;
in {
  imports = [microvm.nixosModules.host];

  microvm.host = {
    enable = cfg.vms != {};

    startupTimeout = 2 * 60;

    useNotifySockets = true;
  };
}

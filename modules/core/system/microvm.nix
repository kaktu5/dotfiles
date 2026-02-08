{
  config,
  inputs,
  ...
}: let
  inherit (inputs.microvm) nixosModules;

  cfg = config.microvm;
in {
  imports = [nixosModules.host];

  microvm.host = {
    enable = cfg != {};

    startupTimeout = 2 * 60;

    useNotifySockets = true;
  };
}

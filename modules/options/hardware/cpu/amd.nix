{
  config,
  lib,
  ...
}: let
  inherit (config.boot.kernelPackages) zenpower;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.kkts.hardware.cpu.amd;
in {
  options.kkts.hardware.cpu.amd.enable = mkEnableOption "amd cpu support";

  config = mkIf cfg.enable {
    hardware.cpu.amd.updateMicrocode = true;

    boot = {
      kernelParams = ["amd_pstate=active"];

      blacklistedKernelModules = ["k10temp"];
      extraModulePackages = [zenpower];
      kernelModules = ["zenpower"];
    };
  };
}

{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;
  cfg = config.kkts.hardware.amd.cpu;
in {
  options.kkts.hardware.amd.cpu.enable = mkEnableOption "amd cpu support";
  config = mkIf cfg.enable {
    hardware.cpu.amd.updateMicrocode = true;
    boot = {
      kernelParams = ["amd_pstate=active"];
      blacklistedKernelModules = ["k10temp"];
      extraModulePackages = [config.boot.kernelPackages.zenpower];
      kernelModules = ["zenpower"];
    };
  };
}

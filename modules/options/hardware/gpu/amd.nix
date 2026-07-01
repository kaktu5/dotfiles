{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.options) mkEnableOption;
  inherit (pkgs) symlinkJoin;
  inherit (pkgs.rocmPackages) clr hipblas rocblas;

  cfg = config.kkts.hardware.gpu.amd;
in {
  options.kkts.hardware.gpu.amd = {
    enable = mkEnableOption "amd gpu support";

    enable32Bit = mkEnableOption "enable 32-bit support";

    enableRocmSupport = mkEnableOption "enable ROCm support" // {default = true;};
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.xserver.videoDrivers = ["amdgpu"];

      hardware = {
        amdgpu.initrd.enable = true;
        graphics.enable = true;
      };
    }

    (mkIf cfg.enable32Bit {
      hardware.graphics = {inherit (cfg) enable32Bit;};
    })

    (mkIf cfg.enableRocmSupport {
      nixpkgs.config.rocmSupport = true;

      hardware.amdgpu.opencl.enable = true;

      systemd.tmpfiles.rules = let
        rocmEnv = symlinkJoin {
          name = "rocm-env";
          paths = [clr hipblas rocblas];
        };
      in ["L+ /opt/rocm - - - - ${rocmEnv}"];
    })
  ]);
}

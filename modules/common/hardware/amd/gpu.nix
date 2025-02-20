{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;
  cfg = config.kkts.hardware.amd.gpu;
in {
  options.kkts.hardware.amd.gpu.enable = mkEnableOption "amd gpu support";
  config = mkIf cfg.enable {
    boot.initrd.kernelModules = ["amdgpu"];
    services.xserver.videoDrivers = ["amdgpu"];
    environment.sessionVariables.AMD_VULKAN_ICD = "RADV";
    hardware = {
      amdgpu = {
        initrd.enable = true;
        opencl.enable = true;
      };
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          libdrm
          libva
          libva-vdpau-driver
          libvdpau-va-gl
          mesa
          rocmPackages.clr.icd
        ];
        extraPackages32 = with pkgs.driversi686Linux; [libvdpau-va-gl mesa];
      };
    };
    systemd.tmpfiles.rules = ["L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"];
  };
}

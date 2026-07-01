{
  config,
  lib,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.options) mkEnableOption;

  cfg = config.kkts.hardware.gpu.amd;
in {
  options.kkts.hardware.gpu.amd = {
    enable = mkEnableOption "amd gpu support";

    enable32Bit = mkEnableOption "enable 32-bit support";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      persistence.users.${userName}.directories = [
        ".local/cache/mesa_shader_cache"
        ".local/cache/radv_builtin_shaders"
      ];

      services.xserver.videoDrivers = ["amdgpu"];

      hardware = {
        amdgpu.initrd.enable = true;
        graphics.enable = true;
      };
    }

    (mkIf cfg.enable32Bit {
      hardware.graphics = {inherit (cfg) enable32Bit;};
    })
  ]);
}

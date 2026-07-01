{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault mkIf;

  cfg = config.zramSwap;
in {
  zramSwap = {
    enable = mkDefault true;
    memoryPercent = 100;
    memoryMax = mkDefault 0;
  };

  # https://github.com/pop-os/default-settings/pull/163
  boot.kernel.sysctl = mkIf cfg.enable {
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };
}

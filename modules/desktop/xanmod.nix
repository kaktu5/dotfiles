{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs) xanmod-bore-patch;
in {
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;
    kernelPatches = [
      ({name = "bore-sched";} // {patch = "${xanmod-bore-patch}/0001-bore.patch";})
      ({name = "glitched-cfs";} // {patch = "${xanmod-bore-patch}/0002-glitched-cfs.patch";})
      ({name = "glitched-eevdf";} // {patch = "${xanmod-bore-patch}/0003-glitched-eevdf-additions.patch";})
      ({name = "o3-optimization";} // {patch = "${xanmod-bore-patch}/0004-o3-optimization.patch";})
    ];
  };
}

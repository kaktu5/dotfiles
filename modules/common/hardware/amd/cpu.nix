{config, ...}: {
  hardware.cpu.amd.updateMicrocode = true;
  boot = {
    kernelParams = ["amd_pstate=active"];
    blacklistedKernelModules = ["k10temp"];
    extraModulePackages = [config.boot.kernelPackages.zenpower];
    kernelModules = ["zenpower"];
  };
}

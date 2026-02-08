{
  boot = {
    blacklistedKernelModules = ["pcspkr" "snd_pcsp"];

    extraModprobeConfig = "options zram num_devices=0";
  };
}

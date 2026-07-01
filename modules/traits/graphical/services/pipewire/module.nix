{
  lib,
  ...
}: let
  inherit (lib.generators) toKeyValue;
in {
  imports = [./low-latency.nix];

  services.pipewire = {
    enable = true;

    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
  };
}

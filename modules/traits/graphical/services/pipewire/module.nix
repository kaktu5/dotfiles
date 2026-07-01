{
  config,
  lib,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.users.users.${userName}) home;
  inherit (lib.generators) toKeyValue;
in {
  imports = [./low-latency.nix];

  services.pipewire = {
    enable = true;

    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
  };

  hjem.users.${userName}.xdg.config.files."pulse/client.conf" = {
    generator = toKeyValue {};
    value.cookie-file = "${home}/.config/pulse/cookie";
  };
}

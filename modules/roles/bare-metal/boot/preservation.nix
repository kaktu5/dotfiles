{
  inputs,
  lib,
  ...
}: let
  inherit (inputs) preservation;
  inherit (lib.lists) singleton;
in {
  imports = [preservation.nixosModules.default];

  preservation = {
    enable = true;

    preserveAt."/persist" = {
      commonMountOptions = ["x-gdu.hide" "x-gvfs-hide"];

      directories = [
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
        "/var/lib/systemd/rfkill"
        "/var/lib/systemd/timers"
        "/var/log"
      ];

      files = singleton {
        file = "/var/lib/systemd/random-seed";
        inInitrd = true;
        configureParent = true;
      };
    };
  };
}

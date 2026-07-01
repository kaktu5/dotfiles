{inputs, ...}: let
  inherit (inputs) preservation;
in {
  imports = [preservation.nixosModules.default];

  preservation = {
    enable = true;

    preserveAt."/persist" = {
      commonMountOptions = ["x-gdu.hide" "x-gvfs-hide"];

      directories = [
        "/var/lib/systemd/rfkill"
        "/var/lib/systemd/timers"
        "/var/log"
      ];

      files = [
        {
          file = "/var/lib/systemd/random-seed";
          inInitrd = true;
        }
        "/var/lib/systemd/credential.secret"
      ];
    };
  };
}

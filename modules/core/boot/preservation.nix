{inputs, ...}: let
  inherit (inputs.preservation) nixosModules;
in {
  imports = [nixosModules.default];

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
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
        {
          file = "/var/lib/systemd/random-seed";
          inInitrd = true;
          configureParent = true;
        }
      ];
    };
  };

  systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];
}

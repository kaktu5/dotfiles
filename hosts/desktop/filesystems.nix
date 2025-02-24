{pkgs, ...}: {
  fileSystems."/mnt/lexar" = {
    device = "/dev/disk/by-uuid/5e915111-3162-4d2d-be37-4e8b6e6e6a3f";
    options = ["compress=zstd" "noatime" "nofail"];
  };
  environment.systemPackages = [pkgs.autossh];
  systemd.services."nfs-ssh-tunnel" = {
    enable = true;
    after = ["network.target"];
    wants = ["network-online.target"];
    serviceConfig = {
      Restart = "always";
      RestartSec = "5s";
    };
    script = ''
      autossh -M 0 -N -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes \
        kkts@192.168.1.69 -L 2049:localhost:2049
    '';
  };
}

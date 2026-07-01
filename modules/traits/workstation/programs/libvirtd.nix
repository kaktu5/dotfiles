{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkForce;
  inherit (pkgs) virtiofsd;
in {
  persistence.directories = ["/var/lib/libvirt" "/var/log/libvirt"];

  networking.firewall.trustedInterfaces = ["virbr0"];

  virtualisation = {
    libvirtd = {
      enable = true;

      onBoot = "ignore";
      onShutdown = "shutdown";
      parallelShutdown = 4;

      qemu = {
        runAsRoot = false;

        swtpm.enable = true;

        vhostUserPackages = [virtiofsd];
      };
    };

    spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = true;

  systemd.services.libvirtd.wantedBy = mkForce [];
}

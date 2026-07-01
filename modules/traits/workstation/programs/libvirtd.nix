{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkForce;
  inherit (pkgs) virtiofsd;
in {
  nixpkgs.overlays = singleton (_: prev: {
    libvirt = prev.libvirt.override {enableXen = false;};
  });

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

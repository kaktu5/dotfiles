{pkgs, ...}: let
  inherit (pkgs) virtiofsd;
in {
  persistence.directories = ["/var/lib/libvirt"];

  networking.firewall.trustedInterfaces = ["virbr0"];

  virtualisation.libvirtd = {
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

  programs.virt-manager.enable = true;
}

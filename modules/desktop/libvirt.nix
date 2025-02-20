{config, ...}: let
  inherit (config.kkts.system) username;
in {
  users.users.${username}.extraGroups = ["libvirtd"];
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
}

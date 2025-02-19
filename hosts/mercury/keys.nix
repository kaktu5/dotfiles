{config, ...}: let
  inherit (config.kkts.system) username;
in {
  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgGq/UF0qlgr76WWLTocw+U607Dlu7SYFcrGqstWGGy kkts@desktop"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIWj17DwiR3LomTeZU2WQ07CXfymAnRYqzu99ZvMyaHN u0_a467@localhost"
  ];
}

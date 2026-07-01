{
  config,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.vaultix) secrets;
  inherit (pkgs) openssh;
in {
  vaultix.secrets.id = {
    file = ./id.age;
    owner = userName;
    group = "users";
  };

  users.users.${userName}.packages = [openssh];

  hjem.users.${userName}.files = {
    ".ssh/ssh-key.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICrm08yLyJn1TpTvnEuyyuSp60hD2Z8oOXZgsA/sbHPa";

    ".ssh/config".text = ''
      Host *
        IdentityFile ${secrets.id.path}
        IdentitiesOnly yes
    '';
  };
}

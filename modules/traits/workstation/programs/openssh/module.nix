{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.vaultix) secrets;
  inherit (lib.lists) singleton;
  inherit (pkgs) openssh;
in {
  vaultix.secrets.id = {
    file = ./id.age;
    owner = userName;
    group = "users";
  };

  preservation.preserveAt."/persist".users.${userName}.files = singleton {
    file = ".ssh/known_hosts";
    mode = "600";
  };

  users.users.${userName}.packages = [openssh];

  hjem.users.${userName}.files = {
    ".ssh/ssh-key.pub" = {
      text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICrm08yLyJn1TpTvnEuyyuSp60hD2Z8oOXZgsA/sbHPa";
      type = "copy";
      permissions = "644";
    };

    ".ssh/config" = {
      text = ''
        Host *
          IdentityFile ${secrets.id.path}
          IdentitiesOnly yes
      '';
      type = "copy";
      permissions = "600";
    };
  };
}

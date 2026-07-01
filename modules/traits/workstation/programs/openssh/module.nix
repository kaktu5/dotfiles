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

  pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICrm08yLyJn1TpTvnEuyyuSp60hD2Z8oOXZgsA/sbHPa";
in {
  vaultix.secrets.id = {
    file = ./id.age;
    owner = userName;
    group = "users";
  };

  preservation.preserveAt."/persist".users.${userName}.directories = singleton {
    directory = ".ssh";
    mode = "700";
  };

  users.users.${userName} = {
    packages = [openssh];

    openssh.authorizedKeys.keys = [pub];
  };

  hjem.users.${userName}.files = {
    ".ssh/id.pub" = {
      text = pub;
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

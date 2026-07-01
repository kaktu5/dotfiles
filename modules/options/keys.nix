{lib, ...}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) str;
in {
  options.kkts.keys.users.kaktu5 = mkOption {
    type = str;
    default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICrm08yLyJn1TpTvnEuyyuSp60hD2Z8oOXZgsA/sbHPa";
  };

  config.security.nix-secrets.secrets.kaktu5-key = {
    owner = "kaktu5";
    group = "users";
  };
}

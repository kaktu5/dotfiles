{lib, ...}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) str;
in {
  options.kkts.keys.users.kaktu5 = mkOption {
    type = str;
    default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICrm08yLyJn1TpTvnEuyyuSp60hD2Z8oOXZgsA/sbHPa";
  };

  config.vaultix.secrets.kaktu5-key = {
    file = ./kaktu5-key.age;
    owner = "kaktu5";
    group = "users";
  };
}

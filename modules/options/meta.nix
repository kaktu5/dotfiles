{lib, ...}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) strMatching;
in {
  options.kkts.meta.userName = mkOption {
    type = strMatching "^[a-z_][a-z0-9_-]{1,31}$";
    default = "kaktu5";
    description = "Username for the main user account.";
  };
}

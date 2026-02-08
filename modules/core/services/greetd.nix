{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.users.users.${userName}) shell;
  inherit (lib.meta) getExe';
  inherit (lib.modules) mkDefault;
  inherit (pkgs) greetd;
in {
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session = {
      user = "greeter";
      command = mkDefault "${getExe' greetd "agreety"} --cmd ${shell}";
    };
  };
}

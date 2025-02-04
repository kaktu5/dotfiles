{
  config,
  pkgs,
  ...
}: let
  inherit (config.kkts.system) username;
in {
  home-manager.users.${username} = {
    services.arrpc.enable = true;
    home.packages = [pkgs.vesktop];
  };
}

{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (config.kkts.system) username;
  inherit (lib) mkAliasOptionModule;
in {
  imports = [
    inputs.hjem.nixosModules.default
    (mkAliasOptionModule ["home"] ["hjem" "users" username])
    (mkAliasOptionModule ["user"] ["users" "users" username])
  ];
  home = {
    enable = true;
    directory = "/home/${username}";
  };
}

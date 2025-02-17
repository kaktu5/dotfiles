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
    (mkAliasOptionModule ["user"] ["users" "users" username])
    (mkAliasOptionModule ["home"] ["hjem" "users" username])
  ];
  home = {
    enable = true;
    directory = "/home/${username}";
  };
}

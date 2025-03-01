{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (config.kkts.system) username;
  inherit (config.system) stateVersion;
  inherit (lib) mkAliasOptionModule;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    (mkAliasOptionModule ["homeManager"] ["home-manager" "users" username])
  ];
  programs.fuse.userAllowOther = true;
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    backupFileExtension = "hmbak";
    users.${username} = {
      programs.home-manager.enable = true;
      systemd.user.startServices = "sd-switch";
      home = {
        inherit username;
        inherit stateVersion;
        homeDirectory = "/home/${username}";
      };
    };
  };
}

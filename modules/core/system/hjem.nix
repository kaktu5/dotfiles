{
  config,
  inputs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.users.users.${userName}) home;
  inherit (inputs.hjem) nixosModules;
in {
  imports = [nixosModules.default];

  hjem = {
    clobberByDefault = true;

    users.${userName} = {
      directory = home;
      xdg.cache.directory = home + "/.local/cache";
    };
  };
}

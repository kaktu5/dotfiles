{
  config,
  inputs,
  ...
}: let
  inherit (config.hjem.users.${userName}) directory;
  inherit (config.kkts.meta) userName;
  inherit (inputs.hjem) nixosModules;
in {
  imports = [nixosModules.default];

  hjem = {
    clobberByDefault = true;

    users.${userName}.xdg.cache.directory = directory + "/.local/cache";
  };
}

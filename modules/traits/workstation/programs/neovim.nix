{
  config,
  inputs',
  lib,
  ...
}: let
  inherit (config.hjem.users.${userName}) xdg;
  inherit (config.kkts.meta) userName;
  inherit (inputs'.nf.packages) neovim;
  inherit (lib.meta) getExe;
in {
  preservation.preserveAt."/persist".users.${userName}.directories = [
    "${xdg.cache.directory}/neovim"
    "${xdg.state.directory}/neovim"
  ];

  users.users.${userName}.packages = [neovim];

  hjem.users.${userName}.environment.sessionVariables = {
    EDITOR = getExe neovim;
    VISUAL = getExe neovim;
  };
}

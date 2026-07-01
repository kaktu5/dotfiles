{
  config,
  inputs',
  lib,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (inputs'.nf.packages) neovim;
  inherit (lib.meta) getExe;
in {
  persistence.users.${userName}.directories = [
    ".local/cache/neovim"
    ".local/state/neovim"
  ];

  users.users.${userName}.packages = [neovim];

  hjem.users.${userName}.environment.sessionVariables = {
    EDITOR = getExe neovim;
    VISUAL = getExe neovim;
  };
}

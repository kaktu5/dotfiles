{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (config.hjem.users.${userName}) xdg;
  inherit (config.kkts.meta) userName;
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (inputs.nf.packages.${system}) neovim;
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

{
  config,
  flake,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (lib.meta) getExe;
  inherit (pkgs) callPackage;

  package = callPackage (flake + /components/neovim-wrapper/package.nix) {inherit inputs lib;};
in {
  persistence.users.${userName}.directories = [".local/cache/neovim" ".local/state/neovim"];

  users.users.${userName}.packages = [package];

  hjem.users.${userName} = {
    environment.sessionVariables = {
      EDITOR = getExe package;
      VISUAL = getExe package;
    };

    xdg.mime-apps.default-applications."text/plain" = "nvim.desktop";
  };
}

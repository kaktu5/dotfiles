{
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (config.kkts.system) username;
  inherit (pkgs) system;
  inherit (inputs.nvfdots.packages.${system}) neovim;
in {
  home-manager.users.${username}.home = {
    packages = [neovim];
    sessionVariables = {
      "EDITOR" = "nvim";
      "VISUAL" = "$EDITOR";
    };
  };
}
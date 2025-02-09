{
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (config.kkts.system) username;
  inherit (pkgs) system;
  inherit (inputs.nvf-config.packages.${system}) neovim;
in {
  home-manager.users.${username}.home = {
    packages = [neovim];
    sessionVariables = {
      "EDITOR" = "nvim";
      "VISUAL" = "$EDITOR";
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}: {
  options.kkts.theme = {
    colors = import ./colors.nix {inherit config lib;};
    fonts = import ./fonts.nix {inherit config lib pkgs;};
  };
}

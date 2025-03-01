{
  inputs,
  pkgs,
}:
(inputs.treefmt-nix.lib.evalModule pkgs {
  programs = {
    alejandra.enable = true;
    deadnix.enable = true;
    statix.enable = true;
  };
})
.config
.build

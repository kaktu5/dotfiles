{
  inputs,
  lib,
  pkgs,
  fd,
  neovim-unwrapped,
  ripgrep,
  vimPlugins,
}: let
  inherit (lib.attrsets) filterAttrs listToAttrs mapAttrsToList;
  inherit (lib.fileset) toSource;
  inherit (lib.mnw) wrap;
  inherit (lib.strings) substring;
  inherit (pkgs.vimUtils) buildVimPlugin;
  inherit (vimPlugins) blink-cmp;

  mkPlugin = name: let
    meta = inputs._meta.${name};
    version = meta.version or (substring 0 7 meta.rev);
  in {
    name = meta.repo;
    value = buildVimPlugin {
      pname = name;
      inherit version;
      src = inputs.${name};
      doCheck = false;
    };
  };

  pluginsIn = group:
    inputs._meta
    |> filterAttrs (_: v: (v.group or null) == group)
    |> mapAttrsToList (name: _: mkPlugin name)
    |> listToAttrs;
in
  wrap pkgs {
    neovim = neovim-unwrapped;

    aliases = ["vi" "vim"];

    appName = "neovim";

    initLua = /*lua*/ ''
      require("kkts");
      LZN = require("lz.n");
      LZN.load("lazy");
    '';

    plugins = {
      start = [
        (toSource {
          root = ./neovim;
          fileset = ./neovim;
        })
        (vimPlugins.nvim-treesitter.withPlugins (p: [
          p.bash
          p.lua
          p.nix
          p.rust
          p.typst
        ]))
      ];
      opt = [blink-cmp];

      startAttrs = pluginsIn "neovim-start";
      optAttrs = pluginsIn "neovim-opt";
    };

    extraBinPath = [fd ripgrep];
  }

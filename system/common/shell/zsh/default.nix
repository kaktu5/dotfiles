{
  lib,
  pkgs,
  theme,
  ...
}: let
  inherit (builtins) toFile;
  inherit (lib) concatStringsSep mapAttrsToList pipe;
  inherit (pkgs) makeWrapper symlinkJoin writeShellScriptBin;
  inherit (theme.colors) bg3;
  aliases' = toFile "zsh-aliases" (pipe (import ./aliases.nix {inherit lib;}) [
    (mapAttrsToList (name: value: "alias ${name}=\"${value}\""))
    (concatStringsSep "\n")
  ]);
  highlights' = toFile "zsh-highlights" (pipe (import ./highlights.nix {inherit theme;}) [
    (mapAttrsToList (name: value: "ZSH_HIGHLIGHT_STYLES[${name}]='${value}'"))
    (xs: ["typeset -A ZSH_HIGHLIGHT_STYLES"] ++ xs)
    (xs: xs ++ ["ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#${bg3}'"])
    (concatStringsSep "\n")
  ]);
  config = writeShellScriptBin ".zshrc" (with pkgs; ''
    eval "$(starship init zsh)"
    zvm_after_init_commands+=('eval "$(fzf --zsh)"')

    source ${zsh-defer}/share/zsh-defer/zsh-defer.plugin.zsh

    source ${./config.zsh}

    source ${aliases'}

    source ${highlights'}

    zsh-defer source ${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    zsh-defer source ${zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    zsh-defer source ${zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    zsh-defer source ${zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh
    zsh-defer source ${zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
  '');
  zsh' =
    (symlinkJoin rec {
      name = "zsh";
      paths = with pkgs; [bat duf dust fzf lsd ripgrep zsh];
      nativeBuildInputs = [makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/${name} \
          --set ZDOTDIR ${config}/bin
      '';
    })
    .overrideAttrs (_: {passthru.shellPath = "/bin/zsh";});
in {user.shell = zsh';}

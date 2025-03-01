{
  inputs,
  lib,
  pkgs,
  theme,
  ...
}: let
  inherit (lib) makeBinPath;
  inherit (lib.kkts) mkWrapper;
  inherit (pkgs) writeText;
  inherit (pkgs.tmuxPlugins) fuzzback vim-tmux-navigator yank;
  inherit (theme.colors) bg0 bg3 fg0 purple;
  minimal-tmux-status = inputs.minimal-tmux-status.packages.${pkgs.system}.default;
  fuzzback' = fuzzback.overrideAttrs (_: {
    postPatch = ''
      sed -i '/--color="$4" \\/d' scripts/fuzzback.sh
    '';
    postInstall = ''
      for f in fuzzback.sh preview.sh supported.sh; do
        chmod +x $target/scripts/$f
        wrapProgram $target/scripts/$f \
          --prefix PATH : ${makeBinPath (with pkgs; [coreutils gawk gnused])}
      done
    '';
  });
  tmuxConfig = writeText "tmux-config" ''
    source-file ${./tmux.conf}

    set -g mode-style "fg=#${bg0} bg=#${fg0}"
    set -g pane-active-border-style "fg=#${purple}"
    set -g pane-border-style "fg=#${bg3}"

    set -g @minimal-tmux-fg "#${bg0}"
    set -g @minimal-tmux-bg "#${purple}"
    set -g @minimal-tmux-justify "left"
    set -g @minimal-tmux-indicator-str "tmux"
    set -g @minimal-tmux-expanded-icon "󰊓 "

    set -g @fuzzback-bind s
    set -g @fuzzback-popup 1
    set -g @fuzzback-popup-size "90%"

    run-shell ${minimal-tmux-status}/share/tmux-plugins/minimal-tmux-status/minimal.tmux
    run-shell ${fuzzback'}/share/tmux-plugins/fuzzback/fuzzback.tmux
    run-shell ${vim-tmux-navigator}/share/tmux-plugins/vim-tmux-navigator/vim-tmux-navigator.tmux
    run-shell ${yank}/share/tmux-plugins/vim-tmux-navigator/vim-tmux-navigator.tmux
  '';
  tmux' = mkWrapper "tmux" [pkgs.tmux] [
    "--add-flags '-f ${tmuxConfig}'"
  ];
in {home.packages = [tmux'];}

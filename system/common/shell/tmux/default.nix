{
  inputs,
  lib,
  pkgs,
  theme,
  ...
}: let
  inherit (lib) makeBinPath;
  inherit (pkgs) makeWrapper symlinkJoin tmux writeText;
  inherit (pkgs.tmuxPlugins) mkTmuxPlugin vim-tmux-navigator yank;
  inherit (theme.colors) bg0 bg3 fg0 purple;
  minimal-tmux-status = inputs.minimal-tmux-status.packages.${pkgs.system}.default;
  tmux-fuzzback' = mkTmuxPlugin {
    pluginName = "fuzzback";
    version = "unstable-2022-11-21";
    src = inputs.tmux-fuzzback;
    patches = [./colors.patch];
    nativeBuildInputs = [makeWrapper];
    postInstall = ''
      for f in fuzzback.sh preview.sh supported.sh; do
        chmod +x $target/scripts/$f
        wrapProgram $target/scripts/$f \
          --prefix PATH : ${makeBinPath (with pkgs; [coreutils gawk gnused])}
      done
    '';
    meta = with lib; {
      homepage = "https://github.com/roosta/tmux-fuzzback";
      description = "Fuzzy search for terminal scrollback";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = [maintainers.deejayem];
    };
  };
  config = writeText "tmux-config" ''
    source-file ${./tmux.conf}

    set -g @minimal-tmux-fg "#${bg0}"
    set -g @minimal-tmux-bg "#${purple}"
    set -g @minimal-tmux-justify "left"
    set -g @minimal-tmux-indicator-str "tmux"
    set -g @minimal-tmux-expanded-icon "󰊓 "

    set -g @fuzzback-bind s
    set -g @fuzzback-popup 1
    set -g @fuzzback-popup-size "90%"

    set -g mode-style "fg=#${bg0} bg=#${fg0}"
    set -g pane-active-border-style "fg=#${purple}"
    set -g pane-border-style "fg=#${bg3}"

    run-shell ${minimal-tmux-status}/share/tmux-plugins/minimal-tmux-status/minimal.tmux
    run-shell ${tmux-fuzzback'}/share/tmux-plugins/fuzzback/fuzzback.tmux
    run-shell ${vim-tmux-navigator}/share/tmux-plugins/vim-tmux-navigator/vim-tmux-navigator.tmux
    run-shell ${yank}/share/tmux-plugins/vim-tmux-navigator/vim-tmux-navigator.tmux
  '';
  tmux' = symlinkJoin rec {
    name = "tmux";
    paths = [tmux];
    nativeBuildInputs = [makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/${name} \
        --add-flags "-f ${config}"
    '';
  };
in {user.packages = [tmux'];}

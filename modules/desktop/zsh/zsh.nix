{
  config,
  pkgs,
  ...
}: let
  inherit (config.kkts.system) username;
  inherit (config.stylix) base16Scheme;
  orange = base16Scheme.base09;
  gray = base16Scheme.base03;
in {
  programs.zsh.enable = true;
  users.users.${username}.shell = pkgs.zsh;
  home-manager.users.${username} = {
    home.packages = with pkgs; [lsd];
    programs.zsh = {
      enable = true;
      plugins = [
        {
          file = "share/fzf-tab/fzf-tab.zsh";
          name = "zsh-fzf-tab";
          src = pkgs.zsh-fzf-tab;
        }
      ];
      autosuggestion = {
        enable = true;
        highlight = "fg=#${gray}";
      };
      defaultKeymap = "viins";
      history = {
        extended = true;
        size = 16384;
      };
      sessionVariables = {
        VISUAL = "$EDITOR";
        PAGER = "less";
      };
      syntaxHighlighting = {
        enable = true;
        styles = let
          error = "fg=red";
          keyword = "fg=magenta";
          command = "fg=blue";
          substitution = "fg=cyan";
          argument = "fg=yellow";
          operator = "fg=magenta";
          string = "fg=green";
          variable = "fg=#${orange}";
          path = "fg=cyan";
          comment = "fg=#${gray}";
        in {
          unknown-token = error;
          reserved-word = keyword;
          alias = command;
          suffix-alias = command;
          global-alias = command;
          builtin = keyword;
          function = command;
          inherit command;
          precommand = keyword;
          commandseparator = operator;
          hashed-command = command;
          autodirectory = path;
          inherit path;
          path_prefix = path;
          globbing = operator;
          history-expansion = keyword;
          command-substitution = substitution;
          command-substitution-unquoted = substitution;
          command-substitution-quoted = substitution;
          command-substitution-delimiter = substitution;
          command-substitution-delimiter-unquoted = substitution;
          command-substitution-delimiter-quoted = substitution;
          process-substitution = substitution;
          process-substitution-delimiter = substitution;
          arithmetic-expansion = substitution;
          single-hyphen-option = argument;
          double-hyphen-option = argument;
          back-quoted-argument = variable;
          back-quoted-argument-unclosed = variable;
          back-quoted-argument-delimiter = variable;
          single-quoted-argument = string;
          single-quoted-argument-unclosed = string;
          double-quoted-argument = string;
          double-quoted-argument-unclosed = string;
          dollar-quoted-argument = string;
          dollar-quoted-argument-unclosed = string;
          rc-quote = operator;
          dollar-double-quoted-argument = variable;
          back-double-quoted-argument = operator;
          back-dollar-quoted-argument = operator;
          assign = variable;
          redirection = operator;
          inherit comment;
          named-fd = operator;
          numeric-df = operator;
          arg0 = command;
          default = argument;
        };
      };
      shellAliases = with pkgs; {
        sudo = "sudo ";
        ls = "${lsd}/bin/lsd --group-directories-first";
        ll = "${lsd}/bin/lsd -l --group-directories-first";
        la = "${lsd}/bin/lsd -lA --group-directories-first";
        lt = "${lsd}/bin/lsd --tree --group-directories-first";
        lta = "${lsd}/bin/lsd -A -I .git --tree --group-directories-first";
        cp = "${coreutils}/bin/cp -r";
        scp = "${openssh}/bin/scp -r";
        mkdir = "${coreutils}/bin/mkdir -p";
        grep = "${ripgrep}/bin/rg";
        cat = "${bat}/bin/bat --paging never --style numbers,changes --theme base16";
        less = "${bat}/bin/bat --paging always --style numbers,changes --theme base16";
        du = "${dust}/bin/dust -T $(nproc) -x";
        df = "${duf}/bin/duf -hide special -hide-mp '/nix*,/persist'";
        diff = "${diffutils}/bin/diff --color=auto";
        ip = "${iproute2}/bin/ip --color=auto";
        tmux-kill-inactive = ''
          ${tmux}/bin/tmux list-sessions -F '#{session_attached} #{session_id}' \
            | awk '/^0/{print $2}' \
            | xargs -n 1 tmux kill-session -t
        '';
      };
      initExtra =
        # sh
        ''
          zstyle ':completion:*' menu no
          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
          zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
          zstyle ':completion:*:descriptions' format '[%d]'
          zstyle ':completion:*:git-checkout:*' sort false
          zstyle ':fzf-tab:*' use-fzf-default-opts yes
          zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
          zstyle ':fzf-tab:*' popup-pad 30 0
          zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color always $realpath'

          function lf() {
            local tmp="$(mktemp -t 'yazi-cwd.XXXXXX')" cwd
            yazi "$@" --cwd-file="$tmp"
            if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
            fi
            rm -f -- "$tmp"
          }

          function ,() {
            nix run "nixpkgs#$1" -- $(shift; echo "$@")
          }
        '';
    };
  };
}

{
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (config.kkts.system) username;
  inherit (config.stylix) base16Scheme;
  tmux-status = inputs.minimal-tmux-status.packages.${pkgs.system}.default;
in {
  home-manager.users.${username} = {
    programs.tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        vim-tmux-navigator
        yank
        {
          plugin = fuzzback;
          extraConfig = with base16Scheme; ''
            set -g @fuzzback-bind s
            set -g @fuzzback-popup 1
            set -g @fuzzback-popup-size "90%"
            set -g @fuzzback-fzf-colors "fg:#${base07},bg:#${base00},bg+:#${base02},info:#${base07},border:#${base02},label:#${base0E},prompt:#${base07},pointer:#${base08}"
          '';
        }
        {
          plugin = tmux-status;
          extraConfig = with base16Scheme; ''
            set -g @minimal-tmux-fg "#${base00}"
            set -g @minimal-tmux-bg "#${base0E}"
            set -g @minimal-tmux-justify "left"
            set -g @minimal-tmux-indicator-str "tmux"
            set -g @minimal-tmux-expanded-icon "󰊓 "
          '';
        }
      ];
      extraConfig = with base16Scheme; ''
        set -g mode-keys vi
        set -g status-keys vi

        set -g mouse on

        set -g default-terminal "tmux-256color"
        set -ga terminal-overrides ",tmux-256color:Tc"

        set -g base-index 1
        set -g pane-base-index 1
        setw -g pane-base-index 1
        set -g renumber-windows on

        set -g mode-style "fg=#${base00} bg=#${base05}"
        set -g pane-active-border-style "fg=#${base0E}"
        set -g pane-border-style "fg=#${base02}"

        unbind C-b
        set -g prefix C-Space
        bind C-Space send-prefix
        set -g repeat-time 750

        bind -n M-H previous-window
        bind -n M-L next-window

        unbind -n v
        bind v copy-mode
        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        bind '-' split-window -v -c "#{pane_current_path}"
        bind '[' split-window -h -c "#{pane_current_path}"

        unbind M-Up
        unbind M-Down
        unbind M-Left
        unbind M-Right
        unbind C-Up
        unbind C-Down
        unbind C-Left
        unbind C-Right
        bind -r C-h resize-pane -L
        bind -r C-j resize-pane -D
        bind -r C-k resize-pane -U
        bind -r C-l resize-pane -R

        unbind n
        unbind p
        bind h previous-window
        bind l next-window

        unbind q
        bind c kill-pane

        bind n new-window -c "#{pane_current_path}"
      '';
    };
  };
}

{
  config,
  inputs,
  pkgs,
  spkgs,
  ...
}: let
  inherit (config.kkts.system) username;
  inherit (pkgs) system;
  inherit (inputs.agenix.packages.${system}) agenix;
  inherit (spkgs) arma3-unix-launcher;
in {
  nix.settings = {
    substituters = ["https://nix-gaming.cachix.org"];
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };
  home-manager.users.${username}.home.packages = with pkgs; [
    # programs
    fragments
    gimp
    handbrake
    krita
    libreoffice-still
    loupe
    mpv
    obs-studio
    obsidian
    pwvucontrol
    spotify

    # games todo: move to gaming.nix
    arma3-unix-launcher
    osu-lazer-bin
    prismlauncher

    # utils
    clang
    compsize
    dash
    file
    lm_sensors
    nvme-cli
    ookla-speedtest
    p7zip
    powertop
    rlwrap
    smartmontools
    unrar
    unzip
    usbutils
    zip

    # nix utils
    agenix
    alejandra
    deadnix
    disko
    nixd
    nixos-anywhere
    statix
  ];
}
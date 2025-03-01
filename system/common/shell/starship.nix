{
  lib,
  pkgs,
  theme,
  ...
}: let
  inherit (lib.kkts) mkWrapper writeToml;
  inherit (theme.colors) blue fg0 purple red;
  starshipConfig = writeToml "starship-config" {
    format = "$username@$hostname$directory$nix_shell$git_branch$status$cmd_duration\n$character";
    add_newline = false;
    username = {
      show_always = true;
      format = "[$user](fg:#${purple})";
    };
    hostname = {
      ssh_only = false;
      format = "[$hostname](fg:#${purple})";
    };
    directory = {
      format = " [$read_only](fg:#${fg0})[$path](fg:#${purple})";
      read_only = " ";
    };
    nix_shell.format = " [󱄅 shell](fg:#${blue})";
    git_branch.format = " [ $branch](fg:#${red})";
    status = {
      disabled = false;
      format = " [ $int](fg:#${red})";
    };
    cmd_duration.format = " [$duration](fg:#${fg0})";
    character.format = "[󰘧 ](fg:#${fg0})";
  };
  starship' = mkWrapper "starship" [pkgs.starship] [
    "--set STARSHIP_CONFIG ${starshipConfig}"
  ];
in {home.packages = [starship'];}

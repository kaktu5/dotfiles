{
  pkgs,
  theme,
  ...
}: let
  inherit (pkgs) makeWrapper starship symlinkJoin;
  inherit (theme) colors;
  toToml = (pkgs.formats.toml {}).generate;
  config = toToml "starship-config" (with colors; {
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
    character = {
      format = "$symbol";
      success_symbol = "[󰘧 ](fg:#${fg0})";
      error_symbol = "[󰘧 ](fg:#${fg0})";
      vimcmd_symbol = "[󰘧 ](fg:#${lightBlue})";
    };
  });
  starship' = symlinkJoin rec {
    name = "starship";
    paths = [starship];
    nativeBuildInputs = [makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/${name} \
        --set STARSHIP_CONFIG ${config}
    '';
  };
in {user.packages = [starship'];}

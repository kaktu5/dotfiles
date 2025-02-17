_: {
  homeManager.programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$username@$hostname$directory$nix_shell$git_branch$git_metrics$cmd_duration\n$character";
      directory = {
        format = " [$path](purple)[$read_only](while)";
        read_only = " ";
      };
      username = {
        format = "[$user](purple)";
        show_always = true;
      };
      hostname = {
        ssh_only = false;
        format = "[$hostname](purple)";
      };
      git_branch.format = " [$branch](red)";
      git_metrics = {
        disabled = false;
        format = "( +[$added](green))( -[$deleted](red))";
      };
      nix_shell.format = " [󱄅 shell](blue)";
      cmd_duration.format = " [$duration](white)";
      character = {
        success_symbol = "[󰘧](white)";
        error_symbol = "[󰘧](red)";
      };
    };
  };
}

{config, ...}: let
  inherit (config.kkts.system) username;
in {
  home-manager.users.${username}.programs.git = {
    enable = true;
    userName = "kaktu5";
    userEmail = "108426150+kaktu5@users.noreply.github.com";
    aliases.unfuck = "reset HEAD~1 --soft";
  };
}

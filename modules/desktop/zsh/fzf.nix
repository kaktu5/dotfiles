{config, ...}: let
  inherit (config.kkts.system) username;
  inherit (config.stylix.base16Scheme) base00 base02 base07 base0E;
in {
  home-manager.users.${username}.programs.fzf = {
    enable = true;
    defaultOptions = ["--prompt ': '"];
    colors = {
      fg = "#${base07}";
      bg = "#${base00}";
      "bg+" = "#${base02}";
      info = "#${base07}";
      border = "#${base02}";
      label = "#${base0E}";
      prompt = "#${base07}";
      spinner = "#${base0E}";
      pointer = "#${base0E}";
    };
  };
}

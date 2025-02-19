{
  config,
  pkgs,
  ...
}: let
  inherit (config.kkts.system) username;
  inherit (pkgs) system;
in {
  home-manager.users.${username} = {
    # home.packages = [inputs.yaf.packages.${system}.yaf];
    xdg.configFile."yaf.conf".text = ''
           {c5}/\  {c4}\‾\  /\
           {c5}\ \  {c4}\ \/ /     {c5} {@username}@{@hostname}
        {c5}/‾‾‾  ‾‾‾{c4}\  / {c5}/\   {c4} {@distro}
         {c5}‾‾{c4}/{c5}‾{c4}/{c5}‾‾‾‾{c4}\ \{c5}/ /   󰌽 {@kernel}
       {c4}___/ /      \{c5}/ /‾‾⟩ {c4} {@shell}
      {c4}⟨__  /{c5}\      {c5}/ /‾‾‾   {@pkgs}
        {c4}/ /{c5}\ \{c4}____{c5}/{c4}_{c5}/{c4}__     {$XDG_SESSION_DESKTOP}
        {c4}\/ {c5}/  \{c4}___  ___/   {c5} {@uptime}
          {c5}/ /\ \  {c4}\ \
          {c5}\/  \_\  {c4}\/
    '';
  };
}

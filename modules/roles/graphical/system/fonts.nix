{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.theme.fonts) fonts;
  inherit (lib.attrsets) mapAttrs mapAttrsToList;
  inherit (lib.lists) optionals unique;
  inherit (pkgs) material-symbols sarasa-gothic;
  inherit (pkgs.nerd-fonts) symbols-only;
in {
  fonts = {
    enableDefaultPackages = false;

    packages =
      (fonts
        |> mapAttrsToList (_: font: font.package)
        |> unique)
      ++ [material-symbols sarasa-gothic symbols-only];

    fontconfig.defaultFonts = let
      common = ["Sarasa Mono J" fonts.emoji.name];
    in
      fonts |> mapAttrs (name: font: [font.name] ++ optionals (name != "emoji") common);
  };

  hjem.users.${userName}.environment.sessionVariables = {
    FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
  };
}

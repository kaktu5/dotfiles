{
  config,
  lib,
  pkgs,
}: let
  inherit (config.kkts.theme.colors) rgb;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.generators) toINI;
  inherit (pkgs.writers) writeText;

  rgb' =
    rgb
    |> mapAttrs (_: {
      r,
      g,
      b,
    }: "${r},${g},${b}");

  ForegroundActive = rgb'.cyan;
  ForegroundInactive = rgb'.fg3;
  ForegroundLink = rgb'.cyan;
  ForegroundNegative = rgb'.red;
  ForegroundNeutral = rgb'.yellow;
  ForegroundNormal = rgb'.fg0;
  ForegroundPositive = rgb'.green;
  ForegroundVisited = rgb'.cyan;

  DecorationFocus = rgb'.cyan;
  DecorationHover = rgb'.cyan;
in
  writeText "kkts.colors" (toINI {mkSectionName = n: n;} {
    "ColorEffects:Disabled" = {
      Color = "56,56,56";
      ColorAmount = 0;
      ColorEffect = 0;
      ContrastAmount = 0.65;
      ContrastEffect = 1;
      IntensityAmount = 0.1;
      IntensityEffect = 2;
    };

    "ColorEffects:Inactive".Enable = false;

    "Colors:Button" = {
      BackgroundAlternate = rgb'.cyan;
      BackgroundNormal = rgb'.bg3;
      inherit
        ForegroundActive
        ForegroundInactive
        ForegroundLink
        ForegroundNegative
        ForegroundNeutral
        ForegroundNormal
        ForegroundPositive
        ForegroundVisited
        DecorationFocus
        DecorationHover
        ;
    };

    "Colors:Complementary" = {
      BackgroundAlternate = "30,87,116";
      BackgroundNormal = rgb'.bg1;
      inherit
        ForegroundActive
        ForegroundInactive
        ForegroundLink
        ForegroundNegative
        ForegroundNeutral
        ForegroundNormal
        ForegroundPositive
        ForegroundVisited
        DecorationFocus
        DecorationHover
        ;
    };

    "Colors:Header" = {
      BackgroundAlternate = rgb'.bg3;
      BackgroundNormal = rgb'.bg2;
      inherit
        ForegroundActive
        ForegroundInactive
        ForegroundLink
        ForegroundNegative
        ForegroundNeutral
        ForegroundNormal
        ForegroundPositive
        ForegroundVisited
        DecorationFocus
        DecorationHover
        ;
    };

    "Colors:Header][Inactive" = {
      BackgroundAlternate = rgb'.bg3;
      BackgroundNormal = rgb'.bg2;
      inherit
        ForegroundActive
        ForegroundInactive
        ForegroundLink
        ForegroundNegative
        ForegroundNeutral
        ForegroundNormal
        ForegroundPositive
        ForegroundVisited
        DecorationFocus
        DecorationHover
        ;
    };

    "Colors:Selection" = {
      BackgroundAlternate = rgb'.cyan;
      BackgroundNormal = rgb'.cyan;
      inherit
        ForegroundActive
        ForegroundInactive
        ForegroundLink
        ForegroundNegative
        ForegroundNeutral
        ForegroundNormal
        ForegroundPositive
        ForegroundVisited
        DecorationFocus
        DecorationHover
        ;
    };

    "Colors:Tooltip" = {
      BackgroundAlternate = rgb'.bg2;
      BackgroundNormal = rgb'.bg3;
      inherit
        ForegroundActive
        ForegroundInactive
        ForegroundLink
        ForegroundNegative
        ForegroundNeutral
        ForegroundNormal
        ForegroundPositive
        ForegroundVisited
        DecorationFocus
        DecorationHover
        ;
    };

    "Colors:View" = {
      BackgroundAlternate = rgb'.bg1;
      BackgroundNormal = rgb'.bg0;
      inherit
        ForegroundActive
        ForegroundInactive
        ForegroundLink
        ForegroundNegative
        ForegroundNeutral
        ForegroundNormal
        ForegroundPositive
        ForegroundVisited
        DecorationFocus
        DecorationHover
        ;
    };

    "Colors:Window" = {
      BackgroundAlternate = rgb'.bg3;
      BackgroundNormal = rgb'.bg2;
      inherit
        ForegroundActive
        ForegroundInactive
        ForegroundLink
        ForegroundNegative
        ForegroundNeutral
        ForegroundNormal
        ForegroundPositive
        ForegroundVisited
        DecorationFocus
        DecorationHover
        ;
    };

    General = {
      ColorScheme = "kkts";
      Name = "kkts";
      shadeSortColumn = true;
    };
  })

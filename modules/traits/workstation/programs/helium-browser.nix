{
  config,
  inputs',
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.theme.colors) rgb;
  inherit (inputs'.helium-flake.packages) helium;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.generators) toJSON;
  inherit (lib.kkts.hjem) toMimeMap;
  inherit (pkgs) makeBinaryWrapper symlinkJoin writeTextDir;

  rgb' =
    rgb
    |> mapAttrs (_: {
      r,
      g,
      b,
    }: [r g b]);

  theme = writeTextDir "manifest.json" (toJSON {} {
    manifest_version = 3;
    name = "kkts";
    version = "0.0.0";
    theme.colors = {
      frame = rgb'.bg0;
      frame_inactive = rgb'.bg1;
      toolbar = rgb'.bg2;
      toolbar_button_icon = rgb'.fg2;
      tab_text = rgb'.fg0;
      tab_background_text = rgb'.fg3;
      bookmark_text = rgb'.fg1;
      omnibox_background = rgb'.bg3;
      omnibox_text = rgb'.fg0;
      ntp_background = rgb'.bg1;
      ntp_text = rgb'.fg0;
      ntp_link = rgb'.blue;
    };
  });

  helium' = symlinkJoin {
    inherit (helium) name;
    paths = [helium];
    nativeBuildInputs = [makeBinaryWrapper];
    postBuild = ''
      wrapProgram $out/bin/helium \
        --add-flags --load-extension=${theme}

      for f in $out/share/applications/*.desktop; do
        orig=$(readlink -f "$f")
        rm "$f"
        sed -E "s|^Exec=[^ ]+|Exec=$out/bin/helium|" "$orig" > "$f"
      done
    '';
  };
in {
  persistence.users.${userName}.directories = [".config/net.imput.helium" ".local/cache/net.imput.helium"];

  environment.etc."chromium/policies/managed/policies.json".text = toJSON {} {
    BrowserColorScheme = "dark";

    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "Kagi";
    DefaultSearchProviderKeyword = "kagi";
    DefaultSearchProviderSearchURL = "https://kagi.com/search?q={searchTerms}";
    DefaultSearchProviderSuggestURL = "https://kagi.com/api/autosuggest?q={searchTerms}";
  };

  users.users.${userName}.packages = [helium'];

  hjem.users.${userName}.xdg = {
    config.files."net.imput.helium/Default/Preferences" = {
      generator = toJSON {};
      value = {
        helium = {
          browser = {
            centered_location_bar = true;
            layout = 2; # vertical
          };

          completed_onboarding = true;
        };
      };
    };

    mime-apps.default-applications = toMimeMap {
      "helium.desktop" = [
        "application/xhtml+xml"
        "text/html"
        "x-scheme-handler/about"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/unknown"
      ];
    };
  };
}

{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) toJSON toString;
  inherit (config.stylix) base16Scheme;
  inherit (lib) concatStringsSep foldl mapAttrsToList mkForce pipe readFile singleton;
  inherit (pkgs) fetchFromGitHub system;
  arkenfox = readFile ((fetchFromGitHub {
      owner = "arkenfox";
      repo = "user.js";
      rev = "133.0";
      sha256 = "sha256-iHj+4UGeB1FVGvOWB9ZZA4aiiJynBxRSFFfJqToYEdQ=";
    })
    + "/user.js");
  firefox-addons = inputs.firefox-addons.packages.${system};
  fonts = config.fonts.fontconfig.defaultFonts;
  mkUserPrefs = attrs:
    pipe attrs [
      (mapAttrsToList (name: value: ''user_pref("${name}", ${toJSON value});''))
      (concatStringsSep "\n")
    ];
  mkSearchEngine = {
    alias,
    template,
    params,
  }: {
    definedAliases = [alias];
    urls = singleton {
      inherit template;
      params = pipe params [
        (foldl (acc: param: acc // param) {})
        (mapAttrsToList (name: value: {inherit name value;}))
      ];
    };
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  };
in {
  homeManager = {
    home.file.".mozilla/firefox/kkts/search.json.mozlz4".force = mkForce true;
    programs.firefox = {
      enable = true;
      # package = pkgs.firefox-devedition; # broken
      profiles.kkts = {
        isDefault = true;
        extensions = with firefox-addons; [
          bitwarden
          darkreader
          firefox-color
          skip-redirect
          sponsorblock
          ublock-origin
          vimium
        ];
        search = {
          default = "DuckDuckGo";
          privateDefault = "DuckDuckGo";
          engines = {
            "nixpkgs packages" = mkSearchEngine {
              alias = "@np";
              template = "https://search.nixos.org/packages";
              params = [{channel = "unstable";} {query = "{searchTerms}";}];
            };
            "nixpkgs options" = mkSearchEngine {
              alias = "@no";
              template = "https://search.nixos.org/options";
              params = [{channel = "unstable";} {query = "{searchTerms}";}];
            };
            "home-manager" = mkSearchEngine {
              alias = "@hm";
              template = "https://home-manager-options.extranix.com";
              params = [{release = "master";} {query = "{searchTerms}";}];
            };
            "DuckDuckGo".metaData.alias = "@dg";
            "Google".metaData.hidden = true;
            "Bing".metaData.hidden = true;
            "Wikipedia (en)".metaData.hidden = true;
          };
        };
        extraConfig = concatStringsSep "\n" [
          arkenfox
          ''/*extraConfig*/''
          (mkUserPrefs {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

            "font.name.serif.x-western" = toString fonts.serif;
            "font.name.sans-serif.x-western" = toString fonts.sansSerif;
            "font.name.monospace.x-western" = toString fonts.monospace;

            "sidebar.verticalTabs" = true;
            "sidebar.main.tools" = "history";
            "sidebar.backupState" = ''{"expanded":false,"hidden":false}'';

            "browser.display.background_color.dark" = "#${base16Scheme.base00}";

            "browser.toolbars.bookmarks.visibility" = "never";

            "browser.tabs.closeWindowWithLastTab" = false;

            "extensions.pocket.enabled" = false;

            "browser.newtabpage.enabled" = false;

            "browser.urlbar.trimURLs" = false;
            "browser.urlbar.trimHttps" = false;

            "pdfjs.forcePageColors" = true;
            "pdfjs.pageColorsBackground" = "#${base16Scheme.base00}";
            "pdfjs.pageColorsForeground" = "#${base16Scheme.base07}";

            "widget.gtk.hide-pointer-while-typing.enabled" = false;

            "ui.key.menuAccessKey" = 0;
          })
        ];
        userChrome =
          # css
          ''
            * {
              box-shadow: none !important;
              --panel-shadow: none !important;
              -moz-window-shadow: none;
            }
            .titlebar-buttonbox-container {display: none !important}
            .titlebar-spacer[type="post-tabs"] {display: none !important}
            #back-button, #forward-button {display: none !important}
            #tabbrowser-tabbox {outline: none !important}
            #navigator-toolbox {border-bottom: none !important}
            #tracking-protection-icon-container {display: none !important}
            #page-action-buttons {display: none !important}
          '';
      };
    };
  };
}

/*
* 1. Enable all installed addons
* 2. Enable "all hosts" permission for Vimium
* 3. Unpin all addons from Toolbar
* 4. Apply theme (resources/firefox/theme.json)
* 5. Customize toolbar (search, downloads (hide when empty))
*/
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.system) username;
  inherit (config.stylix) base16Scheme;
  inherit (lib) mkForce readFile;
  inherit (pkgs) fetchFromGitHub system;
  arkenfox = readFile ((fetchFromGitHub {
      owner = "arkenfox";
      repo = "user.js";
      rev = "133.0";
      sha256 = "sha256-iHj+4UGeB1FVGvOWB9ZZA4aiiJynBxRSFFfJqToYEdQ=";
    })
    + "/user.js");
  firefox-addons = inputs.firefox-addons.packages.${system};
in {
  home-manager.users.${username} = {
    home.file.".mozilla/firefox/kkts/search.json.mozlz4".force = mkForce true;
    programs.firefox = {
      enable = true;
      profiles.${username} = {
        isDefault = true;
        extensions = with firefox-addons; [
          bitwarden
          canvasblocker
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
            "nixpkgs packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };
            "nixpkgs options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@no"];
            };
            "home-manager" = {
              urls = [
                {
                  template = "https://home-manager-options.extranix.com";
                  params = [
                    {
                      name = "release";
                      value = "master";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@hm"];
            };
            "DuckDuckGo".metaData.alias = "@dg";
            "Google".metaData.hidden = true;
            "Bing".metaData.hidden = true;
            "Wikipedia (en)".metaData.hidden = true;
          };
        };
        extraConfig =
          arkenfox
          # js
          + ''
            /*
             * extraConfig
             */

            user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

            user_pref("sidebar.verticalTabs", true);
            user_pref("sidebar.main.tools", "history");
            user_pref("sidebar.backupState", "{\"expanded\":false,\"hidden\":false}");

            user_pref("browser.display.background_color.dark", "#${base16Scheme.base00}");

            user_pref("browser.toolbars.bookmarks.visibility", "never");

            user_pref("browser.tabs.closeWindowWithLastTab", false);

            user_pref("extensions.pocket.enabled", false);

            user_pref("browser.newtabpage.enabled", false);

            user_pref("browser.urlbar.trimURLs", false);
            user_pref("browser.urlbar.trimHttps", false);

            user_pref("pdfjs.forcePageColors", true);
            user_pref("pdfjs.pageColorsBackground", "#${base16Scheme.base00}");
            user_pref("pdfjs.pageColorsForeground", "#${base16Scheme.base07}");

            user_pref("widget.gtk.hide-pointer-while-typing.enabled", false);

            user_pref("ui.key.menuAccessKey", 0);
          '';
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

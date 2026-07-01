{
  config,
  inputs',
  lib,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (inputs'.helium-flake.packages) helium;
  inherit (lib.generators) toJSON;
  inherit (lib.kkts.hjem) toMimeMap;
in {
  persistence.users.${userName}.directories = [".config/net.imput.helium" ".local/cache/net.imput.helium"];

  environment.etc."chromium/policies/managed/policies.json".text = toJSON {} {
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "Kagi";
    DefaultSearchProviderKeyword = "kagi";
    DefaultSearchProviderSearchURL = "https://kagi.com/search?q={searchTerms}";
    DefaultSearchProviderSuggestURL = "https://kagi.com/api/autosuggest?q={searchTerms}";
  };

  users.users.${userName}.packages = [helium];

  hjem.users.${userName}.xdg.mime-apps.default-applications = toMimeMap {
    "helium.desktop" = [
      "application/xhtml+xml"
      "text/html"
      "x-scheme-handler/about"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/unknown"
    ];
  };
}

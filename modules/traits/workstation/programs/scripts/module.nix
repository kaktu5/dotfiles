{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.kkts.dag) entryAnywhere;
  inherit (lib.kkts.strings) replaceVars;
  inherit (pkgs) fetchgit;

  texts = toString (fetchgit {
    url = "https://github.com/spdx/license-list-data";
    rev = "v3.28.0";
    rootDir = "text";
    hash = "sha256-t4VVDivkVpPUdBQyDFf4SXBswlddaTNSlse0r5dGrRc=";
  });
in {
  kkts.programs.nushell.extraEntries = {
    license = entryAnywhere <| replaceVars ./license.nu {inherit texts;};
  };
}

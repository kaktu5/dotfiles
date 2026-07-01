{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs) license-list-data;
  inherit (lib.kkts.dag) entryAnywhere;
  inherit (lib.kkts.strings) replaceVars;
  inherit (lib.meta) getExe;
  inherit (pkgs) gitMinimal runCommandLocal;

  spdxTexts = runCommandLocal "spdx-texts" {} ''
    shopt -s extglob
    mkdir $out
    for f in ${license-list-data}/text/!(deprecated_*).txt; do
      name=''${f##*/}
      cp "$f" "$out/''${name%.txt}"
    done
  '';
in {
  kkts.programs.nushell.extraEntries = {
    license = entryAnywhere <| replaceVars ./license.nu {inherit spdxTexts;};
  };
}

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
    cp -r ${license-list-data}/text $out
  '';
in {
  kkts.programs.nushell.extraEntries = {
    license = entryAnywhere <| replaceVars ./license.nu {inherit spdxTexts;};
  };
}

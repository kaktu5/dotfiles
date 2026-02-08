{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (lib.kkts.dag) entryAnywhere;
  inherit (lib.meta) getExe;
  inherit (pkgs) carapace runCommand;

  carapace-nix = runCommand "carapace.nu" {} ''
    ${getExe carapace} _carapace nushell | grep -v '^\$env\.PATH' > $out
  '';
in {
  users.users.${userName}.packages = [carapace];

  kkts.programs.nushell = {
    config.completions = {
      algorithm = "fuzzy";
      quick = false;
      use_ls_colors = false;
    };

    extraEntries.carapace = entryAnywhere "source ${carapace-nix}";
  };
}

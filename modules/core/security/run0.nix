{lib, ...}: let
  inherit (lib.kkts.dag) entryAnywhere;
in {
  security.run0.enable = true;

  kkts.programs.nushell.extraEntries.run0 = entryAnywhere ''
    def --wrapped run0 [...args] {
      let command = $"$in | from nuon | ($args | str join " ") | to nuon"
      $in
      | default null
      | to nuon
      | ^run0 --background "" --pipe -- nu --stdin --config $nu.config-path --commands $command
      | from nuon
    }
  '';
}

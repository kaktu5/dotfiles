{pkgs}:
pkgs.mkShell {
  shellHook = "${pkgs.cloc}/bin/cloc .";
  packages = with pkgs; [
    alejandra
    cloc
    deadnix
    statix
  ];
}

{pkgs}:
pkgs.mkShell {
  packages = with pkgs; [
    alejandra
    deadnix
    statix
  ];
}

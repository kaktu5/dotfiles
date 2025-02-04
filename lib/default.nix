{nixpkgs, ...}:
nixpkgs.lib.extend (
  _: _: {
    kkts.forEachSystem = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"];
  }
)

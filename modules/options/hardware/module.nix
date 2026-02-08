{lib, ...}: {
  options.kkts.hardware.monitors = import ./monitors.nix {inherit lib;};
}

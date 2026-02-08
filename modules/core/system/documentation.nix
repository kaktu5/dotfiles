{pkgs, ...}: let
  inherit (pkgs) man-pages man-pages-posix;
in {
  environment.systemPackages = [man-pages man-pages-posix];

  documentation = {
    dev.enable = true;

    man = {
      enable = true;
      generateCaches = true;
      man-db.enable = false;
      mandoc.enable = true;
    };

    info.enable = false;
  };
}

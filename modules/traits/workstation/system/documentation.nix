{pkgs, ...}: let
  inherit (pkgs) man-pages man-pages-posix;
in {
  environment.systemPackages = [man-pages man-pages-posix];

  documentation = {
    dev.enable = true;

    man = {
      enable = true;
      cache.enable = true;

      mandoc.enable = true;
      man-db.enable = false;
    };

    info.enable = false;
  };
}

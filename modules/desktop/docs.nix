{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
  ];
  documentation = {
    dev.enable = true;
    doc.enable = false;
    info.enable = false;
    man = {
      man-db.enable = false;
      mandoc.enable = true;
    };
    # https://github.com/danth/stylix/issues/47
    # https://github.com/danth/stylix/issues/98
    # nixos.includeAllModules = true;
  };
}

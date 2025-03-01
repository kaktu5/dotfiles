{pkgs, ...}: {
  homeManager = {
    services.arrpc.enable = true;
    home.packages = [pkgs.legcord];
  };
}

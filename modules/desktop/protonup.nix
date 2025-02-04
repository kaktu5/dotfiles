{pkgs, ...}: {
  environment = {
    systemPackages = [pkgs.protonup];
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/$USER/.steam/root/compatibilitytools.d";
    };
  };
}

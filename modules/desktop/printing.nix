{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    simple-scan
    system-config-printer
  ];
  services.printing = {
    enable = true;
    drivers = [pkgs.gutenprint];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
}

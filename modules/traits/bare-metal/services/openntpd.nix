{pkgs, ...}: {
  time.timeZone = "Europe/Warsaw";

  environment.systemPackages = [pkgs.openntpd];
  services.openntpd = {
    enable = true;
    extraConfig = ''
      listen on 127.0.0.1
      listen on ::1
    '';
  };
}

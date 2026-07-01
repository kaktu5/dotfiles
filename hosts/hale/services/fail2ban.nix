{
  persistence.directories = ["/var/lib/fail2ban"];

  services.fail2ban = {
    enable = true;

    bantime = "24h";

    bantime-increment = {
      enable = true;
      multipliers = "1 7 14";
      maxtime = "${24 * 14 + 12}h";
      rndtime = "12h";
    };
  };
}

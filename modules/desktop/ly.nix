_: {
  environment.persistence."/persist/root".files = ["/etc/ly/save.ini"];
  services.displayManager.ly = {
    enable = true;
    settings = {
      clock = "%c";
      vi_default_mode = "insert"; # doesnt work
      vi_mode = true;
    };
  };
}

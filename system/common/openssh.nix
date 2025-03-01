_: {
  environment.persistence."/persist/root".directories = ["/etc/ssh"];
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
}

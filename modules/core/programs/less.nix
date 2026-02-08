{
  programs.less.enable = true;

  environment.sessionVariables = {
    PAGER = "less --quit-if-one-screen --raw-control-chars";
    SYSTEMD_PAGERSECURE = 1;
  };
}

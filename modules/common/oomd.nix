_: {
  systemd.oomd = {
    enableSystemSlice = true;
    enableRootSlice = true;
    enableUserSlices = true;
  };
}

{flake, ...}: {
  system.configurationRevision = flake.shortRev or flake.dirtyShortRev;
}

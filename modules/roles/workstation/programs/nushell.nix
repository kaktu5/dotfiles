{flake, ...}: {
  imports = [(flake + /modules/shared/programs/nushell)];
}

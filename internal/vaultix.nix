{
  inputs,
  self,
}: let
  inherit (inputs) systems vaultix;
in
  vaultix.configure {
    nodes = self.nixosConfigurations;
    identity = "~/.ssh/id_ed25519";
    cache = ".vaultix";
    systems = import systems;
  }

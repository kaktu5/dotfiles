{
  inputs,
  self,
}: let
  inherit (inputs) systems vaultix;
in
  vaultix.configure {
    nodes = self.nixosConfigurations;
    identity = "~/.ssh/id_ed25519";
    cache = "secrets/.vaultix-renc";
    systems = import systems;
  }

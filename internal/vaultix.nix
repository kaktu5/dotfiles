{
  inputs,
  self,
  systems,
}: let
  inherit (inputs) vaultix;
in
  vaultix.configure {
    nodes = self.nixosConfigurations;
    identity = "~/.ssh/id_ed25519";
    cache = ".vaultix";
    inherit systems;
  }

{
  description = "system config";
  
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixos-wsl.url = "github:nix-community/nixos-wsl";
  };

  outputs = { self, nixpkgs, nixos-wsl }: {
     nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [
        ./configuration.nix
        nixos-wsl.nixosModules.wsl
       ];
     };
  };
}

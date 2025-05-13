{

  description = "My first flake!";

  inputs = {
    nixpkgs = { url = "nixpkgs/nixos-24.11"; };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        nixos =
          lib.nixosSystem { # must be same as hostname in configuration.nix
            inherit system;
            modules = [ ./configuration.nix 
              home-manager.nixosModules.home-manager
              { home-manager.backupFileExtension = "bak"; }];
          };
      };

      homeConfigurations = {
        fishnak =
          home-manager.lib.homeManagerConfiguration { # must be same as username whose config we are making
            inherit pkgs;
            modules = [
              ./home.nix
            ];
          };
      };
    };
}

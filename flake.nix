{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }: 
    let
    system = "x86_64-linux";
  overlay-nixpkgs = final: prev: {
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  };
  in {
    nixosConfigurations = {
      turing = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ 
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-nixpkgs ]; })
          ./system/configuration.nix 
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.munnik = import ./users/munnik/home.nix;
          }
        ];
      };
    };
  };
}

{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unfree = {
      url = "github:numtide/nixpkgs-unfree";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # use `nix flake show` to display package content
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    nixosConfigurations = {
      turing = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ 
          ./system/configuration.nix 
        ];

        specialArgs.flake-inputs = inputs;
      };
    };

    homeConfigurations = {
      munnik = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./users/munnik/home.nix
        ];
        extraSpecialArgs.flake-inputs = inputs;
      };
    };
  };
}

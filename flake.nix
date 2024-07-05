{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unfree = {
      url = "github:numtide/nixpkgs-unfree";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    # use `nix flake show` to display package content
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: 
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      turing = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ 
          ./system/configuration.nix 
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.munnik= import ./users/munnik/home.nix;
            home-manager.extraSpecialArgs.flake-inputs = inputs;
            home-manager.backupFileExtension = "backup";
          }
          inputs.stylix.nixosModules.stylix
        ];

        specialArgs.flake-inputs = inputs;
      };
    };
  };
}

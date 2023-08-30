{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unfree = {
      url = "github:numtide/nixpkgs-unfree";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };
    eza.url = "github:eza-community/eza";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-23.05";
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
          inputs.hyprland.homeManagerModules.default
          inputs.nixvim.homeManagerModules.nixvim     
        ];
        extraSpecialArgs.flake-inputs = inputs;
      };
    };
  };
}

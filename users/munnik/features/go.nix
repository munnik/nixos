{ pkgs, flake-inputs, ... }:
{
  home.packages = with flake-inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}; [
    delve
    gdlv
    go_1_21
    # gofumpt
    # golines
    # gomodifytags
    # gopls
    goreleaser
    # gotests
    # gotools
  ];
}

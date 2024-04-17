{ pkgs, flake-inputs, ... }:
{
  home.packages = with pkgs; [
    air
    delve
    gdlv
    go
    gofumpt
    golines
    gomodifytags
    gopls
    goreleaser
    gotests
    gotools
  ];
}

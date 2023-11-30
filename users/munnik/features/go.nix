{ pkgs, flake-inputs, ... }:
{
  home.packages = with pkgs; [
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

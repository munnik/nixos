{ pkgs, flake-inputs, ... }:
{
  home.packages = with pkgs; [
    air
    delve
    gdlv
    go
    gofumpt
    golines
    golint
    gomodifytags
    gopls
    goreleaser
    gotests
    gotools

    glibc
  ];
}

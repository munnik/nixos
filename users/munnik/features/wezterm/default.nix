{
  pkgs,
  lib,
  flake-inputs,
  config,
  ...
}:
{
  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./config.lua;
  };
}

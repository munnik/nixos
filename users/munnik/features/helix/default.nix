{ pkgs, lib, flake-inputs, ... } :
{
  programs.helix = {
    package = flake-inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.helix;
    enable = true;
    settings = lib.importTOML ./settings.toml;
    languages = lib.importTOML ./languages.toml;
    themes = {
      catppucin = lib.importTOML ./theme_catppucin.toml; 
      munnik = lib.importTOML ./theme_munnik.toml; 
    };
  };
}

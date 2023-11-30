{ pkgs, lib, flake-inputs, ... } :
{
  programs.helix = {
    enable = true;
    settings = lib.importTOML ./settings.toml;
    languages = lib.importTOML ./languages.toml;
    themes = {
      catppucin = lib.importTOML ./theme_catppucin.toml; 
      munnik = lib.importTOML ./theme_munnik.toml; 
    };
  };
}

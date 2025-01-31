{
  pkgs,
  lib,
  flake-inputs,
  config,
  ...
}:
{
  systemd.user.tmpfiles.rules = [
    "d ${config.xdg.configHome}/onedrive-sharepoint-1 0700 munnik users"
    "d ${config.xdg.configHome}/onedrive-sharepoint-2 0700 munnik users"
    "d ${config.xdg.configHome}/onedrive-sharepoint-3 0700 munnik users"
    "d ${config.xdg.configHome}/onedrive-sharepoint-4 0700 munnik users"
    "d ${config.xdg.configHome}/onedrive-sharepoint-5 0700 munnik users"
    "d ${config.xdg.configHome}/onedrive-sharepoint-6 0700 munnik users"
    "d ${config.xdg.configHome}/onedrive-sharepoint-7 0700 munnik users"
    "d ${config.xdg.configHome}/onedrive-sharepoint-8 0700 munnik users"
  ];

  xdg.configFile = {
    "onedrive-sharepoint-1/config" = {
      text = ''
        sync_dir = "~/SharePoint/1-Management & Financials"
        drive_id = "b!UMvw5r2KlkClKYLpga2pyPmvFNfROLZAqhGUwC5sYzF9N0-8vcPER6em24DHYfe7"      
      '';
    };
    "onedrive-sharepoint-2/config" = {
      text = ''
        sync_dir = "~/SharePoint/2-Marketing & Intelligence"
        drive_id = "b!Dz9GYKTQC0qbA_YXG0rInfmvFNfROLZAqhGUwC5sYzF9N0-8vcPER6em24DHYfe7"
      '';
    };
    "onedrive-sharepoint-3/config" = {
      text = ''
        sync_dir = "~/SharePoint/3-Sales & Clients"
        drive_id = "b!qwnMaCX_iE-dAIJxBsgH3_mvFNfROLZAqhGUwC5sYzF9N0-8vcPER6em24DHYfe7"      
      '';
    };
    "onedrive-sharepoint-4/config" = {
      text = ''
        sync_dir = "~/SharePoint/4-Projects & Installations"
        drive_id = "b!5EhzKCieYUOsM-ULE2gTv_mvFNfROLZAqhGUwC5sYzF9N0-8vcPER6em24DHYfe7"      
      '';
    };
    "onedrive-sharepoint-5/config" = {
      text = ''
        sync_dir = "~/SharePoint/5-Purchasing & Suppliers"
        drive_id = "b!3aHbeCyBakKXMJKUA3UMgvmvFNfROLZAqhGUwC5sYzF9N0-8vcPER6em24DHYfe7"      
      '';
    };
    "onedrive-sharepoint-6/config" = {
      text = ''
        sync_dir = "~/SharePoint/6-Technology & Manuals"
        drive_id = "b!4uf7QmMGMEm7jSJb8ZRfrvmvFNfROLZAqhGUwC5sYzF9N0-8vcPER6em24DHYfe7"      
      '';
    };
    "onedrive-sharepoint-7/config" = {
      text = ''
        sync_dir = "~/SharePoint/7-Legal & Contracts"
        drive_id = "b!DJYL0cpPtUGRC-Dd9h-s2vmvFNfROLZAqhGUwC5sYzF9N0-8vcPER6em24DHYfe7"      
      '';
    };
    "onedrive-sharepoint-8/config" = {
      text = ''
        sync_dir = "~/SharePoint/8-Insights & Reports"
        drive_id = "b!dZHsYeHvlk6-zeq9d-Uj8qOEMZrMN65Ep5KQnaXB_fZ--bv7nr7GTbV7_Euch552"      
      '';
    };

    # https://mort.io/blog/nixos-onedrive/
    "onedrive-launcher" = {
      text = ''
        onedrive-sharepoint-1
        onedrive-sharepoint-2
        onedrive-sharepoint-3
        onedrive-sharepoint-4
        onedrive-sharepoint-5
        onedrive-sharepoint-6
        onedrive-sharepoint-7
        onedrive-sharepoint-8       
      '';
    };    
  };
}

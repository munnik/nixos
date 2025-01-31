{
  pkgs,
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    extraPackages = [
      pkgs.nixd
    ];
    extensions = [
      "catppuccin"
      "golang-lint"
      "gosum"
      "marksman"
      "nix"
    ];
    userSettings = {
      features = {
        copilot = false;
        inline_completion_provider = "supermaven";
      };
      telemetry = {
        metrics = false;
      };
      vim_mode = false;
      autosave = "on_focus_change";
    };
  };
}

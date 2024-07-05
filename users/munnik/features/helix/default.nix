{ pkgs, lib, flake-inputs, ... } :
{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      keys.normal = {
        C-p = [ "move_line_up" "scroll_up" ];
        C-n = [ "move_line_down" "scroll_down" ];
        esc = [ "collapse_selection" "keep_primary_selection" ];
        G = [ "goto_file_end" ];
        X = [ "extend_line_above" ];
        ret = [ "move_line_down" "goto_line_start" ];
      };
      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        completion-replace = true;
        bufferline = "multiple";
        shell = [ "zsh" "-c" ];
      };
      editor.cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      
      editor.file-picker = {
        hidden = false;
      };
      
      editor.indent-guides = {
        render = true;
      };
      
      editor.lsp = {
        display-messages = true;
        display-inlay-hints = true;
        display-signature-help-docs = true;
      };
      
      editor.statusline = {
        left = [ "mode" "spinner" ];
        center = [ "version-control" "file-name" "file-modification-indicator" ];
        right = [ "diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type" ];
        separator = "|";
        mode.normal = "NORMAL";
        mode.insert = "INSERT";
        mode.select = "SELECT";
      };
    };
  };
}

local wezterm = require 'wezterm'

return {
  automatically_reload_config = true,
  hide_tab_bar_if_only_one_tab = true,
  font_size = 13.0,
  inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.7,
  },
  default_cursor_style = "SteadyBar",
  cursor_thickness = 1,
  keys = {
    -- Pane splitting
    {
      key = 'd',
      mods = 'CMD',
      action = wezterm.action.SplitHorizontal
    },
    {
      key = 'd',
      mods = 'SHIFT|CMD',
      action = wezterm.action.SplitVertical
    },
    -- Pane closing
    {
      key="w",
      mods="CMD",
      action = wezterm.action{CloseCurrentPane={confirm=true}}
    },
    -- Pane full screen
    {
      key = 'Enter',
      mods = 'CMD|SHIFT',
      action = wezterm.action.TogglePaneZoomState,
    },
    -- Command prompt word navigation
    {key="LeftArrow", mods="OPT", action=wezterm.action{SendString="\x1bb"}},
    {key="RightArrow", mods="OPT", action=wezterm.action{SendString="\x1bf"}},

    -- Pane navigation
    {key="UpArrow", mods="CMD", action=wezterm.action.ActivatePaneDirection("Up")},
    {key="DownArrow", mods="CMD", action=wezterm.action.ActivatePaneDirection("Down")},
    {key="LeftArrow", mods="CMD", action=wezterm.action.ActivatePaneDirection("Left")},
    {key="RightArrow", mods="CMD", action=wezterm.action.ActivatePaneDirection("Right")},

    -- Command+option+arrows to move between tabs
    {key="LeftArrow", mods="CMD|OPT", action=wezterm.action.ActivateTabRelative(-1)},
    {key="RightArrow", mods="CMD|OPT", action=wezterm.action.ActivateTabRelative(1)},

    -- Clear terminal
    {
      key = 'k',
      mods = 'CMD',
      action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
    },
  }
}
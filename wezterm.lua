-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
--

config.window_background_opacity = 1.0
config.background = {
  {
    source = {
      File = "/Users/simon/background.jpg", 
    },
    hsb = {
      brightness = 0.05, -- lower = dimmer
      saturation = 0.75,
      hue = 1.0,
    },
  },
}

config.window_decorations = "RESIZE"
config.color_scheme = "Monokai Pro (Gogh)"

local act = wezterm.action

config.keys = {
  -- Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = act.SendKey {
      key = 'b',
      mods = 'ALT',
    },
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = act.SendKey { key = 'f', mods = 'ALT' },
  },
  -- open tab next to current tab
  {
    key = 't',
    mods = 'CMD',
    -- https://github.com/wez/wezterm/issues/909
    action = wezterm.action_callback(function(win, pane)
      local mux_win = win:mux_window()
      for _, item in ipairs(mux_win:tabs_with_info()) do
        if item.is_active then
          mux_win:spawn_tab({})
          win:perform_action(wezterm.action.MoveTab(item.index+1), pane)
          return
        end
      end
    end),
  },
}

config.hide_tab_bar_if_only_one_tab = true

-- and finally, return the configuration to wezterm
return config


-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.keys = {
  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  { key = "LeftArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bb" }) },
  -- Make Option-Right equivalent to Alt-f; forward-word
  { key = "RightArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bf" }) },
  { key = "f", mods = "CTRL|CMD", action = wezterm.action.ToggleFullScreen },
}

config.native_macos_fullscreen_mode = true

config.font_size = 18.0

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return "Dark"
end

config.background = {
  {
    source = {
      File = (function()
        local appearance = get_appearance()
        if appearance:find("Dark") then
          return wezterm.home_dir .. "/.config/wezterm/makise_kurisu_dark.png"
        else
          return wezterm.home_dir .. "/.config/wezterm/makise_kurisu_light.png"
        end
      end)(),
    },
  },
}

config.color_scheme = (function()
  local appearance = get_appearance()
  if appearance:find("Dark") then
    return "flexoki-dark"
  else
    return "flexoki-light"
  end
end)()
config.hide_tab_bar_if_only_one_tab = true

-- and finally, return the configuration to wezterm
return config

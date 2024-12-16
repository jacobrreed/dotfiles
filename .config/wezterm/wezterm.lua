local wezterm = require("wezterm")
local action = wezterm.action
local config = wezterm.config_builder()

config.font_size = 18
config.font = wezterm.font("Iosevka Custom", { weight = "Regular" })

config.default_cursor_style = "SteadyBlock"

config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.automatically_reload_config = true
config.check_for_updates = true
config.detect_password_input = true
config.window_padding = {
  bottom = 4,
  top = 4,
  left = 4,
  right = 2,
}
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20
config.win32_system_backdrop = "Acrylic"
config.warn_about_missing_glyphs = false

config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
  regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
  format = "https://www.github.com/$1/$3",
})

config.leader = { key = "t", mods = "CTRL", timeout_milliseconds = 1000 }

config.bypass_mouse_reporting_modifiers = "CTRL"
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
  {
    event = { Down = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = wezterm.action.Nop,
  },
}
config.keys = {
  {
    key = "d",
    mods = "CTRL",
    action = action.DisableDefaultAssignment,
  },
  {
    key = "Enter",
    mods = "CTRL",
    action = action.DisableDefaultAssignment,
  },
  {
    key = "h",
    mods = "CTRL|SHIFT",
    action = action.DisableDefaultAssignment,
  },
  {
    key = "l",
    mods = "CTRL|SHIFT",
    action = action.DisableDefaultAssignment,
  },
  {
    key = "k",
    mods = "CTRL|SHIFT",
    action = action.ClearScrollback("ScrollbackAndViewport"),
  },
  {
    key = "w",
    mods = "CTRL|SHIFT",
    action = action.CloseCurrentTab({ confirm = false }),
  },
  {
    key = "RightArrow",
    mods = "CTRL|SHIFT",
    action = action.ActivateTabRelative(1),
  },
  {
    key = "LeftArrow",
    mods = "CTRL|SHIFT",
    action = action.ActivateTabRelative(-1),
  },
  -- Multiplexing
  {
    key = "v",
    mods = "LEADER",
    action = action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "b",
    mods = "LEADER",
    action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "x",
    mods = "LEADER",
    action = action.CloseCurrentPane({ confirm = false }),
  },
  {
    key = "h",
    mods = "LEADER",
    action = action.ActivatePaneDirection("Left"),
  },
  {
    key = "l",
    mods = "LEADER",
    action = action.ActivatePaneDirection("Right"),
  },
  {
    key = "j",
    mods = "LEADER",
    action = action.ActivatePaneDirection("Down"),
  },
  {
    key = "k",
    mods = "LEADER",
    action = action.ActivatePaneDirection("Up"),
  },
  {
    key = "h",
    mods = "LEADER|CTRL",
    action = action.AdjustPaneSize({ "Left", 5 }),
  },
  {
    key = "l",
    mods = "LEADER|CTRL",
    action = action.AdjustPaneSize({ "Right", 5 }),
  },
  {
    key = "j",
    mods = "LEADER|CTRL",
    action = action.AdjustPaneSize({ "Down", 5 }),
  },
  {
    key = "k",
    mods = "LEADER|CTRL",
    action = action.AdjustPaneSize({ "Up", 5 }),
  },
  {
    key = "c",
    mods = "LEADER",
    action = action.SpawnTab("CurrentPaneDomain"),
  },
  {
    key = "t",
    mods = "CTRL|SHIFT",
    action = action.PromptInputLine({
      description = "Rename tab",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
  {
    key = "1",
    mods = "LEADER",
    action = action.ActivateTab(0),
  },
  {
    key = "2",
    mods = "LEADER",
    action = action.ActivateTab(1),
  },
  {
    key = "3",
    mods = "LEADER",
    action = action.ActivateTab(2),
  },
  {
    key = "4",
    mods = "LEADER",
    action = action.ActivateTab(3),
  },
  {
    key = "5",
    mods = "LEADER",
    action = action.ActivateTab(4),
  },
  {
    key = "6",
    mods = "LEADER",
    action = action.ActivateTab(5),
  },
  {
    key = "7",
    mods = "LEADER",
    action = action.ActivateTab(6),
  },
  {
    key = "8",
    mods = "LEADER",
    action = action.ActivateTab(7),
  },
  {
    key = "9",
    mods = "LEADER",
    action = action.ActivateTab(8),
  },
  {
    key = "n",
    mods = "LEADER",
    action = action.ActivateTabRelative(1),
  },
  {
    key = "p",
    mods = "LEADER",
    action = action.ActivateTabRelative(-1),
  },
  {
    key = "z",
    mods = "LEADER",
    action = action.ActivateCopyMode,
  },
}

config.window_decorations = "RESIZE"
config.automatically_reload_config = true

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.tab_max_width = 120

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  local launch_powershell = {
    label = "Powershell 7",
    args = { "C:/Program Files/PowerShell/7/pwsh.exe" },
    domain = { DomainName = "local" },
  }
  config.launch_menu = {
    launch_powershell,
  }
  config.wsl_domains = {
    {
      name = "Arch",
      distribution = "Arch",
    },
  }

  config.window_decorations = "TITLE | RESIZE"
  config.default_domain = "Arch"
else -- Mac or Linux
  -- multiplexing
  config.unix_domains = {
    {
      name = "unix",
    },
  }
  config.inactive_pane_hsb = {
    brightness = 0.6,
  }
  config.default_gui_startup_args = { "connect", "unix" }
end

config.ssh_domains = {
  {
    name = "dockerbox",
    remote_address = "192.168.86.4",
    username = "neonvoid",
  },
}

config.color_scheme = "Eldritch"
return config

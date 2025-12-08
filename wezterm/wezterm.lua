local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true

config.background = {
    {
        -- source = { File = "/Users/dpleti/.dotfiles/pics/omao-shaded.jpeg" },
        source = { File = "/Users/dpleti/.dotfiles/pics/omao.jpeg" },
        hsb = {
            hue = 1.0,
            saturation = 1.11,
            -- brightness = 1.00,
            brightness = 0.025,
        },
        width = '100%',
        height = '100%',
    }, {
        source = {
            Gradient = {
                colors = { 'white', '#000000' },
                orientation = {
                    Radial = {
                        cx = 0.55,
                        cy = 0.41,
                        -- radius = 1.25,
                        radius = 0.125,
                    },
                }
            }
        },
        width = '100%',
        height = '100%',
        opacity = 0.125
    }
}

config.color_scheme = 'Gruvbox Dark'

-- config.enable_tab_bar = false

config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 14

config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.hide_tab_bar_if_only_one_tab = true

config.initial_cols = 120
config.initial_rows = 28

config.keys = {
    -- { key="LeftArrow", mods="CTRL", action=wezterm.action{SendString="\x1bb"} },
    -- { key="RightArrow", mods="CTRL", action=wezterm.action{SendString="\x1bf"} },
}

config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = 'RESIZE'

config.window_padding = {
    left = '1cell',
    right = '1cell',
    top = '0.5cell',
    bottom = '0.5cell',
}


return config

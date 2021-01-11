name = "Let me sprint!"
description = "Hold LSHIFT (Configurable) to sprint at the cost of increased hunger drain"
author = "Dilathekila"
version = "1.0.0"

forumthread = ""

api_version = 10

dont_starve_compatible = true
reign_of_giants_compatible = false
shipwrecked_compatible = false
dst_compatible = true

client_only_mod = false
all_clients_require_mod = true

server_filter_tags = {"Let", "Me", "Sprint"}

priority = 0

icon_atlas = "preview.xml"
icon = "preview.tex"

local keys = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U",
              "V", "W", "X", "Y", "Z", "TAB", "LSHIFT", "CAPSLOCK", "LALT", "LCTRL", "BACKSPACE", "PERIOD", "SLASH",
              "TILDE"}

configuration_options = {{
    name = "sprintBind",
    label = "Sprint keybind",
    hover = "Holding this key will allow you to sprint.",
    options = {},
    default = "LSHIFT"
}, {
    name = "mouseEnabled",
    label = "Enable sprint with middle mouse?",
    hover = "Enabling this will allow you to sprint with the middle mouse button in addition to Sprint keybind",
    options = {{
        description = "Enabled",
        data = 1
    }, {
        description = "Disabled",
        data = 0
    }},
    default = 0
}, {
    name = "sprintSpeed",
    label = "Sprint Speed Multiplier",
    hover = "How much faster you move when sprinting",
    options = {{
        description = "1x",
        data = 1
    }, {
        description = "1.1x",
        data = 1.1
    }, {
        description = "1.25x",
        data = 1.25
    }, {
        description = "1.5x",
        data = 1.5
    }, {
        description = "1.75x",
        data = 1.75
    }, {
        description = "2x",
        data = 2
    }, {
        description = "3x - warranty void",
        data = 3
    }},
    default = 1.5
}, {
    name = "hungerDrain",
    label = "Hunger Drain Multiplier",
    hover = "How much faster you lose hunger when sprinting",
    options = {{
        description = "1x",
        data = 1
    }, {
        description = "1.5x",
        data = 1.5
    }, {
        description = "2x",
        data = 2
    }, {
        description = "3x",
        data = 3
    }, {
        description = "4x",
        data = 4
    }, {
        description = "5x",
        data = 5
    }},
    default = 3
}}

for i = 1, #keys, 1 do
    configuration_options[1].options[i] = {
        description = keys[i],
        data = keys[i]
    }
end

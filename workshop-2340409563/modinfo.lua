name = "Let me sprint!"
description = "Hold LSHIFT (Configurable) to sprint at the cost of increased hunger drain"
author = "Dilathekila"
version = "2.0.2"

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
              "V", "W", "X", "Y", "Z", "TAB", "LSHIFT", "RSHIFT", "CAPSLOCK", "LALT", "LCTRL", "BACKSPACE", "PERIOD",
              "SLASH", "TILDE"}

configuration_options = {{
    name = "sprintBind",
    label = "Sprint keybind",
    hover = "Holding this key will allow you to sprint.",
    options = {},
    default = "LSHIFT"
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
}, {
    name = "hungerThreshold",
    label = "Hunger Threshold",
    hover = "Minimum hunger threshold at which you are allowed to sprint",
    options = {{
        description = "0%",
        data = 0
    }, {
        description = "5%",
        data = 5
    }, {
        description = "10%",
        data = 10
    }, {
        description = "15%",
        data = 15
    }, {
        description = "20%",
        data = 20
    }, {
        description = "25%",
        data = 25
    }, {
        description = "30%",
        data = 30
    }, {
        description = "35%",
        data = 35
    }, {
        description = "40%",
        data = 40
    }, {
        description = "45%",
        data = 45
    }, {
        description = "50%",
        data = 50
    }, {
        description = "55%",
        data = 55
    }, {
        description = "60%",
        data = 60
    }, {
        description = "65%",
        data = 65
    }, {
        description = "70%",
        data = 70
    }, {
        description = "75%",
        data = 75
    }},
    default = 25
}}

for i = 1, #keys, 1 do
    configuration_options[1].options[i] = {
        description = keys[i],
        data = keys[i]
    }
end

name = "Let me sprint!"
description = "Press R to toggle sprint"
author = "Dilathekila"
version = "0.0.2"

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

configuration_options = {{
    name = "sprintSpeed",
    label = "Sprint Speed Multiplier",
    hover = "How much faster you move when sprinting",
    options = {{
        description = "1x",
        data = 1
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
    default = 1.25
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
    default = 2
}}

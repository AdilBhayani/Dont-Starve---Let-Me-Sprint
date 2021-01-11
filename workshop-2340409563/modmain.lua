local G = GLOBAL
local isSprinting = 0

local sprintKey = G["KEY_" .. GetModConfigData("sprintBind")]
local mouseEnabled = GetModConfigData("mouseEnabled")
local enabledBy = 'none'

local function sprint(player)
    player.components.locomotor:SetExternalSpeedMultiplier(player, "speedmeup", GetModConfigData("sprintSpeed"))
end

local function revertSprint(player)
    player.components.locomotor:SetExternalSpeedMultiplier(player, "speedmeup", 1.0)
    local initialHungerRate = player.components.hunger.hungerrate
    player.components.hunger:SetRate(initialHungerRate / GetModConfigData("hungerDrain"))
end

local function increaseHunger(player)
    player.components.hunger:SetRate(player.components.hunger.hungerrate * GetModConfigData("hungerDrain"))
end

local function decreaseHunger(player)
    player.components.hunger:SetRate(player.components.hunger.hungerrate / GetModConfigData("hungerDrain"))
end

AddModRPCHandler(modname, "dsiRemoteSprint", function(player, modVersion)
    sprint(player)
end)

AddModRPCHandler(modname, "dsiRemoteRevertSprint", function(player, modVersion)
    revertSprint(player)
end)

AddModRPCHandler(modname, "dsiRemoteIncreaseHunger", function(player, modVersion)
    increaseHunger(player)
end)

AddModRPCHandler(modname, "dsiRemoteDecreaseHunger", function(player, modVersion)
    decreaseHunger(player)
end)

--- Key pressed - begin sprinting.
G.TheInput:AddKeyDownHandler(sprintKey, function()
    if not (G.TheFrontEnd:GetActiveScreen() and G.TheFrontEnd:GetActiveScreen().name and
        type(G.TheFrontEnd:GetActiveScreen().name) == "string" and G.TheFrontEnd:GetActiveScreen().name == "HUD") then
        return
    end

    local modVersion = G.KnownModIndex:GetModInfo(modname).version

    if isSprinting == 0 then
        enabledBy = "keyboard"
        isSprinting = 1
        -- Server-side
        if G.TheNet:GetIsServer() then
            sprint(G.ThePlayer)
            -- Client-side
        else
            SendModRPCToServer(MOD_RPC[modname]["dsiRemoteSprint"], modVersion)
        end
    end
end)

--- Key released - stop sprinting.
G.TheInput:AddKeyUpHandler(sprintKey, function()
    if not (G.TheFrontEnd:GetActiveScreen() and G.TheFrontEnd:GetActiveScreen().name and
        type(G.TheFrontEnd:GetActiveScreen().name) == "string" and G.TheFrontEnd:GetActiveScreen().name == "HUD") then
        return
    end
    local modVersion = G.KnownModIndex:GetModInfo(modname).version

    if isSprinting == 1 and enabledBy == "keyboard" then
        isSprinting = 0
        -- Server-side
        if G.TheNet:GetIsServer() then
            revertSprint(G.ThePlayer)
            --- Client-side
        else
            SendModRPCToServer(MOD_RPC[modname]["dsiRemoteRevertSprint"], modVersion)

        end
    end
end)

G.TheInput:AddMouseButtonHandler(function(button, down, x, y)
    if mouseEnabled == 1 and button == 1002 and down and isSprinting == 0 then
        isSprinting = 1
        enabledBy = "mouse"
        -- Server-side
        if G.TheNet:GetIsServer() then
            sprint(G.ThePlayer)
            -- Client-side
        else
            SendModRPCToServer(MOD_RPC[modname]["dsiRemoteSprint"], modVersion)
        end
    end
    if mouseEnabled == 1 and button == 1002 and not down and isSprinting == 1 and enabledBy ~= "mouse" then
        isSprinting = 0
        if G.TheNet:GetIsServer() then
            revertSprint(G.ThePlayer)
        else
            --- Client-side
            SendModRPCToServer(MOD_RPC[modname]["dsiRemoteRevertSprint"], modVersion)
        end
    end
end)

local onLocomote = function(player, data)
    -- print(inst.components.locomotor.isrunning)
    if player.components.locomotor.isrunning and isSprinting == 1 then
        -- Server-side
        if G.TheNet:GetIsServer() then
            revertSprint(G.ThePlayer)
            --- Client-side
        else
            SendModRPCToServer(MOD_RPC[modname]["dsiRemoteIncreaseHunger"], modVersion)

        end
    end

    if not player.components.locomotor.isrunning and isSprinting == 1 then
        -- Server-side
        if G.TheNet:GetIsServer() then
            revertSprint(G.ThePlayer)
            --- Client-side
        else
            SendModRPCToServer(MOD_RPC[modname]["dsiRemoteDecreaseHunger"], modVersion)

        end
    end
end

AddPlayerPostInit(function(player)
    print('adding event listeners')
    player:ListenForEvent('locomote', onLocomote)
end)

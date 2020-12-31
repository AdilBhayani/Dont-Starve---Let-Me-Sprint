local G = GLOBAL
local isSprinting = 0
local sprintKey = G["KEY_" .. GetModConfigData("sprintBind")]

local function sprint(player)
    player.components.locomotor:SetExternalSpeedMultiplier(player, "speedmeup", GetModConfigData("sprintSpeed"))
    local initialHungerRate = player.components.hunger.hungerrate
    player.components.hunger:SetRate(initialHungerRate * GetModConfigData("hungerDrain"))
end

local function revertSprint(player)
    player.components.locomotor:SetExternalSpeedMultiplier(player, "speedmeup", 1.0)
    local initialHungerRate = player.components.hunger.hungerrate
    player.components.hunger:SetRate(initialHungerRate / GetModConfigData("hungerDrain"))
end

AddModRPCHandler(modname, "dsiRemoteSprint", function(player, modVersion)
    sprint(player)
end)

AddModRPCHandler(modname, "dsiRemoteRevertSprint", function(player, modVersion)
    revertSprint(player)
end)

--- Key pressed - begin sprinting.
G.TheInput:AddKeyDownHandler(sprintKey, function()
    if not (G.TheFrontEnd:GetActiveScreen() and G.TheFrontEnd:GetActiveScreen().name and
        type(G.TheFrontEnd:GetActiveScreen().name) == "string" and G.TheFrontEnd:GetActiveScreen().name == "HUD") then
        return
    end

    local modVersion = G.KnownModIndex:GetModInfo(modname).version

    -- Server-side
    if G.TheNet:GetIsServer() then
        if (isSprinting == 0) then
            isSprinting = 1
            sprint(G.ThePlayer)
        end
        -- Client-side
    else
        if (isSprinting == 0) then
            isSprinting = 1
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

    -- Server-side
    if G.TheNet:GetIsServer() then
        if (isSprinting == 1) then
            isSprinting = 0
            revertSprint(G.ThePlayer)
        end
        --- Client-side
    else
        if (isSprinting == 1) then
            isSprinting = 0
            SendModRPCToServer(MOD_RPC[modname]["dsiRemoteRevertSprint"], modVersion)
        end

    end
end)

local isSprinting = 0
local initialHungerRate

local function sprint(player)
    player.components.locomotor:SetExternalSpeedMultiplier(player, "speedmeup", GetModConfigData("sprintSpeed"))
    initialHungerRate = player.components.hunger.hungerrate
    player.components.hunger:SetRate(initialHungerRate * GetModConfigData("hungerDrain"))
end

local function revertSprint(player)
    player.components.locomotor:SetExternalSpeedMultiplier(player, "speedmeup", 1.0)
    player.components.hunger:SetRate(initialHungerRate)
end

AddModRPCHandler(modname, "dsiRemoteSprint", function(player, modVersion)
    sprint(player)
end)

AddModRPCHandler(modname, "dsiRemoteRevertSprint", function(player, modVersion)
    revertSprint(player)
end)

--- Press "R" to sprint.
GLOBAL.TheInput:AddKeyDownHandler(114, function()
    if not (GLOBAL.TheFrontEnd:GetActiveScreen() and GLOBAL.TheFrontEnd:GetActiveScreen().name and
        type(GLOBAL.TheFrontEnd:GetActiveScreen().name) == "string" and GLOBAL.TheFrontEnd:GetActiveScreen().name ==
        "HUD") then
        return
    end

    local modVersion = GLOBAL.KnownModIndex:GetModInfo(modname).version

    -- Server-side
    if GLOBAL.TheNet:GetIsServer() then
        print('in main function')
        if (isSprinting == 1) then
            isSprinting = 0
            revertSprint(GLOBAL.ThePlayer)
        else
            isSprinting = 1
            sprint(GLOBAL.ThePlayer)
        end
        -- Client-side
    else
        if (isSprinting == 1) then
            isSprinting = 0
            SendModRPCToServer(MOD_RPC[modname]["dsiRemoteRevertSprint"], modVersion)
        else
            isSprinting = 1
            SendModRPCToServer(MOD_RPC[modname]["dsiRemoteSprint"], modVersion)
        end
    end
end)

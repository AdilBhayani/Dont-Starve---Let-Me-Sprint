local G = GLOBAL
local playerStatus = {}
local hungerThreshold = GetModConfigData("hungerThreshold")
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

local function complainWhenTooHungry(player)
    local currentPlayerStatus = playerStatus[player]
    if currentPlayerStatus.isAbleToComplain == 1 then
        currentPlayerStatus.isAbleToComplain = 0
        player.components.talker:Say("I'm too hungry to sprint")
        player:DoTaskInTime(10, function()
            currentPlayerStatus.isAbleToComplain = 1
        end)
    end
end

checkAndChangeSprint = function(player, isKeyHeldNew)
    local currentPlayerStatus = playerStatus[player]
    if isKeyHeldNew ~= nil then
        currentPlayerStatus.isKeyHeld = isKeyHeldNew
    end
    if currentPlayerStatus.isSprinting == 1 and player.components.hunger:GetPercent() * 100 < hungerThreshold then
        currentPlayerStatus.isSprinting = 0
        revertSprint(player)
        complainWhenTooHungry(player)
    end
    -- print('player, isekeyheld,ismoving,isprinting', player, currentPlayerStatus.isKeyHeld, currentPlayerStatus.isMoving,
    -- currentPlayerStatus.isSprinting)

    -- if currentPlayerStatus and currentPlayerStatus.isSprinting == 1 then
    --     print('is currently sprinting and player, isekeyheld,ismoving,isprinting', player,
    --         currentPlayerStatus.isKeyHeld, currentPlayerStatus.isMoving, currentPlayerStatus.isSprinting)
    -- end
    if currentPlayerStatus and currentPlayerStatus.isKeyHeld == 1 and currentPlayerStatus.isMoving == 1 and
        currentPlayerStatus.isSprinting == 0 then
        -- print('hunger level', player.components.hunger:GetPercent())
        if player.components.hunger:GetPercent() * 100 >= hungerThreshold then
            currentPlayerStatus.isSprinting = 1
            -- print('calling sprint server side')
            sprint(player)
            return
        end
        complainWhenTooHungry(player)
    elseif currentPlayerStatus and (currentPlayerStatus.isKeyHeld == 0 or currentPlayerStatus.isMoving == 0) and
        currentPlayerStatus.isSprinting == 1 then
        -- print(player, 'revertSprint Called')
        currentPlayerStatus.isSprinting = 0
        revertSprint(player)
    end
end

local function onLocomote(player)
    if player.components.locomotor.isrunning then
        playerStatus[player].isMoving = 1
    else
        playerStatus[player].isMoving = 0
    end
    checkAndChangeSprint(player, nil)

end

AddModRPCHandler(modname, "checkAndChangeSprint", checkAndChangeSprint)

AddPlayerPostInit(function(player)
    -- print('player is ', player)
    playerStatus[player] = {
        isKeyHeld = 0,
        isMoving = 0,
        isSprinting = 0,
        isAbleToComplain = 1
    }
    player:ListenForEvent('locomote', onLocomote)
end)

-- Key pressed.
G.TheInput:AddKeyDownHandler(sprintKey, function()
    if not (G.TheFrontEnd:GetActiveScreen() and G.TheFrontEnd:GetActiveScreen().name and
        type(G.TheFrontEnd:GetActiveScreen().name) == "string" and G.TheFrontEnd:GetActiveScreen().name == "HUD") then
        return
    end
    -- print("keydown calling checkAndChangeSprint")
    SendModRPCToServer(MOD_RPC[modname]["checkAndChangeSprint"], 1)
end)

--- Key released.
G.TheInput:AddKeyUpHandler(sprintKey, function()
    if not (G.TheFrontEnd:GetActiveScreen() and G.TheFrontEnd:GetActiveScreen().name and
        type(G.TheFrontEnd:GetActiveScreen().name) == "string" and G.TheFrontEnd:GetActiveScreen().name == "HUD") then
        return
    end
    -- print("keyup calling checkAndChangeSprint")
    SendModRPCToServer(MOD_RPC[modname]["checkAndChangeSprint"], 0)
end)

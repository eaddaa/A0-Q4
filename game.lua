-- Treasure Hunt Game 
-- PID: 2rbLdc2tt7KuPbF1uPm3ZBJNfi1wNv_FVB_aWuqYz1Q
-- Global variable initialization
local flagCaptured = false
local flagLocation = {x = 0, y = 0} -- Coordinates of the treasure
local players = {} -- Table to store player data

-- Credentials and game token
local CRED = "Sa0iBLPNyJQrwpTTG-tWLQU-1QeUAJA73DdxGGiKoJc"
local GAME = "tm1jYBC0F2gTZ0EuUQKq5q_esxITDFkAG6QEpLbpI9I"

colors = { red = "\27[31m", green = "\27[32m",reset = "\27[0m",}

-- Initialize maximum number of players
local maxPlayers = 20

-- Initialize arena size
local arenaWidth = 40 -- Width of the map in units 
local arenaHeight = 40 -- Height of the map in units

-- Initialize player energy
local playerEnergy = 100 -- Maximum energy points for players

-- Initialize bonus cred for the winner
local bonusCredMultiplier = 0.5 -- Multiplier for bonus cred
local totalGameCred = 0 -- Total cred in the game

-- Handler to start the game
local function handleStartGame()
    -- Function to start the game
    local function startGame()
        -- Set initial coordinates of the treasure
        flagLocation.x = math.random(arenaWidth)
        flagLocation.y = math.random(arenaHeight)
        
        -- Assign participants as individuals
        for i = 1, maxPlayers do
            local player = {id = "ao.id", x = math.random(arenaWidth), y = math.random(arenaHeight), energy = playerEnergy}
            table.insert(players, player)
        end
    end
    
    -- Function to transfer cred to start the game
    local function transferCred()
        -- Send command to transfer cred to game
        Send({Target = CRED, Action = "Transfer", Quantity = "10", Recipient = GAME})
    end
    
    -- Check if player has enough cred to start the game
    local function checkPlayerCred()
        -- Assuming the player has enough cred, initiate the transfer and start the game
        transferCred()
        startGame()
        -- Print in green color
        print(colors.green .. "The game has started!" .. colors.reset)
    end

    -- Call function to check player's cred and start the game
    checkPlayerCred()
end

-- Handler to move the player
local function handleMovePlayer(playerID, newX, newY)
    -- Function to move the player
    local function movePlayer(playerID, newX, newY)
        -- Find the player with the matching ID
        for _, player in ipairs(players) do
            if player.id == playerID then
                -- Ensure new coordinates are safe and valid
                if newX >= 0 and newX <= arenaWidth and newY >= 0 and newY <= arenaHeight then
                    player.x = newX
                    player.y = newY
                    -- Deduct energy for moving
                    player.energy = player.energy - 1
                    print("Player " .. playerID .. " moved to (" .. newX .. ", " .. newY .. "). Energy: " .. player.energy)
                else
                    print("New coordinates are not valid for player " .. playerID)
                end
                break
            end
        end
    end
    
    movePlayer(playerID, newX, newY)
end

-- Handler to find the treasure
local function handleFindTreasure(playerID, x, y)
    -- Function to find the treasure
    local function findTreasure(playerID, x, y)
        -- Check if player has reached the treasure location
        if x == flagLocation.x and y == flagLocation.y then
            flagCaptured = true
            print(colors.green .. "Player " .. playerID .. " has found the treasure! Game over." .. colors.reset)
        else
            print("Player " .. playerID .. " is not at the treasure location.")
        end
    end
    
    findTreasure(playerID, x, y)
end

-- Handler to calculate bonus cred for the winner
local function calculateBonusCred()
    local winners = {}
    for _, player in ipairs(players) do
        if player.hasWon then
            table.insert(winners, player)
        end
    end

    if #winners > 0 then
        -- Calculate bonus cred for each winner
        for i, winner in ipairs(winners) do
            if i == 1 then
                -- First winner gets 50% of the total cred in the game
                winner.bonusCred = math.floor(totalGameCred * bonusCredMultiplier)
            end
        end

        -- Print bonus cred for the first winner
        for _, winner in ipairs(winners) do
            print("Player " .. winner.id .. " has won the game and received " .. winner.bonusCred .. " bonus cred!")
            -- Send bonus cred to winner
            Send({Target = GAME, Action = "Transfer", Quantity = tostring(winner.bonusCred), Recipient = winner.id})
        end
    else
        print("No winners in this game.")
    end
end

-- Handler to run the game overall
local function handleMain()
    -- Main game function
    local function main()
        -- Call the handler to start the game
        handleStartGame()

        -- Main game loop
        while not flagCaptured do
            for _, player in ipairs(players) do
                if player.energy > 0 then
                    local newX = math.random(arenaWidth)
                    local newY = math.random(arenaHeight)
                    -- Call the handler to move the player
                    handleMovePlayer(player.id, newX, newY)
                    -- Call the handler to find the treasure
                    handleFindTreasure(player.id, newX, newY)
                    if flagCaptured then
                        break -- Exit the loop if the treasure has been found
                    end
                else
                    print("Player " .. player.id .. " has run out of energy.")
                end
            end
        end

        -- Game over, calculate bonus cred for the winner
        calculateBonusCred()
    end
    
    main()
end

-- Call the handler to run the game overall
handleMain()

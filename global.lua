-- XML helpers
modifiersDetails = {
    ["mod1"] = {guid = "2d85df", selected = "False"},
    ["mod2"] = {guid = "8b81de", selected = "False"},
    ["mod3"] = {guid = "083775", selected = "False"},
    ["mod4"] = {guid = "17ab43", selected = "False"},
    ["mod5"] = {guid = "9d48f7", selected = "False"},
    ["moda"] = {guid = "4ea682", selected = "False"},
    ["modb"] = {guid = "bc05e6", selected = "False"},
    ["modc"] = {guid = "096b00", selected = "False"},
    ["modd"] = {guid = "b4c1e8", selected = "False"},
    ["mode"] = {guid = "f34774", selected = "False"},
}

distress = "False"
taskFlip = "False"
noVariants = "False"
jarvis3 = "False"
publicDiscard = "False"
leaderCorr = "Not Changed"

function areaLabel(obj)
    if obj.getDescription() ~= "" then
        local button = {}
        button.click_function = "nothing"
        button.font_color = {r=30/255, g=30/255, b=30/255}
        button.height = 0
        button.width = 0
        button.label = obj.getName()

        if obj.getName() == "Comm Area" then
            button.font_size = 175
            button.position={0,0.5,-1}
        elseif obj.getName() == "Play Area" then
            button.font_size = 275
            button.position={0,0.5,1.35}
        end
        
        obj.createButton(button)
    end
end
    
function nothing()
end

function onLoad()
    -- Turns
    Turns.enable = false
    Turns.disable_interactations = false
    Turns.pass_turns = false

    -- Objects
    deck = getObjectFromGUID("a6fb25")
    discard = getObjectFromGUID("dde608")
    jarvis = getObjectFromGUID("e629ee")
    manuals = getObjectFromGUID("2c63ad")
    middleman = getObjectFromGUID("49d15b")
    modifiers = getObjectFromGUID("df6ee9")
    secret_discard = getObjectFromGUID("3a9a47")
    task = getObjectFromGUID("4f75e0")

    -- Variables
    -- a4G = "5ba8a2"
    -- commanderG = "ff1c7c"
    -- leaderG = "0e1e99"
    leadSuit = "Not Played"
    playerCount = 0
    areaColor = {r=25/255, g=25/255, b=25/255}
    distressDecks = {"df6ee9","3a9a47","49d15b","e629ee","a6fb25"}

    -- Zones and Polygons
    zone = getObjectFromGUID("e23d86")
    zonePolygon = {{-7.5,0},{-3.75,6.5},{3.75,6.5},{7.5,0},{3.75,-6.5},{-3.75,-6.5}}
    
    -- Player Colors
    gameColors = Player.getAvailableColors()
    fixedColor = {"White","Red","Yellow","Green","Blue"}
    allfixedColor = {"White","Red","Yellow","Green","Blue","JARVIS"}
    allColor = {"White","Red","Yellow","Green","Blue","Grey"}
    
    colorPosition = {
        ["White"] = {polygon = {{-3.75,-6.5},{3.75,-6.5},{7.6,-13.16},{-7.6,-13.16}},
            polygonT = {{0,0},{7.6,-13.16},{-7.6,-13.16}},areas={"1d33f1","bed0cb"},
            color = stringColorToRGB("White"), rotation = {0,180,0}, 
            commander = {0,1.25,-1.75}, leader = {0,1,-1.75}, playCard = {0,1.25,-4.5},
            commCard = {0,1.25,-9.84}, commToken = {0,1,-9.84}, commGUID = "50819f"
        },
        ["Red"] = {polygon = {{-7.5,0},{-3.75,-6.5},{-7.6,-13.16},{-15.2,0}},
            polygonT = {{0,0},{-7.6,-13.16},{-15.2,0}},areas={"2a90b8","e91900"},
            color = stringColorToRGB("Red"), rotation = {0,240,0},
            commander = {-1.52,1.25,-0.88}, leader = {-1.52,1,-0.88}, playCard = {-3.9,1.25,-2.25}, 
            commCard = {-8.52,1.25,-4.92}, commToken = {-8.52,1,-4.92}, commGUID = "e5c4ea"
        },
        ["Yellow"] = {polygon = {{-3.75,6.5},{-7.5,0},{-15.2,0},{-7.6,13.16}},
            polygonT = {{0,0},{-15.2,0},{-7.6,13.16}},areas={"40337c","0a6016"},
            color = stringColorToRGB("Yellow"), rotation = {0,300,0},
            commander = {-1.52,1.25,0.88}, leader = {-1.52,1,0.88}, playCard = {-3.9,1.25,2.25}, 
            commCard = {-8.52,1.25,4.92}, commToken = {-8.52,1,4.92}, commGUID = "5f982c"
        },
        ["Green"] = {polygon = {{3.75,6.5},{-3.75,6.5},{-7.6,13.16},{7.6,13.16}},
            polygonT = {{0,0},{-7.6,13.16},{7.6,13.16}},areas={"f65f5b","1c938a"},
            color = stringColorToRGB("Green"), rotation = {0,360,0},
            commander = {0,1.25,1.75}, leader = {0,1,1.75}, playCard = {0,1.25,4.5},
            commCard = {0,1.25,9.84}, commToken = {0,1,9.84}, commGUID = "7998ea"
        },
        ["Blue"] = {polygon = {{7.6,0},{3.75,6.5},{7.6,13.16},{15.2,0}},
            polygonT = {{0,0},{7.6,13.16},{15.2,0}},areas={"cfbb16","0f008f"},
            color = stringColorToRGB("Blue"), rotation = {0,60,0},
            commander = {1.52,1.25,0.88}, leader = {1.52,1,0.88}, playCard = {3.9,1.25,2.25}, 
            commCard = {8.52,1.25,4.92}, commToken = {8.52,1,4.92}, commGUID = "cadec8"
        },
        ["JARVIS"] = {polygon = {{-3.75,6.5},{-7.5,0},{-3.75,-6.5},{-7.6,-13.16},{-15.2,0},{-7.6,13.16}},
            polygonT = {{0,0},{-7.6,-13.16},{-15.2,0},{-7.6,13.16}},areas={"2a90b8","e91900","40337c","0a6016"},
            color = stringColorToRGB("Teal"), rotation = {0,180,0},
            commander = {-1.75,1.25,0}, leader = {-1.75,1,0}, playCard = {-3.8,1.25,0}, 
            commCard = {8.52,1.25,4.92}, commToken = {8.52,1,4.92}, commGUID = "cadec8"
        },
        ["Dealer"] = {polygon = {{3.75,-6.5},{7.5,0},{15.2,0},{7.6,-13.16}},
            polygonT = {{0,0},{20,0},{10,-17.32}},areas={"e0f497","6a481a"},
            color = stringColorToRGB("Black"), rotation = {0,120,0},
            commander = {1.52,1.25,-0.88}, leader = {1.52,1,-0.88}, playCard = {3.9,1.25,-2.25}, 
            commCard = {8.52,1.25,-4.92}, commToken = {8.52,1,-4.92}, commGUID = "cadec8"
        },
    }

    -- Put Comm Tokens back out
    for i,v in pairs(fixedColor) do
        local token = getObjectFromGUID(colorPosition[v].commGUID)
        token.setPosition(colorPosition[v].commToken)
        token.setRotation(colorPosition[v].rotation)
    end

    -- Make sure counters at 0
    for v in pairs(colorPosition) do
        Global.UI.setAttribute(v.."Tricks", "text", "0")
        Global.UI.setAttribute(v.."Player", "text", v)
    end

    -- Reset discard display
    Global.UI.hide("showDiscards")
    for num = 1,9 do
        if num <= 4 then
            Global.UI.setAttribute("A"..num.."Discard", "color", "#cccccc")
        end
        Global.UI.setAttribute("Z"..num.."Discard", "color", "blue")
        Global.UI.setAttribute("Y"..num.."Discard", "color", "yellow")
        Global.UI.setAttribute("G"..num.."Discard", "color", "green")
        Global.UI.setAttribute("P"..num.."Discard", "color", "pink")
    end

    -- Make sure areas renamed
    for v in pairs(colorPosition) do
        if inTable(fixedColor, v) or v == "Dealer" then
            for j,k in pairs(colorPosition[v].areas) do
                getObjectFromGUID(k).setDescription(v)
                getObjectFromGUID(k).setColorTint(areaColor)
            end
        end
    end

    shown = {}

    -- Locations
    jarvisLocations = {
        {position={-8.2,1,6}, rotation={0,180,180}},
        {position={-8.1,2,6.1}, rotation={0,180,0}},
        {position={-8.2,1,0}, rotation={0,180,180}},
        {position={-8.1,2,0.1}, rotation={0,180,0}},
        {position={-8.2,1,-6}, rotation={0,180,180}},
        {position={-8.1,2,-5.9}, rotation={0,180,0}},
        {position={-11,1,3}, rotation={0,180,180}},
        {position={-10.9,2,3.1}, rotation={0,180,0}},
        {position={-11,1,-3}, rotation={0,180,180}},
        {position={-10.9,2,-2.9}, rotation={0,180,0}},
    }

    jarvisLocationsNV = {
        {position={-8.2,1,8}, rotation={0,180,180}},
        {position={-8.1,2,8.1}, rotation={0,180,0}},
        {position={-8.2,1,3}, rotation={0,180,180}},
        {position={-8.1,2,3.1}, rotation={0,180,0}},
        {position={-8.2,1,-3}, rotation={0,180,180}},
        {position={-8.1,2,-2.9}, rotation={0,180,0}},
        {position={-8.2,1,-8}, rotation={0,180,180}},
        {position={-8.1,2,-7.9}, rotation={0,180,0}},
        {position={-11,1,3}, rotation={0,180,180}},
        {position={-10.9,2,3.1}, rotation={0,180,0}},
        {position={-11,1,-3}, rotation={0,180,180}},
        {position={-10.9,2,-2.9}, rotation={0,180,0}},
        {position={-14,1,0}, rotation={0,180,180}},
        {position={-13.9,2,0.1}, rotation={0,180,0}},
    }

    taskLocations = {
        {position={6.71,1,-3.88}, rotation={0,120,0}},
        {position={7.26,1,-5.92}, rotation={0,120,0}},
        {position={8.76,1,-3.33}, rotation={0,120,0}},
        {position={7.81,1,-7.97}, rotation={0,120,0}},
        {position={9.31,1,-5.38}, rotation={0,120,0}},
        {position={10.81,1,-2.78}, rotation={0,120,0}},
        {position={8.36,1,-10.02}, rotation={0,120,0}},
        {position={9.86,1,-7.42}, rotation={0,120,0}},
        {position={11.36,1,-4.83}, rotation={0,120,0}},
        {position={12.86,1,-2.23}, rotation={0,120,0}},
    }

    modifierLocations = {
        {position={6.1,1.25,-4.04}, rotation={0,120,0}},
        {position={6.65,1.25,-6.09}, rotation={0,120,0}},
        {position={8.15,1.25,-3.49}, rotation={0,120,0}},
        {position={7.2,1.25,-8.14}, rotation={0,120,0}},
        {position={8.7,1.25,-5.54}, rotation={0,120,0}},
        {position={10.2,1.25,-2.94}, rotation={0,120,0}},
        {position={7.74,1.25,-10.19}, rotation={0,120,0}},
        {position={9.24,1.25,-7.59}, rotation={0,120,0}},
        {position={10.74,1.25,-4.99}, rotation={0,120,0}},
        {position={12.24,1.25,-2.39}, rotation={0,120,0}},
    }

    commNU = {
        {9,1,-8.75},
        {10.5,1,-6},
        {12,1,-3.5},
    }

    -- Hide objects before start and disable table parts
    for i,v in pairs(getAllObjects()) do
        if v.getName() == "Manuals" or v.getName() == "Logbook Quick Reference" or v.getName():find("Area") or v.getName():find("book") then
        else
            v.setInvisibleTo(allColor)
        end
        if v.getName():find("Area") then
            v.interactable = false
            areaLabel(v)
        end
    end
end

-- Menu buttons
function showButtons(player, value, id)
    if shown.buttons == false then
       Global.UI.show("buttons")
       shown.buttons = true
       Global.UI.setAttribute("showButtons", "text", "▲")
    else
       Global.UI.hide("buttons")
       shown.buttons = false
       Global.UI.setAttribute("showButtons", "text", "▼")
    end
end

-- Showing submenus (Game + Trick Count)
function showForPlayer(params)
    local panel = params.panel
    local color = params.color
    local opened = Global.UI.getAttribute(panel, "visibility")
    if opened == nil then opened = "" end
 
    if opened:find(color) then
       opened = opened:gsub("|" .. color, "")
       opened = opened:gsub(color .. "|", "")
       opened = opened:gsub(color, "")
       Global.UI.setAttribute(panel, "visibility", opened)
       if opened == "" then
          Global.UI.setAttribute(panel, "active", "false")
          shown[panel] = false
       end
    else
       if shown[panel] ~= true then
          Global.UI.setAttribute(panel, "active", "true")
          Global.UI.setAttribute(panel, "visibility", color)
          shown[panel] = true
       else
          Global.UI.setAttribute(panel, "visibility", opened .. "|" .. color)
       end
    end
end

-- Modifier toggles
function toggleClicked(player, value, id)
    modifiersDetails[id].selected = value
end

-- Task flip
function taskFlipClicked(player, value, id)
    if id == "taskFlip" then
        taskFlip = value
    end
end

-- Variant flip
function noVariantsClicked(player, value, id)
    if id == "noVariants" then
        noVariants = value
    end
end

-- Jarvis3 flip
function jarvis3Clicked(player, value, id)
    if id == "jarvis3" then
        jarvis3 = value
    end
end

-- PublicDiscard flip
function publicDiscardClicked(player, value, id)
    if id == "publicDiscard" then
        publicDiscard = value
    end
end

-- Satelitte Distress
function distressClicked(player, value, id)
    if id == "distress" then
        distress = value
        if distress == "True" then
            broadcastToAll(Player[player.color].steam_name.." enabled satellite distress. Minimal scripting now enabled. Secret decks are visible below the table. Disable to return back to normal functionality.")
        else
            broadcastToAll("Normal functionality returned")
        end
        for i,v in pairs(distressDecks) do
            if distress == "True" then
                getObjectFromGUID(v).setInvisibleTo({})
            else
                getObjectFromGUID(v).setInvisibleTo(allColor)
            end
        end
    end
end

-- Open Game Setup
function gameClicked(player, value, id)
    if id == "showGame" then
        showForPlayer({panel = "Game", color = player.color})
    end
end

-- Update slider total
function updateSliderValue(player, value, id)
    if id == "taskSlider" then
        Global.UI.setAttribute("taskSlider", "value", value)
        Global.UI.setAttribute("taskTitle", "text", "Task Count = " .. value)
    end
end

-- Open Trick Counter
function trickClicked(player, value, id)
    if id == "showTrick" then
        showForPlayer({panel = "Trick", color = player.color})
    end
end

-- Open Leader Correction
function leaderClicked(player, value, id)
    if id == "showLeader" then
        showForPlayer({panel = "Leader", color = player.color})
    end
end

-- Open Discards display
function discardClicked(player, value, id)
    if id == "showDiscards" then
        showForPlayer({panel = "Discard", color = player.color})
    end
end

function dropdownChanged(player, value, id)
    leaderCorr = value
end
-- Fix Leader
function leaderCorrClicked(player, value, id)
    Global.UI.setAttribute("newLeader","value","Select Seat")
    if deck.getQuantity() == 0 and colorPosition[leaderCorr] then
        assignLeader(leaderCorr)
    end
    Global.UI.setAttribute("Leader", "active", "false")
end

function gameSetup()
    local nu = 1
    if playerCount == 2 then
        for i,v in pairs(seatedColors) do
            if Player[v].host then
                Player[v].changeColor("White")
            else
                Player[v].changeColor("Green")
            end
        end
        
        seatedColors = getSeatedPlayers()
        for j,k in pairs(colorPosition["JARVIS"].areas) do
            getObjectFromGUID(k).setDescription("JARVIS")
        end
    end

    if playerCount==3 and jarvis3=="True" then
        for i,v in pairs(seatedColors) do
            if Player[v].host then
                Player[v].changeColor("White")
            elseif not Player["Green"].seated then
                Player[v].changeColor("Green")
            elseif not Player["Blue"].seated then
                Player[v].changeColor("Blue")
            end
        end
        
        seatedColors = getSeatedPlayers()
        for j,k in pairs(colorPosition["JARVIS"].areas) do
            getObjectFromGUID(k).setDescription("JARVIS")
        end
    end
    
    if playerCount > 3 or noVariants == "True" or (playerCount==3 and jarvis3=="True") then
        for i,v in pairs(secret_discard.getObjects()) do
            if v.description == "Playing Card" then
                deck.putObject(secret_discard.takeObject(v))
            elseif v.description == "Task Card" then
                task.putObject(secret_discard.takeObject(v))
            end
        end
    else
        Global.UI.setAttribute("A1Discard", "color", "#444444")
        for num = 1,9 do
            Global.UI.setAttribute("Z"..num.."Discard", "color", "#444444")
        end
    end

    for v in pairs(colorPosition) do
        if inTable(seatedColors, v) or (v=="JARVIS" and (playerCount == 2 or (playerCount==3 and jarvis3=="True"))) or v=="Dealer" then
        else
            colorPosition[v] = nil
        end
    end
    
    for i,v in pairs(getAllObjects()) do
        if v.getName() == "Discard Pile" or v.getName() == "Task Cards" or (v.getName() == "Comm Token" and inTable(seatedColors, v.getDescription())) then
            v.setInvisibleTo({})
        elseif v.getName() == "Comm Token" and not(inTable(seatedColors, v.getDescription())) then
            -- secret_discard.putObject(v)
            v.setPosition(commNU[nu])
            nu = nu + 1
        end        
    end

    deck.shuffle()
    task.shuffle()
    ::done::
end

function dealCards()
    if (playerCount == 2 or (playerCount==3 and jarvis3=="True")) and deck.getQuantity() > 0 then
        for i,v in pairs(deck.getObjects()) do
            if v.name ~= "A4" then
                local noob = deck.takeObject(v)
                noob.setDescription("JARVIS")
                jarvis.putObject(noob)
            end
            local jl = 0
            if noVariants == "True" and playerCount == 2 then
                jl = 14
            else
                jl = 10
            end
            if jarvis.getQuantity() == jl then
                break
            end
        end

        broadcastToAll("You are in JARVIS Player mode. Manually control JARVIS and trick resolution.")
    end

    while(deck.getQuantity()>0) do
        for i,v in pairs(seatedColors) do
            deck.deal(1, v)
        end
        if deck.getQuantity() == 0 then
            Wait.time(sortCardsAll, 1)
            Wait.time(getTopCard, 1)
            Wait.time(assignCommander, 1)
            Wait.time(function() assignLeader(getTopCard()) end, 1)
            if playerCount == 2 or (playerCount==3 and jarvis3=="True") then
                Wait.time(dealJ, 1)
            end
        end
    end
end

function dealTasks()
    local m = 1
    local ti = tonumber(Global.UI.getAttribute("taskSlider", "value"))
    for j,k in pairs(modifiers.getObjects()) do
        if modifiersDetails[k.description].selected == "True" then
            modifiers.takeObject({guid=k.guid, position=modifierLocations[m].position, rotation=modifierLocations[m].rotation})
            m = m + 1
        else
            middleman.putObject(modifiers.takeObject(k))
        end
    end
    for i = 1, ti do
        local tP = taskLocations[i].position
        if taskFlip == "True" then
            task.takeObject({position=tP, rotation={0, 120, 180}})
        else
            task.takeObject(taskLocations[i])
        end
    end
end

-- Start Game
function startGameClicked(player, value, id)
    local playerColor = player.color
    seatedColors = getSeatedPlayers()
    -- Counts
    playerCount = #seatedColors

    if playerCount < 2 then
        broadcastToAll("You need at least 2 players!")
        goto done
    end

    if playerCount > 2 and not(playerCount==3 and jarvis3=="True") then
        for i,v in pairs(seatedColors) do
            if not(inTable(fixedColor, v)) then
                broadcastToAll("Player in wrong colored seat!")
                goto done
            end
        end
    end

    if (Player[playerColor].host or Player[playerColor].promoted) and deck.getQuantity() == #deck.getObjects() and deck.getQuantity() > 0 then
        gameSetup()
        dealTasks()
        dealCards()
        showForPlayer({panel = "Game", color = player.color})

        if publicDiscard == "True" then
            Global.UI.show("showDiscards")
        else
            Global.UI.hide("showDiscards")
            -- Hide any open Discards panels
            shown["Discard"] = false
            Global.UI.setAttribute("Discard", "active", "false")
            Global.UI.setAttribute("Discard", "visibility", "|")
        end

        for i, v in pairs(allfixedColor) do
            if (playerCount == 2 or (playerCount==3 and jarvis3=="True")) and v == "JARVIS" then
                Global.UI.setAttribute("JARVISPlayer", "text", "JARVIS")
            elseif colorPosition[v] then
                Global.UI.setAttribute(v.."Player", "text", Player[v].steam_name)
            else
                Global.UI.setAttribute(v.."Player", "text", "EMPTY")
            end
        end

        local cardCounts = {}
        for i,v in pairs(getAllObjects()) do
            if colorPosition[v.getDescription()] and string.len(v.getName()) == 2 then
                if cardCounts[v.getName()] == nil then
                    cardCounts[v.getName()] = true
                else
                    broadcastToAll("There seems to be an issue with card "..v.getName().."!", "Red")
                    goto done
                end
            end
        end
    elseif (Player[playerColor].host or Player[playerColor].promoted) and deck.getQuantity() == 0 then
        broadcastToColor("The game has already started.", playerColor)
    else
        broadcastToColor("Only the host or promoted players can start the game!", playerColor)
    end
    ::done::
end



function inTable(tbl, item)
    for key, value in pairs(tbl) do
        if value == item then return true end
    end
    return false
end

function inPoly(poly, obj)
    local inside = false
    local p1x = poly[1][1]
    local p1y = poly[1][2]
    local x = obj.getPosition().x
    local y = obj.getPosition().z

    for i=0,#poly do

        local p2x = poly[((i)%#poly)+1][1]
        local p2y = poly[((i)%#poly)+1][2]

        if y > math.min(p1y,p2y) then
            if y <= math.max(p1y,p2y) then
                if x <= math.max(p1x,p2x) then
                    if p1y ~= p2y then
                        xinters = (y-p1y)*(p2x-p1x)/(p2y-p1y)+p1x
                    end
                    if p1x == p2x or x <= xinters then
                        inside = not inside
                    end
                end
            end
        end
        p1x,p1y = p2x,p2y	
    end
    return inside
end

function otherColors(color)
    local c = {}
    for i,v in pairs(fixedColor) do
        if v ~= color then
            table.insert(c, v)
        end
    end
    return c
end

function randomize(t)
    for i = 1, #t*2 do
        local a = math.random(#t)
        local b = math.random(#t)
        t[a],t[b] = t[b],t[a]
    end 
    return t
end

function sortCards(playerColor)
    -- Sort cards by random suit order
    local cards = {}
    local handPos = {}
    local t = {"A","G","P","Y","Z"}
    local o = {1,2}
    
    -- Get player"s hand
    local handObjects = Player[playerColor].getHandObjects()
    local randSuit = randomize(t)
    local randOrder = randomize(o)[1]
    
    -- One table stores card names, the other position
    for j, k in pairs(handObjects) do
        table.insert(handPos, k.getPosition())
        for x, y in pairs(randSuit) do
            if y == k.getName():sub(1, 1) then
                table.insert(cards, {card=k, ind=x, dir=randOrder,name=k.getName()})
            end
        end
    end
        
    -- Reorder names while retaining original positions
    table.sort(cards, function(a, b) 
        if a.ind ~= b.ind then 
            return a.ind < b.ind 
        end
        if a.dir == 1 then
            return a.name < b.name 
        else
            return a.name > b.name
        end
    end)
    
    -- Reset position of re-ordered cards
    for i, j in pairs(cards) do
        j.card.setPosition(handPos[i])
        if j.card.getDescription() ~= "Reminder" then
            j.card.setDescription(playerColor)
        end
    end
end

function sortCardsAll()
    for i,v in pairs(seatedColors) do
        sortCards(v)
    end
end

function sortCardsButton(player, value, id)
    sortCards(player.color)
end

function getTopCard()
    local a4 = nil
    for i,v in pairs(getAllObjects()) do
        if v.getName()=="A4" then
            a4 = v
        end
    end
    -- getObjectFromGUID(a4G)
    local a4_holder = a4.getDescription()
    return a4_holder
end

function assignCommander()
    local a4_holder = getTopCard()
    -- Commander Variables
    local commanderColor = colorPosition[a4_holder].color
    local commanderPosition = colorPosition[a4_holder].commander
    local commanderRotation = colorPosition[a4_holder].rotation
    
    -- Commander Properties
    commander = nil
    for i,v in pairs(secret_discard.getObjects()) do
        if v.name == "Commander" then
            commander = secret_discard.takeObject({guid=v.guid})
        end
    end
    Wait.condition(
        function()
            commander.setDescription(a4_holder);
            commander.setPositionSmooth(commanderPosition, false, false);
            commander.setRotationSmooth(commanderRotation, false, false);
            commander.setLock(true);
            commander.setColorTint(commanderColor);
        end,
        function()
            return not commander.spawning
        end
    )
    

    --Broadcast who the Commander is
    broadcastToAll(Player[a4_holder].steam_name .. " is the commander!")
end

function assignLeader(var)
    leader = nil
    local leaderOut = nil
    local leaderStart = nil
    for i,v in pairs(getAllObjects()) do
        if v.getName()=="Leader" then
            leaderOut = v
        end
    end
    for i,v in pairs(secret_discard.getObjects()) do
        if v.name == "Leader" then
            leaderStart = secret_discard.takeObject({guid=v.guid})
        end
    end
    leader = leaderOut or leaderStart
    -- Leader Variables
    local leaderColor = colorPosition[var].color
    local leaderPosition = colorPosition[var].leader
    local leaderRotation = colorPosition[var].rotation
    leadSuit = "Not Played"
    
    -- Leader Properties
    Wait.condition(
        function()
            leader.setDescription(var);
            leader.setPositionSmooth(leaderPosition, false, false);
            leader.setRotationSmooth(leaderRotation, false, false);
            leader.setLock(true);
            leader.setColorTint(leaderColor);
        end,
        function()
            return not leader.spawning
        end
    )

    -- Broadcast who the Leader is and change turn
    if var == "JARVIS" then 
        broadcastToAll("JARVIS leads this trick!")
    else
        broadcastToAll(Player[var].steam_name .. " leads this trick!")
    end
end

function dealJ()
    local jl = jarvisLocations
    if noVariants == "True" and playerCount==2 then
        jl = jarvisLocationsNV
    end
    for i,v in pairs(jl) do 
        jarvis.takeObject(v)
    end
end

function getAllObj()
    local allObjects = getAllObjects()
    
    local zoneObjects = {}
    for i,v in pairs(allObjects) do
        if inPoly(zonePolygon, v) and colorPosition[v.getDescription()] and string.len(v.getName()) == 2 and not(v.getName():find("Area")) then
            table.insert(zoneObjects, v)
        end
    end

    local handObjects = {}
    for i,v in pairs(seatedColors) do
        for j, k in pairs(Player[v].getHandObjects()) do
            if (colorPosition[k.getDescription()] or k.getDescription() == "Reminder") and string.len(k.getName()) == 2 then
                table.insert(handObjects, k)
            end
        end
    end

    local otherObjects = {}
    for i,v in pairs(allObjects) do
        if colorPosition[v.getDescription()] and string.len(v.getName()) == 2 then
            if not(inTable(handObjects, v) or inTable(zoneObjects, v)) then
                table.insert(otherObjects, v)
            end
        end
    end

    local objects = {
        all = allObjects,
        zone = zoneObjects,
        hand = handObjects,
        other = otherObjects
    }

    return objects
end

function checkCount(table, playerColor)
    local count = 0

    for i,v in pairs(table) do
        if playerColor == v.getDescription() and string.len(v.getName()) == 2 then
            count = count + 1
        end
    end
    return count
end

function checkSuitCount(playerColorC, objectsVar)
    local count = 0

    for i,v in pairs(objectsVar.all) do
        if playerColorC == v.getDescription() and not(inTable(objectsVar.zone, v)) and leadSuit == string.sub(v.getName(),1,1) and string.len(v.getName()) == 2 then
            count = count + 1
        end
    end
    return count
end

function discardReminder(obj, objectsVar)
    local commToken = getObjectFromGUID(colorPosition[obj.getDescription()].commGUID)
    for i,v in pairs(objectsVar.hand) do
        if obj.getName() == v.getName() and v.getDescription() == "Reminder" then
            secret_discard.putObject(v)
            if commToken then
                commToken.setPositionSmooth(colorPosition[obj.getDescription()].commToken, false, false)
                commToken.setRotationSmooth(colorPosition[obj.getDescription()].rotation, false, false)
            end
            break
        end
    end
end

function discardReminderZone(obj, objectsVar)
    local commToken = getObjectFromGUID(colorPosition[obj.getDescription()].commGUID)
    for i,v in pairs(objectsVar.hand) do
        if obj.getName() == v.getName() and v.getDescription() == "Reminder" then
            secret_discard.putObject(v)
            if commToken then
                commToken.setPositionSmooth(colorPosition[obj.getDescription()].commToken, false, false)
                commToken.setRotationSmooth({0,0,180}, false, false)
            end
            break
        end
    end
end

function onObjectPickedUp(playerColor, obj)
    local cardOwnerP = obj.getDescription()
    local cardNameP = obj.getName()
    local cardSuitP = string.sub(cardNameP,1,1)
    local cardNumberP = tonumber(string.sub(cardNameP,2,2))

    if (colorPosition[cardOwnerP] or cardOwnerP == "Reminder")
    and string.len(cardNameP) == 2 
    and deck.getQuantity() == 0
    and (distress == "True" or cardOwnerP == "JARVIS") then
        local objectsP = getAllObj()
        obj.setHiddenFrom(otherColors(playerColor))
        -- Color areas
        for i,v in pairs(objectsP.all) do
            if v.getName() == "Play Area" and cardOwnerP == v.getDescription() 
            and checkCount(objectsP.zone, cardOwnerP) == 0 
            and (leadSuit ~= "Not Played" or cardOwnerP == leader.getDescription()) then
                v.setColorTint(colorPosition[cardOwnerP].color)
            end
            if v.getName() == "Comm Area" and cardOwnerP == v.getDescription() 
            and (checkCount(objectsP.other, cardOwnerP) == 0 or (inTable(objectsP.other, obj) and checkCount(objectsP.other, cardOwnerP) == 1)) and #objectsP.zone == 0 
            then
                v.setColorTint(colorPosition[cardOwnerP].color)
            end
        end
    elseif (colorPosition[cardOwnerP] or cardOwnerP == "Reminder")
    and string.len(cardNameP) == 2 
    and deck.getQuantity() == 0
    and distress == "False" then
        local objectsP = getAllObj()
        local problem_count = 0

        local commToken = getObjectFromGUID(colorPosition[playerColor].commGUID)
        local comm_flip = 0

        if commToken then
            comm_flip = tonumber(string.format("%.0f",commToken.getRotation().z))
        else
            comm_flip = 0
        end

        -- Player tried to get someone else"s card
        if playerColor ~= cardOwnerP and colorPosition[cardOwnerP] then
            problem_count = problem_count + 1
            broadcastToColor("That's not your card! Enable satellite distress if you need to take a card from another player.", playerColor)
        end

        -- Player tried to get reminder card
        if cardOwnerP == "Reminder" and inTable(objectsP.hand, obj) then
            problem_count = problem_count + 1
            broadcastToColor("This is a reminder card! Check the table for the actual card!", playerColor)
        end

        -- Player tried to play but already played
        if checkCount(objectsP.zone, cardOwnerP) > 0 and not(inTable(objectsP.zone, obj)) then
            problem_count = problem_count + 1
            broadcastToColor("You played a card to the center already! Take back your card to play another card.", playerColor)
        end

        -- Player tried to play a wrong suit
        if checkSuitCount(cardOwnerP, objectsP) > 0 and not(inTable(objectsP.zone, obj)) and cardSuitP ~= leadSuit then
            problem_count = problem_count + 1
            broadcastToColor("Wrong suit!", playerColor)
        end

        -- Lock card if there"s a problem
        if problem_count > 0 then
            obj.Drop()
            obj.setLock(true)
            Wait.time(|| obj.SetLock(false), 1)
        else
            obj.setHiddenFrom(otherColors(playerColor))
        end

        -- Color areas
        if problem_count == 0 then
            for i,v in pairs(objectsP.all) do
                if v.getName() == "Play Area" and cardOwnerP == v.getDescription() 
                and checkCount(objectsP.zone, cardOwnerP) == 0 
                and (leadSuit ~= "Not Played" or cardOwnerP == leader.getDescription()) then
                    v.setColorTint(colorPosition[cardOwnerP].color)
                end
                if v.getName() == "Comm Area" and cardOwnerP == v.getDescription() 
                and (checkCount(objectsP.other, cardOwnerP) == 0 or (inTable(objectsP.other, obj) and checkCount(objectsP.other, cardOwnerP) == 1)) and #objectsP.zone == 0 and comm_flip == 0
                -- and cardSuitP ~= "A"
                then
                    v.setColorTint(colorPosition[cardOwnerP].color)
                end
            end
        end
    elseif cardOwnerP == "Task Card" or cardNameP:find("Modifier") or (cardNameP == "Comm Token" and cardOwnerP == playerColor) then
        if deck.getQuantity() == #deck.getObjects() and deck.getQuantity() > 0 then
        else
            local objectsP = getAllObj()
            for i,v in pairs(objectsP.all) do
                if playerColor == v.getDescription() and v.getName():find("Area") then
                    v.highlightOn(colorPosition[playerColor].color,2)
                end
                if (playerCount == 2 or (playerCount==3 and jarvis3=="True")) and playerColor == commander.getDescription() and cardNameP ~= "Comm Token" and v.getDescription() == "JARVIS" and v.getName():find("Area") then
                    v.highlightOn(colorPosition["JARVIS"].color,2)
                end
            end
        end
    end
end

function onObjectDrop(playerColor, obj)
    local cardOwnerD = obj.getDescription()
    local cardNameD = obj.getName()
    local cardSuitD = string.sub(cardNameD,1,1)
    local cardNumberD = tonumber(string.sub(cardNameD,2,2))

    if colorPosition[cardOwnerD]
    and string.len(cardNameD) == 2 
    and deck.getQuantity() == 0
    and (distress == "True" or cardOwnerD == "JARVIS") then
        local objectsD = getAllObj()
        local winningOwner = getWinner(objectsD)
        -- Switching cards with JARVIS
        if colorPosition["JARVIS"] and inPoly(colorPosition["JARVIS"].polygon, obj) and (playerCount == 2 or (playerCount==3 and jarvis3=="True")) and playerColor == cardOwnerD then
            obj.setDescription("JARVIS")
            obj.setRotationSmooth(colorPosition["JARVIS"].rotation, false, false)
            obj.setHiddenFrom({})
            discardReminder(obj, objectsD)
        -- Allow player to pass their own card
        elseif inTable(objectsD.hand, obj) and not(inTable(Player[playerColor].getHandObjects(), obj)) and playerColor == cardOwnerD then
            for i,v in pairs(seatedColors) do
                if inTable(Player[v].getHandObjects(), obj) and v ~= cardOwnerD then
                    obj.setDescription(v)
                    obj.setHiddenFrom(otherColors(v))
                    discardReminder(obj, objectsD)
                    break
                end
            end
        -- If the distress signal is enabled, switch ownership to player taking card (taking from another player)
        elseif (inTable(Player[playerColor].getHandObjects(), obj) or inPoly(colorPosition[playerColor].polygon, obj)) and playerColor ~= cardOwnerD then
            obj.setDescription(playerColor)
            discardReminder(obj, objectsD)
        -- Drop in zone
        elseif inPoly(zonePolygon, obj) then
            obj.setPositionSmooth(colorPosition[cardOwnerD].playCard, false, false)
            obj.setRotationSmooth(colorPosition[cardOwnerD].rotation, false, false)
            obj.setHiddenFrom({})
            discardReminderZone(obj, objectsD)
            if leader.getDescription() == cardOwnerD then
                leadSuit = cardSuitD
            end
        -- In hand
        elseif inTable(Player[playerColor].getHandObjects(), obj) and playerColor == cardOwnerD then
            discardReminder(obj, objectsD)
        -- If dropped into comm
        elseif playerColor == cardOwnerD or cardOwnerD == "JARVIS" then
            obj.setRotationSmooth(colorPosition[playerColor].rotation, false, false)
            obj.setHiddenFrom({})
        end

        -- Change color back to normal
        for i,v in pairs(objectsD.all) do
            if v.getName() == "Play Area" and v.getDescription() == "" and colorPosition[winningOwner] then
                v.setColorTint(colorPosition[winningOwner].color)
            end            
            if (v.getName() == "Play Area" or v.getName() == "Comm Area") and v.getDescription() ~= ""
            then
                v.setColorTint(areaColor)
                if v.getDescription() == winningOwner and v.getName() == "Play Area" and colorPosition[winningOwner] then
                    v.highlightOn(colorPosition[winningOwner].color,2)
                end
            end
        end
    elseif colorPosition[cardOwnerD]
    and string.len(cardNameD) == 2 
    and deck.getQuantity() == 0
    and distress == "False" then
    
        local objectsD = getAllObj()
        local winningOwner = getWinner(objectsD)
        local commToken = getObjectFromGUID(colorPosition[cardOwnerD].commGUID)
        local comm_flip = 0

        if commToken then
            comm_flip = tonumber(string.format("%.0f",commToken.getRotation().z))
        else
            comm_flip = 0
        end

        local problem_count = 0
    
        -- Player tried to play a card outside their allowed space
        if not(inPoly(colorPosition[cardOwnerD].polygon, obj) or inTable(objectsD.zone, obj) or inTable(objectsD.hand, obj)) then
            problem_count = problem_count + 1
            broadcastToColor("You can only place a card within your designated play area! Enable satelitte distress if you want to play elesewhere.", playerColor)
        end

        -- Player tried to pass a card without the distress signal flipped
        if inTable(objectsD.hand, obj) and not(inTable(Player[cardOwnerD].getHandObjects(), obj)) then
            problem_count = problem_count + 1
            broadcastToColor("To pass a card, you must enable satelitte distress!", playerColor)
        end

        -- Player tried to communicate a rocket
        if inTable(objectsD.other, obj) and cardSuitD == "A" then
            problem_count = problem_count + 1
            broadcastToColor("You cannot communicate a Rocket!", playerColor)
        end

        -- Player tried to communicate after cards were played
        if #objectsD.zone > 0 and inTable(objectsD.other, obj) then
            problem_count = problem_count + 1
            broadcastToColor("No communication after a trick has been started!", playerColor)
        end

        -- Player tried to communicate more than once
        if (checkCount(objectsD.other, cardOwnerD) > 1) or (checkCount(objectsD.other, cardOwnerD) > 0 and comm_flip == 180)  then
            problem_count = problem_count + 1
            broadcastToColor("You already communicated! Flip your Comm Token if this is a mistake.", playerColor)
        end

        -- Player tried to play before the leader
        if leadSuit == "Not Played" and inTable(objectsD.zone, obj) and cardOwnerD ~= leader.getDescription() then
            problem_count = problem_count + 1
            broadcastToColor("Leader has not played!", playerColor)
        end

        -- Send back if there"s a problem
        if problem_count > 0 then
            obj.deal(1, cardOwnerD)
            discardReminder(obj, objectsD)
         -- If dropped into hand
        elseif inTable(Player[cardOwnerD].getHandObjects(), obj) then
            discardReminder(obj, objectsD)
        -- If dropped into zone
        elseif inTable(objectsD.zone, obj) then
            obj.setPositionSmooth(colorPosition[cardOwnerD].playCard, false, false)
            obj.setRotationSmooth(colorPosition[cardOwnerD].rotation, false, false)
            obj.setHiddenFrom({})
            discardReminderZone(obj, objectsD)
            if leader.getDescription() == cardOwnerD then
                leadSuit = cardSuitD
            end
        -- If dropped into comm
        elseif inTable(objectsD.other, obj) then
            obj.setRotationSmooth(colorPosition[cardOwnerD].rotation, false, false)
            obj.setHiddenFrom({})
            -- Reminder card sent when Comm Token hits the card. Physics!!!
        end

        -- Change color back to normal
        for i,v in pairs(objectsD.all) do
            if v.getName() == "Play Area" and v.getDescription() == "" and colorPosition[winningOwner] then
                v.setColorTint(colorPosition[winningOwner].color)
            end            
            if (v.getName() == "Play Area" or v.getName() == "Comm Area") and v.getDescription() ~= ""
            then
                v.setColorTint(areaColor)
                if v.getDescription() == winningOwner and v.getName() == "Play Area" and colorPosition[winningOwner] then
                    v.highlightOn(colorPosition[winningOwner].color,2)
                end
            end
        end
        
    elseif (cardOwnerD == "Task Card" or cardNameD:find("Modifier")) then
        if deck.getQuantity() == #deck.getObjects() and deck.getQuantity() > 0 then
        else
            for color in pairs(colorPosition) do
                if inPoly(colorPosition[color].polygonT, obj) then
                    obj.setRotationSmooth(colorPosition[color].rotation, false, false)
                    obj.highlightOn(colorPosition[color].color,5)
                    break
                end
            end
        end
    elseif cardNameD == "Comm Token" and colorPosition[cardOwnerD] and not(inPoly(colorPosition[cardOwnerD].polygonT, obj)) then
        obj.setPositionSmooth(colorPosition[cardOwnerD].commToken, false, false)
    end
end

function onObjectLeaveScriptingZone(zone, obj)
    local cardOwnerZL = obj.getDescription()
    local cardNameZL = obj.getName()
    local cardSuitZL = string.sub(cardNameZL,1,1)
    local cardNumberZL = tonumber(string.sub(cardNameZL,2,2))

    if leadSuit == "Not Played" then
        goto done
    end

    if colorPosition[cardOwnerZL]
    and string.len(cardNameZL) == 2 
    and deck.getQuantity() == 0
    then

        local objectsZL = getAllObj()
        local commToken = getObjectFromGUID(colorPosition[cardOwnerZL].commGUID)
        local comm_flip = 0
        if commToken then
            comm_flip = tonumber(string.format("%.0f",commToken.getRotation().z))
        else
            comm_flip = 0
        end
        local leaderCount = 0

        for i,v in pairs(objectsZL.zone) do
            if v.getDescription() == leader.getDescription() then
                leaderCount = leaderCount + 1
            end
        end
        
        if cardOwnerZL == leader.getDescription() and leaderCount == 0 then
            leadSuit = "Not Played"
            discardReminder(obj, objectsZL)
            for i,v in pairs(objectsZL.zone) do
                if inTable(fixedColor, v.getDescription()) then
                    discardReminder(v, objectsZL)
                    v.deal(1, v.getDescription())
                end
            end
        end
    end
    ::done::
end

function getWinner(objects)
    local winningNum = 0
    local winningOwner = "Unknown"
    local winningSuit = "Unknown"

    for i,v in pairs(objects.zone) do
        -- Determine lead suit
        if string.sub(v.getName(),1,1) == "A" then
            winningSuit = "A"
            break
        elseif v.getDescription() == leader.getDescription() then
            winningSuit = string.sub(v.getName(),1,1)
        end
    end

    
    for i,v in pairs(objects.zone) do
        -- Get card information
        local cardSuit = string.sub(v.getName(),1,1)
        local cardNum = tonumber(string.sub(v.getName(),2,2))
        local cardOwner = v.getDescription()
        
        -- Determine winning card
        if cardSuit == winningSuit and cardNum > winningNum then
            winningNum = cardNum
            winningOwner = cardOwner
        end
    end
    return winningOwner
end

function resolveClicked(player, value, id)
    -- Check deck quantity, if 0...
    if deck.getQuantity() == 0 then
        local objectsR = getAllObj()

        local zoneCount = #objectsR.zone
        
        -- Check cards have been played
        if (zoneCount ~= playerCount and playerCount > 2 and not(playerCount==3 and jarvis3=="True")) or (zoneCount ~= playerCount + 1 and (playerCount == 2 or (playerCount==3 and jarvis3=="True"))) then
            broadcastToAll("Someone has not played or an extra card is present")
            goto done
        end
        
        local taskObjects = {}
        for i,v in pairs(objectsR.all) do
            if v.getDescription() == "Task Card" then
                for color in pairs(colorPosition) do
                    if colorPosition[color] and inPoly(colorPosition[color].polygonT, v) then
                        local tb = {}
                        tb.name = v.getName()
                        tb.owner = color
                        tb.color = colorPosition[color].color
                        tb.object = v
                        table.insert(taskObjects, tb)
                    end
                end
            end
        end
        
        local winningOwner = getWinner(objectsR)
        
        local stater = {}
        for i,v in pairs(objectsR.zone) do
            for j,k in pairs(taskObjects) do
                if k.owner == winningOwner and v.getName() == k.name then
                    table.insert(stater, k)
                elseif k.owner ~= winningOwner and v.getName() == k.name then
                    k.object.highlightOn(k.color,5)
                    v.highlightOn(k.color,5)
                    broadcastToAll("GAME OVER")
                    goto done
                end
            end
        end
        
        for i,v in pairs(stater) do
            local curr_rot = v.object.getRotation()
            v.object.setRotationSmooth({curr_rot.x,curr_rot.y,180}, false, false)
            broadcastToAll("Task completed: " .. v.name)
        end
        
        for i,v in pairs(objectsR.zone) do
            discard.putObject(v)
            Global.UI.setAttribute(v.getName().."Discard", "color", "#444444")
        end
        
        -- Reassign leader
        Wait.time(function() assignLeader(winningOwner) end, 1)

        --Increment counter
        Global.UI.setAttribute(winningOwner.."Tricks", "text", tonumber(Global.UI.getAttribute(winningOwner.."Tricks","text")) + 1)

        -- Move objects from discard
        local discardObjects = discard.getObjects()
        if #discardObjects < #discard.getObjects() then
            for j,k in pairs(discardObjects) do
                secret_discard.putObject(discard.takeObject(k))
            end
        end
    end   
    ::done::
end

function resetGameClicked(player, value, id)
    local playerColor = player.color
    if not(Player[playerColor].host or Player[playerColor].promoted) then
        broadcastToColor("Only the host or promoted players can reset the game!", playerColor)
        goto done
    end

    if deck.getQuantity() > 0 then
        broadcastToColor("Game already reset!", playerColor)
        goto done
    end

    if deck.getQuantity() == 0 then

        local allObjects = getAllObjects()
        local discardObjects = discard.getObjects()
        local secretObjects = secret_discard.getObjects()

        -- Send everything to a prep deck
        for i,v in pairs(allObjects) do
            if v.getName() == "Play Area" and v.getDescription() == "" then
                v.setColorTint(stringColorToRGB("White"))
            elseif not(v.getDescription()=="Stay" or v.getName()=="Comm Token" or v.getGUID()=="e23d86" or v.getName():find("Area") or v.getName():find("book")) then
                middleman.putObject(v)
            end
        end

        for i,v in pairs(discardObjects) do
            middleman.putObject(discard.takeObject(v))
        end

        for i,v in pairs(secretObjects) do
            if not(v.description=="Reminder" or string.sub(v.name,1,1)=="Z" or v.name=="A1") then
                middleman.putObject(secret_discard.takeObject(v))
            end
        end

        -- Send back to homes
        for i,v in pairs(task.getObjects()) do
            if string.sub(v.name,1,1)=="Z" and v.description == "Task Card" then
                secret_discard.putObject(task.takeObject(v))
            end
        end
        -- Modifiers need to go back in order
        for v in pairs(modifiersDetails) do
            modifiers.putObject(middleman.takeObject({guid=modifiersDetails[v].guid}))
        end

        -- Other objects
        for i,v in pairs(middleman.getObjects()) do
            -- Reminders and blue tasks to secret discard
            if v.description=="Reminder" or (string.sub(v.name,1,1)=="Z" and v.description=="Task Card") then
                local cc = middleman.takeObject(v)
                Wait.condition(
                    function()
                        secret_discard.putObject(cc)
                    end,
                    function()
                        return not cc.spawning
                    end
                )
            -- Other tasks go back to tasks
            elseif v.description=="Task Card" then
                local cc = middleman.takeObject(v)
                Wait.condition(
                    function()
                        task.putObject(cc)
                    end,
                    function()
                        return not cc.spawning
                    end
                )
                -- task.putObject(middleman.takeObject(v))
            -- Commander and Leader to secret discard
            elseif v.name=="Commander" or v.name=="Leader" then
                local cl = middleman.takeObject(v)
                Wait.condition(
                    function()
                        cl.setDescription("");
                        secret_discard.putObject(cl);
                    end,
                    function()
                        return not cl.spawning
                    end
                )
            -- Blue playing cards and A1 rocket to secret discard
            elseif string.sub(v.name,1,1)=="Z" or v.name=="A1" then
                local pcs = middleman.takeObject(v)
                Wait.condition(
                    function()
                        pcs.setDescription("Playing Card");
                        secret_discard.putObject(pcs);
                    end,
                    function()
                        return not pcs.spawning
                    end
                )
            -- All other playing cards to deck
            elseif string.len(v.name) == 2 and colorPosition[v.description] then
                local pc = middleman.takeObject(v)
                Wait.condition(
                    function()
                        pc.setDescription("Playing Card");
                        deck.putObject(pc);
                    end,
                    function()
                        return not pc.spawning
                    end
                )
            end
        end
        onLoad()
        broadcastToAll("Game reset complete!")
    end
    ::done::
end
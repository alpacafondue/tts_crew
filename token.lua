function randomize(t)
    for i = 1, #t*2 do
        local a = math.random(#t)
        local b = math.random(#t)
        t[a],t[b] = t[b],t[a]
    end 
    return t
end

function sortCards(description)
-- Sort cards by random suit order
    local cards = {}
    local handPos = {}
    local t = {"A","G","P","Y","Z"}
    local o = {1,2}
    
    -- Get player's hand
    handObjects = Player[description].getHandObjects()
    randSuit = randomize(t)
    randOrder = randomize(o)[1]
    
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
            j.card.setDescription(description)
        end
    end
end

function getReminder(obj)
    local secret_discard = getObjectFromGUID("3a9a47")
    for i,v in pairs(secret_discard.getObjects()) do
        if v.name == obj.getName() and v.description == "Reminder" then
            tc = secret_discard.takeObject({index = v.index})
            Wait.condition(
                function() tc.deal(1, obj.getDescription()) end,
                function() return not tc.spawning end
            )
            Wait.time(|| sortCards(obj.getDescription()), 1)
            break
        end
    end
end

function onCollisionEnter(info)
    local deckCT = getObjectFromGUID("a6fb25")
    -- local buttonCT = getObjectFromGUID("5a7db4")
    if deckCT.getQuantity() == #deckCT.getObjects() and deckCT.getQuantity() > 0 then
    else
        local flipper = tonumber(string.format("%.0f",self.getRotation().z))
        local playerHand = Player[self.getDescription()].getHandObjects()
        local count = 0
        for i,v in pairs(playerHand) do
            -- if v.getDescription() == "Reminder" or Global.getVar("playerCount") < 3 then
            if v.getDescription() == "Reminder" then
                count = count + 1
                break
            end
        end
        if self.getDescription() == info.collision_object.getDescription() and flipper == 0 and count == 0 then
            getReminder(info.collision_object)
        end
    end
end
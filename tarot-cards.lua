-- Created By, Hiram Abiff v2.1

--[[

This script was only possible due to the continued help from the really
cool guys on the Berserk Forums. There may be some pieces of code that don't
belong, but I will be sure to clean it up over time.

A lot of snippets you may find here, are directly from MrStumps lua tutorials;
I gratly thank him for his help and patience with providing others the
knowledge to create their own scripts.

If you have any suggestions on further changes or if you find any bugs, please
make a post in the comments or "Bugs" discussions thread for this mod. Thank you.

For a complete list of changes for v2.1, you can read the changelog located on the
workshop page for this mod.

]]

--------------------------------------------------------
local debug = false


function onLoad()
    local backgColor = {0,0,0}--{0.3,0.2,0}
    local fontColor = {1,1,1}
    self.createButton({ -- index 0, Previous Layout
        label="<--", click_function="prevLayout",
        function_owner=self, position={-1,0.075,-0.6},
        height=250, width=250, font_size=100,
        font_color=fontColor, color=backgColor
    })
    self.createButton({ -- index 1, Selection Button
        label="Selection Button", click_function="selectLayout",
        function_owner=self, position={-0,0.075,-0.6},
        height=250, width=720, font_size=100,
        font_color=fontColor, color=backgColor
    })
    self.createButton({ -- index 2, Next Layout
        label="-->", click_function="nextLayout",
        function_owner=self, position={1,0.075,-0.6},
        height=250, width=250, font_size=100,
        font_color=fontColor, color=backgColor
    })
    self.createButton({ -- index 3, Number Display
        label="0", click_function="none",
        function_owner=self, position={-1.155,0.075,-1.108},
        height=0, width=0, font_size=100,
        font_color={1,1,1}, color={0,0,0}
    })
    self.createButton({ -- index 4, Instruction Display
        label="Place a deck beside\n the tool and press the\n Find Deck button.", click_function="none",
        function_owner=self, position={-0,0.075,0.8},
        height=0, width=0, font_size=110,
        font_color=fontColor, color={0,0,0}
    })
    self.createButton({ -- index 5, Find Deck
        label="Find\nDeck", click_function="findDeck",
        function_owner=self, position={1.06,0.075,-1.1},
        height=250, width=320, font_size=80,
        font_color={0.7,0.2,0.2}, color=backgColor
    })
    self.createButton({ -- index 6, Rotation On/Off
        label="Rotation\nOn", click_function="rotationOnOff",
        function_owner=self, position={-0.37,0.075,0},
        height=250, width=445, font_size=100,
		font_color=fontColor, color=backgColor
    })
    self.createButton({ -- index 7, Shuffle
        label="Shuffle", click_function="shuffle",
        function_owner=self, position={0.4,0.075,0},
        height=250, width=330, font_size=100,
    	font_color=fontColor, color=backgColor
    })
    self.createButton({ -- index 8, Spawns and controls the Help Tablet
        label="Help\nTablet", click_function="helpTablet",
        function_owner=self, position={1.05,0.075,0},
        height=250, width=320, font_size=100,
    	font_color=fontColor, color=backgColor
    })
    self.createButton({ -- index 9, Display used to
        label="------------->", click_function="None",
        function_owner=self, position={-0,0.075,-1.1},
        height=0, width=0, font_size=130,
        font_color={1,1,1}, color={0,0,0}
    })
    self.createButton({ -- index 10, Automatically select cards enable/disable
        label="Manual\nDraw", click_function="autoSelectCards",
        function_owner=self, position={-1.1,0.075,0},
        height=250, width=300, font_size=80,
        font_color={1,1,1}, color={0,0,0}
    })
    rotation = true
    layout = nil
    layoutNum = 0
    cardPosX = nil
    cardPosZ = nil
    neededCards = nil
    autoCards = false
    activeButtonColor = {0.9,0.9,0.3}
    selectNewCards = false
    nextLayout()
end
selectedCards = {}

layoutFunctions = {
    "none", --oneCardDraw
    "none", --threeCardDraw
    "none", --fiveCardDraw
    "none", --celticCrossDraw
    "none", --tetraktysDraw
    "none", --crossAndTriangleDraw
    "none", --astroDraw
    "none", --planetaryDraw
    "none", --treeOfLifeDraw
    "none", --starGuideDraw
    "none", --spiritualGuidanceDraw
    "none", --doOrDontDraw
    "none", --highPriestessDraw
    "none", --careerPathDraw
    "none", --pastLifeDraw
    "none", --relationshipProblemsDraw
    "none", --birthdayDraw
    "none", --mandalaDraw
    "none", --horseshoeDraw
    "none", --opportunitiesAndObstaclesDraw
    "none", --moneyProblemsDraw
    "customCardsDraw",
}

layoutNames = {
    "Single Card",
    "Three Card",
    "Five Card",
    "Celtic Cross",
    "Tetraktys",
    "Cross & Triangle",
    "Astrological",
    "Planetary",
    "Tree of Life",
    "Star Guide",
    "Spiritual\nGuidance",
    "Should you? or\nShouldn't You?",
    "Secret of the\nHigh Priestess",
    "Career Path",
    "Past Life",
    "Relationship\nProblems",
    "Birthday",
    "Mandala",
    "Horseshoe",
    "Opportunities &\nObstacles",
    "Money Problems",
    "Custom Cards",
}

helpTabUrls = {
    "https://dl.dropboxusercontent.com/s/ubokfwb2w0u6dnx/HomePage.png", -- Help Home Page
    "https://dl.dropbox.com/s/ocqmv6jah0388pp/Single%20Card.png?dl=0", -- Single Card
    "https://dl.dropbox.com/s/pd10yopytjp0oj8/Three%20Card.png?dl=0", -- Three Card
    "https://dl.dropbox.com/s/6iva4pye4s8i92g/Five%20card.png?dl=0", -- Five Card
    "https://dl.dropbox.com/s/mx8rjp9ybuy8jqu/celticCross.png?dl=0", -- Celtic Cross
    "https://dl.dropbox.com/s/j4tdmbzojnfqb9d/Tetraktys.png?dl=0", -- Tetraktys
    "https://dl.dropbox.com/s/ojjkkwobokwbguz/Cross%20and%20Triangle.png?dl=0", -- Cross & Triangle
    "https://dl.dropbox.com/s/ppwqizeqjj5ohub/Astro%20Zodiac.png?dl=0", -- Astrological
    "https://dl.dropbox.com/s/600ny3vhc2lvzrf/Planetary.png?dl=0", -- Planetary
    "https://dl.dropbox.com/s/ynhwcc668lxoil3/Tree%20of%20Life.png?dl=0", -- Tree of Life
    "https://dl.dropbox.com/s/r0b249ndjviac0v/Star%20Guide.png?dl=0", -- Star Guide
    "https://dl.dropbox.com/s/a7n62u801aoqer6/Spiritual%20Guidance.png?dl=0", -- Spiritual Guidance
    "https://dl.dropbox.com/s/w9kwlhlwu0tju74/Should%20you%2C%20shouldnt%20you.png?dl=0", -- Should you? or Shouldn't you?
    "https://dl.dropbox.com/s/vhtnrze7tep0fl8/Secret%20of%20the%20High%20Priestess.png?dl=0", -- Secret of the High Priestess
    "https://dl.dropbox.com/s/7i7p9emxyrev2mx/Career%20Path.png?dl=0", -- Career Path
    "https://dl.dropbox.com/s/voxepwd9cjergdg/Past%20Life.png?dl=0", -- Past Life
    "https://dl.dropbox.com/s/ravkl7f7cxl2dcm/Relationship%20Problems.png?dl=0", -- Relationship Problems
    "https://dl.dropbox.com/s/zxuiufqnxfdkp8c/Birthday%20spread.png?dl=0", -- Birthday
    "https://dl.dropbox.com/s/4rfsdxoymv76qdy/Mandala.png?dl=0", -- Mandala
    "https://dl.dropbox.com/s/ersbnozvuxs5uds/Horseshoe.png?dl=0", -- Horseshoe
    "https://dl.dropbox.com/s/ju4rylxx272l3zg/Opportunities%20and%20Obstacles.png?dl=0", -- Opportunities & Obstacles
    "https://dl.dropbox.com/s/twfgho07d2od1sb/Money%20Problems.png?dl=0", -- Money Problems
    "https://i.imgur.com/bVZuYKA.jpg", -- Custom Catds
}
function nextLayout()
    if layout == nil then
        if layoutNum <= 21 then
            layoutNum = layoutNum + 1
            self.editButton({index=3, label=layoutNum})
            self.editButton({index=1, label=layoutNames[layoutNum], click_function=layoutFunctions[layoutNum]})
        else
            layoutNum = 1
            self.editButton({index=3, label=layoutNum})
            self.editButton({index=1, label=layoutNames[layoutNum], click_function=layoutFunctions[layoutNum]})
        end
    end
end

function prevLayout()
    if layout == nil then
        if layoutNum >= 2 then
            layoutNum = layoutNum - 1
            self.editButton({index=3, label=layoutNum})
            self.editButton({index=1, label=layoutNames[layoutNum], click_function=layoutFunctions[layoutNum]})
        else
            layoutNum = 21
            self.editButton({index=3, label=layoutNum})
            self.editButton({index=1, label=layoutNames[layoutNum], click_function=layoutFunctions[layoutNum]})
        end
    end
end

function rotationOnOff() -- Enables or disables rotation; Rotation On/Off button.
	if rotation == true then
		rotation = false
		local button_parameters = {}
		self.editButton({index=6, label="Rotation\nOff"})
	elseif rotation == false then
		rotation = true
		self.editButton({index=6, label="Rotation\nON"})
	end
end

function autoSelectCards() -- designed to enable to disable user selecting cards.
    if autoCards == false then
        autoCards = true
        self.editButton({index=10, label="Auto\nDraw"})
    elseif autoCards == true then
        autoCards = false
        self.editButton({index=10, label="Manual\nDraw"})
    end
end

function shuffle()
    local cardsOnTable = getAllObjects()
    for i,v in ipairs(cardsOnTable) do
        if v.tag == "Card" then
            cardsOnTable = true
        end
    end
    if cardsOnTable == true then
        startLuaCoroutine(self, "shuffleCoroutine")
    elseif deckRef == nil then
        print("To Shuffle, you must first find a deck with the Find Deck button.")
    elseif deckRef ~= nil then
        deckRef.shuffle()
    end
end

function shuffleCoroutine() -- Resets all all cards back to the deck, and resets layout buttons.
    self.editButton({index=4, font_size=110, label='Using the arrows, choose\na layout, and select it with\nthe center button labeled\n with the layout name.'})
    setNotes("")
    layout = nil
    selectNewCards = false
    local handCards = Player.Black.getHandObjects()
    local deckPos = self.positionToWorld({3,0,0})
    if #handCards > 0 then -- Resets cards from the hand back to the deck. This is used when the player wants to reset the deck mid draw.
        for i,v in ipairs(handCards) do
            deckPos.y = deckPos.y + 0.01
            v.setPosition(deckPos)
            for i=1,1,1 do coroutine.yield(0) end
        end
    end
    findDeck()
    if #selectedCards > 0 and deckRef ~= nil then
	    for _, object in ipairs(selectedCards) do -- uses the table and puts all selected cards back into the deck.
            deckRef.putObject(object)
        end
        for i=1, 25,1 do coroutine.yield(0) end -- coroutine used to wait for cards to return before the table is wiped.
        for k in pairs(selectedCards) do
            selectedCards[k] = nil
        end
    end
    local cardsOnTable = getAllObjects()
    for _, objects in ipairs(cardsOnTable) do -- Moves any left over cards on the table to the deck.
        if objects.tag == "Card" then
            deckRef.putObject(objects)
        end
    end
    self.editButton({index=1, font_color={1,1,1}})
    for i=1,25,1 do coroutine.yield(0) end
    deckRef.Shuffle()
    return 1
end

function findDeck() -- "Find Deck" Button; finds deck within 5 units of tool.
    local allObjects = getAllObjects()
    foundDeck = false
    for _, deckObjects in ipairs(allObjects) do
        if deckObjects.tag == "Deck" then
            local distance = findProximity(self.getPosition(), deckObjects)
            if distance <= 5 then
				deckGuid = deckObjects.getGUID()
				deckRef = getObjectFromGUID(deckGuid)
				--deckRef.setScale({0.89, 1.00, 0.89})
                deckRef.setDescription(deckGuid)
                self.editButton({index=9, font_size=100, position={-0,0.075,-1.1}, font_color={0,0.7,0.2}, label="GUID: "..deckGuid})
				self.editButton({index=5, font_size=60, font_color={0,0.7,0.2}, label='Deck\nFound'})
                foundDeck= true
            end
        end
    end
    if foundDeck == false and deckRef ~= nil then
        self.editButton({index=9, font_size=55, font_color={0,0.7,0.2}, label='No Deck Found within 5 Units\nUsing last known deck\nGUID: '..deckGuid})
    elseif deckRef == nil then
        self.editButton({index=4, font_size=110, label='No deck found; place deck\n beside the tool and press\n the Find Deck Button.'})
    elseif layout == nil then
        self.editButton({index=4, font_size=110, label='Using the arrows, choose\na layout, and select it with\nthe center button labeled\n with the layout name.'})
    end
end

function findProximity(targetPos, object) -- Used by "findDeck" to determine distance between tool and deck.
    local objectPos = object.getPosition()
    local xDistance = math.abs(targetPos.x - objectPos.x)
    local zDistance = math.abs(targetPos.z - objectPos.z)
    local distance = xDistance^2 + zDistance^2
    return math.sqrt(distance)
end

function update() -- This update function watches for GUIDs that are input to the tools description box.
    if self.getDescription() ~= nil then
        local deckObj = getObjectFromGUID(self.getDescription())
        if deckObj then
            deckRef = deckObj
            self.editButton({index=2, font_color={0,0.7,0.2}, label='Deck:\n'..deckObj.getGUID()})
			--deckObj.setScale({0.89, 1.00, 0.89})
            deckObj.setDescription(deckObj.getGUID())
            foundDeck = true
		end
	self.setDescription("")
	end
end

function drawCards()
    startLuaCoroutine(self, "drawCardsCoroutine")
end

function drawCardsCoroutine()
    local fontSize = 130
    for i=1, 10,1 do coroutine.yield(0) end
    Player.Black.setHandTransform({
        position = {-0.39, 4.61, -8.14},
        rotation = {0.00, 0.00, 0.00},
        scale    = {23.78, 1.65, 1.73},
    })
    local deckSize = deckRef.getObjects()
    for i=1, #deckSize do
        deckRef.dealToColorWithOffset({-14.5, 2, 0.19}, false, "Black")
        selectNewCards = true
    end
    setNotes(layout..' - Choose '..neededCards..' cards to continue.')
    self.editButton({index=4, font_size=fontSize, font_color=fontColor, label='\nChoose '..neededCards..' cards to\n continue.'})
    broadcastToColor(layout..' layout selected', 'White')--, {0,1,0})
    return 1
end
movingCards = false
function onObjectPickedUp(White, obj)
    if obj.tag == "Card" and selectNewCards == true and movingCards == false then
        cardRef = obj
        startLuaCoroutine(self, "moveCard")
    end
end

neededCards = nil
cardPosX = nil
cardPosZ = nil

function moveCard()
    handCards = Player.Black.getHandObjects()
    for i=1, 10 do
        coroutine.yield(0)
    end
    local fontSize = 130
    if #selectedCards <= neededCards and selectNewCards == true then
        if #selectedCards == 0 then
            if rotation == true and math.random (2) == 1 then
                cardRef.setRotation({0,0,180})
            else
                cardRef.setRotation({0,180,180})
            end
            cardRef.setPosition({cardPosX, 1.6, cardPosZ})
            table.insert( selectedCards, 1, cardRef)
            card2 = neededCards - 1
            setNotes(layout..' - Choose '..card2..' cards to continue.')
            self.editButton({index=4, font_size=fontSize, font_color=fontColor, label='\nChoose '..card2..' cards to\n continue.'})
        elseif #selectedCards == 1 then
            if rotation == true and math.random (2) == 1 then
                cardRef.setRotation({0,0,180})
            else
                cardRef.setRotation({0,180,180})
            end
            cardRef.setPosition({cardPosX+2.3, 1.6, cardPosZ})
            table.insert( selectedCards, cardRef)
            card3 = neededCards - 2
            setNotes(layout..' - Choose '..card3..' cards to continue.')
            self.editButton({index=4, font_size=fontSize, font_color=fontColor, label='\nChoose '..card3..' cards to\n continue.'})--this
        elseif #selectedCards == 2 then
            if rotation == true and math.random (2) == 1 then
                cardRef.setRotation({0,0,180})
            else
                cardRef.setRotation({0,180,180})
            end
            cardRef.setPosition({cardPosX+4.6, 1.6, cardPosZ})
            table.insert( selectedCards, cardRef)
            card4 = neededCards - 3
            setNotes(layout..' - Choose '..card4..' cards to continue.')
            self.editButton({index=4, font_size=fontSize, font_color=fontColor, label='\nChoose '..card4..' cards to\n continue.'})
        elseif #selectedCards == 3 then
            if rotation == true and math.random (2) == 1 then
                cardRef.setRotation({0,0,180})
            else
                cardRef.setRotation({0,180,180})
            end
            cardRef.setPosition({cardPosX+6.9, 1.6, cardPosZ})
            table.insert( selectedCards, cardRef)
            card5 = neededCards - 4
            setNotes(layout..' - Choose '..card5..' cards to continue.')
            self.editButton({index=4, font_size=fontSize, font_color=fontColor, label='\nChoose '..card5..' cards to\n continue.'})
        elseif #selectedCards == 4 then
            if rotation == true and math.random (2) == 1 then
                cardRef.setRotation({0,0,180})
            else
                cardRef.setRotation({0,180,180})
            end
            cardRef.setPosition({cardPosX+9.2, 1.6, cardPosZ})
            table.insert( selectedCards, cardRef)
            card6 = neededCards - 5
            setNotes(layout..' - Choose '..card6..' cards to continue.')
            self.editButton({index=4, font_size=fontSize, font_color=fontColor, label='\nChoose '..card6..' cards to\n continue.'})
        elseif #selectedCards == 5 then
            if rotation == true and math.random (2) == 1 then
                cardRef.setRotation({0,0,180})
            else
                cardRef.setRotation({0,180,180})
            end
            cardRef.setPosition({cardPosX+11.5, 1.6, cardPosZ})
            table.insert( selectedCards, cardRef)
            card7 = neededCards - 6
            setNotes(layout..' - Choose '..card7..' cards to continue.')
            self.editButton({index=4, font_size=fontSize, font_color=fontColor, label='\nChoose '..card7..' cards to\n continue.'})
        elseif #selectedCards == 6 then
            if rotation == true and math.random (2) == 1 then
                cardRef.setRotation({0,0,180})
            else
                cardRef.setRotation({0,180,180})
            end
            cardRef.setPosition({cardPosX+13.8, 1.6, cardPosZ})
            table.insert( selectedCards, cardRef)
            card8 = neededCards - 7
            setNotes(layout..' - Choose '..card8..' cards to continue.')
            self.editButton({index=4, font_size=fontSize, font_color=fontColor, label='\nChoose '..card8..' cards to\n continue.'})
        elseif #selectedCards == 7 then
            if rotation == true and math.random (2) == 1 then
                cardRef.setRotation({0,0,180})
            else
                cardRef.setRotation({0,180,180})
            end
            cardRef.setPosition({cardPosX+16.1, 1.6, cardPosZ})
            table.insert( selectedCards, cardRef)
            card9 = neededCards - 8
            setNotes(layout..' - Choose '..card9..' cards to continue.')
            self.editButton({index=4, font_size=fontSize, font_color=fontColor, label='\nChoose '..card9..' cards to\n continue.'})
        elseif #selectedCards == 8 then
            if rotation == true and math.random (2) == 1 then
                cardRef.setRotation({0,0,180})
            else
                cardRef.setRotation({0,180,180})
            end
            cardRef.setPosition({cardPosX+18.4, 1.6, cardPosZ})
            table.insert( selectedCards, cardRef)
            card10 = neededCards - 9
            setNotes(layout..' - Choose '..card10..' cards to continue.')
            self.editButton({index=4, font_size=fontSize, font_color=fontColor, label='\nChoose '..card10..' cards to\n continue.'})
        elseif #selectedCards == 9 then
            if rotation == true and math.random (2) == 1 then
                cardRef.setRotation({0,0,180})
            else
                cardRef.setRotation({0,180,180})
            end
            cardRef.setPosition({cardPosX+20.7, 1.6, cardPosZ})
            table.insert( selectedCards, cardRef)
            card11 = neededCards - 10
            setNotes(layout..' - Choose '..card11..' cards to continue.')
            self.editButton({index=4, font_size=fontSize, font_color=fontColor, label='\nChoose '..card11..' cards to\n continue.'})
        elseif #selectedCards == 10 then
            if rotation == true and math.random (2) == 1 then
                cardRef.setRotation({0,0,180})
            else
                cardRef.setRotation({0,180,180})
            end
            cardRef.setPosition({cardPosX+23, 1.6, cardPosZ})
            table.insert( selectedCards, cardRef)
            card12 = neededCards - 11
            setNotes(layout..' - Choose '..card12..' cards to continue.')
            self.editButton({index=4, font_size=fontSize, font_color=fontColor, label='\nChoose '..card12..' cards to\n continue.'})
        elseif #selectedCards == 11 then
            if rotation == true and math.random (2) == 1 then
                cardRef.setRotation({0,0,180})
            else
                cardRef.setRotation({0,180,180})
            end
            cardRef.setPosition({cardPosX+25.3, 1.6, cardPosZ})
            table.insert( selectedCards, cardRef)
            card13 = neededCards - 12
            setNotes(layout..' - Choose '..card13..' cards to continue.')
            self.editButton({index=4, font_size=fontSize, font_color=fontColor, label='\nChoose '..card13..' cards to\n continue.'})
        elseif #selectedCards == 12 then
            if rotation == true and math.random (2) == 1 then
                cardRef.setRotation({0,0,180})
            else
                cardRef.setRotation({0,180,180})
            end
            cardRef.setPosition({cardPosX+27.6, 1.6, cardPosZ})
            table.insert( selectedCards, cardRef)
            card14 = neededCards - 13
            setNotes(layout..' - Choose '..card14..' cards to continue.')
            self.editButton({index=4, font_size=fontSize, font_color=fontColor, label='\nChoose '..card14..' cards to\n continue.'})
        elseif #selectedCards == 13 then
            if rotation == true and math.random (2) == 1 then
                cardRef.setRotation({0,0,180})
            else
                cardRef.setRotation({0,180,180})
            end
            cardRef.setPosition({cardPosX+29.9, 1.6, cardPosZ})
            table.insert( selectedCards, cardRef)
            card15 = neededCards - 14
            setNotes(layout..' - Choose '..card15..' cards to continue.')
            self.editButton({index=4, font_size=fontSize, font_color=fontColor, label='\nChoose '..card15..' cards\n to continue.'})
        end
    end
    for i=1,15,1 do coroutine.yield(0) end
    if #selectedCards == neededCards then
        selectNewCards = false
        if selectNewCards == false then
            setNotes('')
            broadcastToColor("Done!", 'White')--, {0,2,0})
            local unusedCards = Player.Black.getHandObjects()
            local selfPos = self.positionToWorld({2.9,1,0})
            for i,v in ipairs(unusedCards) do
                v.setPosition(selfPos)
                for i=1,1,1 do coroutine.yield(0) end
            end
            for i=1, 30,1 do coroutine.yield(0) end
            pickedCardsFinished()
            Player.Black.setHandTransform({
                position = {-0.39, 160, -8.14},
                rotation = {0.00, 0.00, 0.00},
                scale    = {23.78, 1.65, 1.73},
            })
        end
        for i=1,30,1 do coroutine.yield(0) end
        findDeck()
    end
    return 1
end

function altDraw()
    startLuaCoroutine(self, "altDrawCoroutine")
end

function altDrawCoroutine()
    if autoCards == true then
        for i=1, neededCards do
            if layout ~= nil then
                local params = {}
                params.callback = "autoDrawCallback"
                params.callback_owner = self
                params.position = {cardPosX, 2, cardPosZ}
                deckRef.takeObject(params)
                cardPosX = cardPosX + 2.3
                for i=1,15,1 do coroutine.yield(0) end
            end
        end
    end
    return 1
end

function autoDrawCallback(card)
    local cardLoc = card.getPosition()
    if rotation == true and math.random(2) == 1 then -- rotation was used here instead of within takeObject so the movement would not be seen.
        card.setRotation({cardLoc.x, cardLoc.y, 180})
    else
        cardLoc.y = cardLoc.y + 180
        card.setRotation({cardLoc.x, cardLoc.y, 180})
    end
    table.insert( selectedCards, card)
    if #selectedCards == neededCards then
        pickedCardsFinished()
    end
end

function helpTablet()
    local targetPos = self.positionToWorld({0,1,-3.6})
    if tabletRef == nil then
        spawnObject({
            type           = "Tablet",
            rotation       = {0.00, 179.99, 0.00},
            position       = targetPos,
            scale          = {0.40, 0.40, 0.40},
            callback_owner = self,
            callback       = "helpTabletCallback",
            params         = {"tab"}
        })
    else
        if tabletRef ~= nil then
            local currentUrl = tabletRef.getValue()
            if currentUrl == helpTabUrls[1] then
                tabletRef.setValue("http://psychiclibrary.com/beyondBooks/tarot-deck/")
            elseif currentUrl == "http://psychiclibrary.com/beyondBooks/tarot-deck/" then
                tabletRef.setValue(helpTabUrls[1])
            elseif currentUrl ~= helpTabUrls[1] or currentUrl ~= "http://psychiclibrary.com/beyondBooks/tarot-deck/" then
                tabletRef.setValue(helpTabUrls[1])
            end
        end
    end
end

function helpTabletCallback(tab)
    local tabletGuid = tab.getGUID()
    tabletRef = getObjectFromGUID(tabletGuid)
    tab.setName("Tarot Help Tablet")
    tab.setValue(helpTabUrls[1])
end

function selectLayout()
    return 1
end

function customCardsDraw()
    neededCards = 5
    cardPosX = 0.00
    cardPosZ = -13.78
    layout = "Custom Cards"
    autoCards = true
    customDraw()
end

function customDraw()
    startLuaCoroutine(self, "customDrawCoroutine")
end

function customDrawCoroutine()
    if autoCards == true then
        
        local cardPositions = {
            {68.00, 5.00, -13.60}, -- Sai
	        {68.00, 5.00, 13.60}, --Zerrik
	        {68.00, 5.00, -6.80}, --Varan
	        {68.00, 5.00, 6.80}, --Bobby
	        {68.00, 5.00, 0.00}, --Erik
        }

        if debug then
            cardPositions = {
                {0, 2.00, -8}, -- Sai
                {0, 2.00, -4}, --Zerrik
                {0, 2.00, 4}, --Varan
                {0, 2.00, 8}, --Bobby
                {0, 2.00, 0}, --Erik
            }
        end
        for i=1, neededCards do -- drawing cards and initial position
            if layout ~= nil then
                local params = {}
                params.callback = "customDrawCallback"
                params.callback_owner = self
                params.position = cardPositions[i]
                params.rotation = {0.00, 90.00, 180.00}
                deckRef.takeObject(params)
                for i=1,45,1 do coroutine.yield(0) end
            end
        end
    end
    return 1
end

function customDrawCallback(card)
    card.setLock(true)
    --card.setScale({1.83, 1, 1.83})
    table.insert( selectedCards, card)
    if #selectedCards == neededCards then
        customFinished()
    end
end

function customFinished()
    startLuaCoroutine(self, "customFinishedCoroutine")
end

function customFinishedCoroutine()
    local cardFinalPos = { -- cards in "hand"
        {-74.82, 2.00, -49.30}, --Sai
        {40.80, 2.00, 49.30}, --Zerrik
        {-37.40, 2.00, 49.30}, --Varan
        {-17.00, 2.00, 49.30}, --Bobby
        {-16.15, 2.00, -48.45}, --Erik
    }
    local cardMidPos = { -- cards in formation
        {-5.10, 4.45, -5.10}, --Sai
        {5.10, 4.45, -5.10}, --Zerrik
        {-5.10, 4.45, 5.10}, --Varan
        {5.10, 4.45, 5.10}, --Bobby
        {0.00, 4.45, 0.00}, --Erik
    }

    local cardRot = {
        {0.00, 180.00, 0.00}, --Sai
        {0.00, 0.00, 0.00}, --Zerrik
        {0.00, 0.00, 0.00}, --Varan
        {0.00, 0.00, 0.00}, --Bobby
        {0.00, 180.00, 0.00}, --Erik
    }
    for i,v in ipairs(selectedCards) do -- setting to 0
        local targetPos = v.positionToWorld({0,0,0})
        v.setPositionSmooth(targetPos)
    end
    -- "shuffling"
    local locZ = selectedCards[#selectedCards].getPosition()
    for i,v in ipairs(selectedCards) do
        local targetPos = v.getPosition()
        targetPos.y = targetPos.y+i*0.05
        targetPos.z = locZ.z
        targetPos.x = locZ.z
        v.setPositionSmooth(targetPos,false,false)
    end
    for i=1,60,1 do coroutine.yield(0) end
    

    deckRef.shuffle()
    local curRot = selectedCards[1].getRotation()

    local steps = 20
    for i=1,steps do
        local rot = (curRot.y*i)/steps
        selectedCards[1].setRotation({curRot.x,rot,curRot.z})
        coroutine.yield(0)
    end
    deckRef.shuffle()
    local curRot = selectedCards[3].getRotation()

    local steps = 20
    for i=1,steps do
        local rot = (curRot.y*i)/steps
        selectedCards[1].setRotation({curRot.x,rot,curRot.z})
        coroutine.yield(0)
    end
    
    


    for i=1,45,1 do coroutine.yield(0) end -- setting to formation
    for i,v in ipairs(selectedCards) do
        local targetPos = cardMidPos[i]
        v.setPositionSmooth(targetPos)
    end
    for i=1,60,1 do coroutine.yield(0) end -- going to hand
    for i,v in ipairs(selectedCards) do
        v.setPositionSmooth(cardFinalPos[i])
        v.setRotationSmooth(cardRot[i])
        v.setLock(false)
        --v.flip()
        for i=1, 15,1 do coroutine.yield(0) end
    end
    selectedCards = {}
    return 1
end

function allResting(arr)
    for i=1, #arr do
        if not arr[i].resting then
            return false
        end
    end
    return true
end

function oneCardDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 1
        cardPosX = 0.00
        cardPosZ = -13.78
        layout = "Single Card"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[2])
    end
end

function threeCardDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 3
        cardPosX = -2.30
        cardPosZ = -13.78
        layout = "Three Card"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[3])
    end
end

function fiveCardDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 5
        cardPosX = -4.60
        cardPosZ = -13.78
        layout = "Five Card"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[4])
    end
end

function celticCrossDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 10
        cardPosX = -10.37
        cardPosZ = -13.78
        layout = "Celtic Cross"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[5])
    end
end

function tetraktysDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 10
        cardPosX = -10.37
        cardPosZ = -13.78
        layout = "Tetraktys"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[6])
    end
end

function astroDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 13
        cardPosX = -13.87
        cardPosZ = -13.78
        layout = "Astrological"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[8])
    end
end

function planetaryDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 8
        cardPosX = -8.13
        cardPosZ = -13.78
        layout = "Planetary"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[9])
    end
end

function treeOfLifeDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 10
        cardPosX = -10.37
        cardPosZ = -13.78
        layout = "Tree Of Life"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[10])
    end
end

function crossAndTriangleDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 9
        cardPosX = -9.23
        cardPosZ = -13.78
        layout = "Cross & Triangle"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[7])
    end
end

function relationshipProblemsDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 9
        cardPosX = -9.23
        cardPosZ = -13.78
        layout = "Relationship Problems"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[17])
    end
end

function moneyProblemsDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 5
        cardPosX = -4.60
        cardPosZ = -13.78
        layout = "Money Problems"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[22])
    end
end

function pastLifeDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 14
        cardPosX = -14.93
        cardPosZ = -13.78
        layout = "Past Life"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[16])
    end
end

function careerPathDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 7
        cardPosX = -6.97
        cardPosZ = -13.78
        layout = "Career Path"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[15])
    end
end

function highPriestessDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 9
        cardPosX = -9.23
        cardPosZ = -13.78
        layout = "High Priestess"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[14])
    end
end

function doOrDontDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 9
        cardPosX = -9.23
        cardPosZ = -13.78
        layout = "Should you Shouldn't you"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[13])
    end
end

function starGuideDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 6
        cardPosX = -5.73
        cardPosZ = -13.78
        layout = "Star Guide"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[11])
    end
end

function spiritualGuidanceDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 8
        cardPosX = -8.13
        cardPosZ = -13.78
        layout = "Spiritual Guidance"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[12])
    end
end

function birthdayDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 9
        cardPosX = -9.23
        cardPosZ = -13.78
        layout = "Birthday"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[18])
    end
end

function mandalaDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 9
        cardPosX = -9.23
        cardPosZ = -13.78
        layout = "Mandala"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[19])
    end
end

function horseshoeDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 7
        cardPosX = -6.97
        cardPosZ = -13.78
        layout = "Horseshoe"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[20])
    end
end

function opportunitiesAndObstaclesDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 7
        cardPosX = -6.97
        cardPosZ = -13.78
        layout = "Opportunities &\nObstacles"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[21])
    end
end

function moneyProblemsDraw()
    local handCards = Player.Black.getHandObjects()
    if layout == nil and deckRef ~= nil then
        self.editButton({index=1, font_color=activeButtonColor})
        neededCards = 6
        cardPosX = -5.73
        cardPosZ = -13.78
        layout = "Money Problems"
        if autoCards == false then
            selectNewCards = true
            drawCards()
        else
            altDraw()
        end
    end
    if tabletRef ~= nil then
        tabletRef.setValue(helpTabUrls[22])
    end
end

function pickedCardsFinished()
    startLuaCoroutine(self, "pickedCardsCoroutine")
end

function pickedCardsCoroutine()
    if #selectedCards == neededCards then
        self.editButton({index=4, font_size=110, label='Finished reading your\n layout? Press the "Shuffle"\n button to reset the deck.'})
        for i,v in ipairs(selectedCards) do
            v.flip()
            for i=1, 10,1 do coroutine.yield(0) end
        end
        for i=1, 60,1 do coroutine.yield(0) end
        if layout == "Single Card" then
            return 1
        elseif layout == "Three Card" then
            return 1
        elseif layout == "Five Card" then
            local cardPos = {
                {0.00, 1.41, -14.67},
                {-2.27, 1.41, -14.67},
                {2.28, 1.41, -14.67},
                {0.00, 1.41, -17.98},
                {0.00, 1.41, -11.41},
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                v.setPositionSmooth(cardPos[i])
                for i=1, 15,1 do coroutine.yield(0) end
            end
        elseif layout == "Celtic Cross" then
            local cardPos = {
                {-1.64, 1.45, -14.32},
                {-1.63, 1.60, -14.24},
                {-1.64, 1.50, -17.45},
                {-3.95, 1.50, -14.32},
                {-1.64, 1.50, -11.12},
                {0.66, 1.50, -14.32},
                {3.36, 1.50, -19.18},
                {3.36, 1.50, -15.97},
                {3.36, 1.50, -12.77},
                {3.36, 1.50, -9.61}
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                v.setPositionSmooth(cardPos[i])
                selectedCards[2].setRotation({0,90,0})
                for i=1, 20,1 do coroutine.yield(0) end
            end
        elseif layout == "Tetraktys" then
            local cardPos = {
                {3.45, 1.51, -20.17},
                {1.15, 1.51, -20.16},
                {-1.19, 1.51, -20.16},
                {-3.56, 1.51, -20.16},
                {2.34, 1.51, -17.21},
                {0.00, 1.51, -17.21},
                {-2.38, 1.51, -17.21},
                {1.15, 1.51, -14.26},
                {-1.17, 1.51, -14.26},
                {0.00, 1.51, -11.22}
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                v.setPositionSmooth(cardPos[i])
                for i=1, 15,1 do coroutine.yield(0) end
            end
        elseif layout == "Astrological" then
            local cardPos = {
                {-5.28, 1.45, -15.50},
                {-3.54, 1.45, -17.10},
                {-1.74, 1.45, -18.60},
                {0.00, 1.45, -20.03},
                {1.69, 1.45, -18.60},
                {3.44, 1.45, -17.10},
                {5.20, 1.45, -15.50},
                {3.44, 1.45, -14.02},
                {1.69, 1.45, -12.32},
                {0.00, 1.45, -10.72},
                {-1.74, 1.45, -12.35},
                {-3.52, 1.45, -14.02},
                {0.00, 1.45, -15.50}
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                v.setPositionSmooth(cardPos[i])
                for i=1, 15,1 do coroutine.yield(0) end
            end
        elseif layout == "Planetary" then
            local cardPos = {
                {0.00, 1.45, -19.46},
                {-1.12, 1.45, -16.29},
                {-3.31, 1.45, -14.63},
                {-1.12, 1.45, -13.11},
                {0.00, 1.45, -9.91},
                {1.19, 1.45, -13.11},
                {3.28, 1.45, -14.63},
                {1.19, 1.45, -16.26}
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                v.setPositionSmooth(cardPos[i])
                for i=1, 15,1 do coroutine.yield(0) end
            end
        elseif layout == "Tree Of Life" then
            local cardPos = {
                {0.00, 1.47, -8.00},
                {2.44, 1.47, -9.77},
                {-2.50, 1.47, -9.72},
                {2.48, 1.47, -12.82},
                {-2.51, 1.47, -12.82},
                {0.00, 1.47, -14.44},
                {2.48, 1.47, -16.62},
                {-2.51, 1.47, -16.60},
                {0.00, 1.47, -18.61},
                {0.00, 1.47, -21.65}
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
            for i=1, 30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                if i >= 6 then
                    local targetPos = v.positionToWorld({0,0,0})
                    targetPos.x = targetPos.x + 4
                    targetPos.y = targetPos.y + 0.2
                    v.setPositionSmooth(targetPos)
                end
                if i <= 5 then
                    local targetPos = v.positionToWorld({0,0,0})
                    targetPos.x = targetPos.x - 4
                    targetPos.y = targetPos.y + 0.2
                    v.setPositionSmooth(targetPos)
                end
            end
            for i=1, 30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                v.setPositionSmooth(cardPos[i])
                for i=1, 15,1 do coroutine.yield(0) end
            end
        elseif layout == "Cross & Triangle" then
            local cardPos = {
                {0.00, 1.46, -11.26},
                {0.00, 1.46, -7.94},
                {2.27, 1.46, -9.52},
                {0.00, 1.46, -14.50},
                {-2.25, 1.46, -9.52},
                {-2.25, 1.46, -20.84},
                {2.27, 1.46, -20.84},
                {0.01, 1.46, -20.82},
                {0.00, 1.46, -17.70}
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                if i >= 5 then
                    local targetPos = v.positionToWorld({0,0,0})
                    targetPos.x = targetPos.x + 5
                    targetPos.y = targetPos.y + 0.2
                    v.setPositionSmooth(targetPos)
                end
                if i <= 4 then
                    local targetPos = v.positionToWorld({0,0,0})
                    targetPos.x = targetPos.x - 4
                    targetPos.y = targetPos.y + 0.2
                    v.setPositionSmooth(targetPos)
                end
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                v.setPositionSmooth(cardPos[i])
                for i=1,15,1 do coroutine.yield(0) end
            end
        elseif layout == "Relationship Problems" then
            local cardPos = {
                {3.56, 1.45, -18.77},
                {3.56, 1.45, -15.58},
                {-3.59, 1.45, -18.77},
                {-3.58, 1.45, -15.58},
                {0.00, 1.45, -16.04},
                {0.00, 1.45, -12.78},
                {3.56, 1.45, -10.05},
                {0.00, 1.45, -9.49},
                {-3.59, 1.45, -10.05},
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in pairs(selectedCards) do
                v.setPositionSmooth(cardPos[i])
                for i=1,15,1 do coroutine.yield(0) end
            end
        elseif layout == "Past Life" then
            local cardPos = {
                {0.00, 1.46, -7.74},
                {-2.18, 1.46, -10.70},
                {0.00, 1.46, -10.70},
                {2.10, 1.46, -10.70},
                {-2.17, 1.46, -13.64},
                {0.00, 1.46, -13.64},
                {2.10, 1.46, -13.64},
                {-2.17, 1.46, -16.61},
                {0.00, 1.46, -16.61},
                {2.10, 1.46, -16.61},
                {-1.15, 1.46, -19.60},
                {1.08, 1.46, -19.60},
                {-1.14, 1.46, -22.48},
                {1.07, 1.46, -22.48}
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                if i >= 8 then
                    local targetPos = v.positionToWorld({0,0,0})
                    targetPos.x = targetPos.x + 4
                    targetPos.y = targetPos.y + 0.2
                    v.setPositionSmooth(targetPos)
                end
                if i <= 7 then
                    local targetPos = v.positionToWorld({0,0,0})
                    targetPos.x = targetPos.x - 4
                    targetPos.y = targetPos.y + 0.2
                    v.setPositionSmooth(targetPos)
                end
            end
            for i=1,45,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                v.setPositionSmooth(cardPos[i])
                for i=1,15,1 do coroutine.yield(0) end
            end
        elseif layout == "Career Path" then
            local cardPos = {
                {0.91, 1.45, -12.01},
                {-0.91, 1.45, -12.01},
                {0.00, 1.45, -14.98},
                {2.81, 1.45, -17.91},
                {0.87, 1.45, -17.91},
                {-0.96, 1.45, -17.91},
                {-2.88, 1.45, -17.91}
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                v.setPositionSmooth(cardPos[i])
                for i=1,15,1 do coroutine.yield(0) end
            end
        elseif layout == "High Priestess" then
            local cardPos = {
                {-0.92, 1.45, -12.76},
                {0.93, 1.45, -12.76},
                {0.00, 1.45, -7.69},
                {-2.58, 1.45, -9.18},
                {2.64, 1.45, -9.18},
                {-2.58, 1.45, -16.32},
                {2.64, 1.45, -16.32},
                {0.00, 1.45, -19.79},
                {0.00, 1.45, -16.32}
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                if i >= 5 then
                    local targetPos = v.positionToWorld({0,0,0})
                    targetPos.x = targetPos.x + 5
                    targetPos.y = targetPos.y + 0.2
                    v.setPositionSmooth(targetPos)
                end
                if i <= 4 then
                    local targetPos = v.positionToWorld({0,0,0})
                    targetPos.x = targetPos.x - 4
                    targetPos.y = targetPos.y + 0.2
                    v.setPositionSmooth(targetPos)
                end
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                v.setPositionSmooth(cardPos[i])
                for i=1,15,1 do coroutine.yield(0) end
            end
        elseif layout == "Should you Shouldn't you" then
            local cardPos = {
                {-5.48, 1.45, -11.30},
                {-3.48, 1.45, -11.30},
                {-1.51, 1.45, -11.30},
                {1.30, 1.45, -11.30},
                {3.31, 1.45, -11.30},
                {5.30, 1.45, -11.30},
                {-3.48, 1.45, -14.43},
                {3.31, 1.45, -14.43},
                {0.00, 1.45, -18.33}
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                v.setPositionSmooth(cardPos[i])
                for i=1,15,1 do coroutine.yield(0) end
            end
        elseif layout == "Star Guide" then
            local cardPos = {
                {0.01, 1.45, -10.98},
                {-2.96, 1.45, -14.38},
                {3.05, 1.45, -14.38},
                {-2.96, 1.45, -19.98},
                {3.05, 1.45, -20.04},
                {0.01, 1.45, -17.18}
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                v.setPositionSmooth(cardPos[i])
                for i=1,15,1 do coroutine.yield(0) end
            end
        elseif layout == "Spiritual Guidance" then
            local cardPos = {
                {0.00, 1.45, -14.81},
                {-5.95, 1.45, -11.65},
                {-3.98, 1.45, -11.65},
                {-1.97, 1.45, -11.65},
                {0.00, 1.45, -11.65},
                {1.98, 1.45, -11.65},
                {3.98, 1.45, -11.65},
                {5.96, 1.45, -11.65}
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                v.setPositionSmooth(cardPos[i])
                for i=1,15,1 do coroutine.yield(0) end
            end
        elseif layout == "Birthday" then
            local cardPos = {
                {-3.61, 1.51, -11.21},
                {-1.21, 1.51, -11.21},
                {1.11, 1.51, -11.21},
                {3.35, 1.51, -11.21},
                {-2.42, 1.51, -14.41},
                {0.00, 1.51, -14.40},
                {2.25, 1.51, -14.41},
                {-1.49, 1.51, -17.51},
                {1.46, 1.51, -17.51}
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                v.setPositionSmooth(cardPos[i])
                for i=1,15,1 do coroutine.yield(0) end
            end
        elseif layout == "Mandala" then
            local cardPos = {
                {0.00, 1.51, -13.90},
                {1.28, 1.51, -11.00},
                {2.61, 1.51, -13.90},
                {1.28, 1.51, -16.76},
                {0.00, 1.51, -19.60},
                {-1.29, 1.51, -16.76},
                {-2.69, 1.51, -13.90},
                {-1.30, 1.51, -11.00},
                {0.00, 1.51, -8.11}
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                v.setPositionSmooth(cardPos[i])
                for i=1,15,1 do coroutine.yield(0) end
            end
        elseif layout == "Horseshoe" then
            local cardPos = {
                {-3.46, 1.51, -16.04},
                {-2.71, 1.51, -13.08},
                {-1.93, 1.51, -10.07},
                {0.00, 1.51, -9.31},
                {1.93, 1.51, -10.07},
                {2.76, 1.51, -13.08},
                {3.51, 1.51, -16.04},
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                v.setPositionSmooth(cardPos[i])
                for i=1,15,1 do coroutine.yield(0) end
            end
        elseif layout == "Opportunities &\nObstacles" then
            local cardPos = {
                {-1.88, 1.51, -13.87},
                {0.00, 1.51, -13.87},
                {1.86, 1.51, -13.87},
                {0.00, 1.51, -10.88},
                {-1.88, 1.51, -10.88},
                {0.00, 1.51, -16.83},
                {1.86, 1.51, -16.83},
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                v.setPositionSmooth(cardPos[i])
                for i=1,15,1 do coroutine.yield(0) end
            end
        elseif layout == "Money Problems" then
            local cardPos = {
                {0.00, 1.51, -12.07},
                {-3.24, 1.51, -15.01},
                {3.15, 1.51, -15.01},
                {-3.24, 1.51, -18.32},
                {3.15, 1.51, -18.32},
                {0.00, 1.51, -21.19},
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
            for i=1,30,1 do coroutine.yield(0) end
            for i,v in ipairs(selectedCards) do
                v.setPositionSmooth(cardPos[i])
                for i=1,15,1 do coroutine.yield(0) end
            end
        elseif layout == "Custom Cards" then
            local cardPos = {
                {-13.28, 1.41, -8.06},
                {-13.28, 1.41, -10.24},
                {-13.28, 1.41, -12.44},
                {13.27, 1.50, -7.77},
                {13.27, 1.50, -9.96},
                {13.27, 1.50, -12.23}
            }
            for i,v in ipairs(selectedCards) do
                local targetPos = v.positionToWorld({0,0,0})
                targetPos.z = targetPos.z + 6
                v.setPositionSmooth(targetPos)
            end
        end
    end
    return 1
end
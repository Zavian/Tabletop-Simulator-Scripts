--[[StartXML
<Defaults>
    <Image class="state" preserveAspect="true" onclick="manage_state(id)" />
    <Button class="condition" width="150" height="150" iconwidth="85" iconColor="White" onclick="UI_AddCondition(id)" onmouseenter="UI_ShowCondition(id)" onmouseexit="UI_DefaultCondition()" />
</Defaults>
<Panel id="hpPanel" position="0 30 -660" rotation="270 270 90" scale="3 3 3" visibility="Black">
    <ProgressBar id="hpBar" width="175" height="33" color="#000000E0" fillImageColor="#2ECC40" showPercentageText="false" percentage="100" />
    <Text id="hp" width="175" fontSize="34" color="#ffffff" text="" />
    <Text id="oldValue" position="130 0 0" width="60" fontSize="34" minWidth="80" color="#ffffff" text="" fontStyle="Bold" alignment="MiddleLeft" />
    <Text id="ac" position="-130 0 0" width="60" fontSize="34" minWidth="80" color="#ffffff" text="" fontStyle="Bold" />
    <Text id="movement" position="0 40 0" color="#ffffff" fontSize="34" text="Movement" />
    <Button id="tempHP" active="false" position="70 0 0" width="40" height="33" color="#6E74EA" fontSize="20" textColor="white" onclick="UI_ClickTMP" />
</Panel>
<InputField id="calculate" visibility="Black" scale="3 3 3" position="-60 -210 -660" height="60" width="80" fontSize="34" color="#FFFFFF99"></InputField>

<Button id="calculateButton" visibility="Black" scale="3 3 3" position="120 -210 -660" height="60" width="60" fontSize="34" color="#FFFFFF99">C</Button>
<Button id="calculateButtonHalf" visibility="Black" scale="3 3 3" position="120 -80 -660" height="30" width="60" fontSize="20" color="#ac0900aa">½</Button>

<Text id="rolled" visibility="Black" scale="1 1 1" position="60 160 -20" width="100" height="100" fontSize="40" color="#FFFFFF" text="" />
<Button id="hpButton" scale="1 1 1" position="0 30 -660" rotation="270 270 90" height="128" width="128" fontSize="0" color="#FF0000FF" visibility="White|Teal|Brown|Blue|Red|Purple|Orange|Pink|Yellow|Green" />


<Image raycasttarget="false" id="visualizeButton" scale="2.5 2.5 2.5" position="0 30 -980" rotation="270 270 90" height="0" width="0" fontSize="0" color="#FF0000FF" visibility="Black" />
<Image raycasttarget="false" id="visualizeButton2" scale="5 5 5" position="0 0 0" rotation="0 0 0" height="0" width="0" fontSize="0" color="#FF00ffff" visibility="Black" />

<HorizontalLayout scale="3 3 3" width="150" height="40" position="0 0 -950" rotation="270 270 90" id="states" childForceExpandWidth="false" childForceExpandHeight="false">
    <Image class="state" active="false" id="blinded" image="blinded" />
    <Image class="state" active="false" id="charmed" image="charmed" />
    <Image class="state" active="false" id="concentration" image="concentration" />
    <Image class="state" active="false" id="deafened" image="deafened" />
    <Image class="state" active="false" id="frightened" image="frightened" />
    <Image class="state" active="false" id="grappled" image="grappled" />
    <Image class="state" active="false" id="incapacitated" image="incapacitated" />
    <Image class="state" active="false" id="invisible" image="invisible" />
    <Image class="state" active="false" id="on fire" image="on fire" />
    <Image class="state" active="false" id="paralyzed" image="paralyzed" />
    <Image class="state" active="false" id="petrified" image="petrified" />
    <Image class="state" active="false" id="poisoned" image="poisoned" />
    <Image class="state" active="false" id="restrained" image="restrained" />
    <Image class="state" active="false" id="stunned" image="stunned" />
</HorizontalLayout>

<Button id="removeAreaBtn" visibility="Black" textColor="#ffffff" color="#00000099" fontSize="16" width="75" height="75" position="-250 -130 -660" onclick="UI_RemoveArea">Remove Area</Button>

<Button id="conditionMenuToggleBtn" visibility="Black" color="#FFFFFF99" fontSize="32" width="75" height="75" position="-250 -210 -660" onclick="UI_ConditionMenu">+</Button>
<Panel visibility="Black" id="ConditionMenu" active="false" width="550" height="425" position="-600 -250 -660" color="#ffffff99">
    <GridLayout id="condSelector" constraint="FixedColumnCount" constraintCount="5" startCorner="UpperRight" childAlignment="UpperRight" spacing="5" padding="10 10 10 10">
        <Button color="#ffffff" id="btn_blinded" class="condition" icon="blinded"></Button>
        <Button color="#ffffff" id="btn_charmed" class="condition" icon="charmed"></Button>
        <Button color="#ffffff" id="btn_concentration" class="condition" icon="concentration"></Button>
        <Button color="#ffffff" id="btn_deafened" class="condition" icon="deafened"></Button>
        <Button color="#ffffff" id="btn_frightened" class="condition" icon="frightened"></Button>
        <Button color="#ffffff" id="btn_grappled" class="condition" icon="grappled"></Button>
        <Button color="#ffffff" id="btn_incapacitated" class="condition" icon="incapacitated"></Button>
        <Button color="#ffffff" id="btn_invisible" class="condition" icon="invisible"></Button>
        <Button color="#ffffff" id="btn_on_fire" class="condition" icon="on fire"></Button>
        <Button color="#ffffff" id="btn_paralyzed" class="condition" icon="paralyzed"></Button>
        <Button color="#ffffff" id="btn_petrified" class="condition" icon="petrified"></Button>
        <Button color="#ffffff" id="btn_poisoned" class="condition" icon="poisoned"></Button>
        <Button color="#ffffff" id="btn_restrained" class="condition" icon="restrained"></Button>
        <Button color="#ffffff" id="btn_stunned" class="condition" icon="stunned"></Button>
    </GridLayout>
    <Button offsetXY="0 10" rectAlignment="LowerCenter" fontStyle="Bold" fontSize="32" color="#ffffff00" width="530" height="70" id="ConditionType">Condition</Button>
</Panel>

<Text id="BlackName" scale="3 3 3" fontSize="34" visibility="Black" text="Black Name" color="Black" position="0 -150 -200" rotation="270 270 90" fontStyle="Bold" outline="White" outlineSize="1 -1" />
<Text id="BlackRoll" scale="3 3 3" fontSize="34" visibility="Black" text="99" color="Black" position="0 -150 -350" rotation="270 270 90" fontStyle="Bold" outline="White" outlineSize="1 -1" />
StopXML--xml]]

local _imMonster = nil

function loadXML()
    local script = self.getLuaScript()
    local xml = script:sub(script:find("StartXML")+8, script:find("StopXML")-1)
    self.UI.setXml(xml)
    if not _imMonster then
        Wait.frames(function() adaptUI() end, 10)
    end
end

function adaptUI()
    self.UI.setAttribute("hpPanel", "position", "0 30 -300")
    self.UI.setAttribute("hpPanel", "scale", "1.5 1.5 1.5")

    self.UI.setAttribute("calculate", "scale", "1 1 1")
    self.UI.setAttribute("calculateButton", "scale", "1 1 1")
    self.UI.setAttribute("calculateButtonHalf", "scale", "1 1 1")
    self.UI.setAttribute("calculate", "position", "-40 -50 -270")
    self.UI.setAttribute("calculateButton", "position", "30 -50 -270")
    self.UI.setAttribute("calculateButtonHalf", "position", "30 -5 -270")

    self.UI.setAttribute("rolled", "scale", "1.5 1.5 1.5")

    self.UI.setAttribute("hpButton", "position", "0 30 -300")

    self.UI.setAttribute("visualizeButton", "scale", "1.5 1.5 1.5")
    self.UI.setAttribute("visualizeButton", "position", "0 30 -800")
    self.UI.setAttribute("visualizeButton2", "scale", "3 3 3")

    self.UI.setAttribute("states", "scale", "1.2 1.2 1.2")
    self.UI.setAttribute("states", "position", "0 0 -460")

    self.UI.setAttribute("removeAreaBtn", "scale", "0.4 0.4 0.4")
    self.UI.setAttribute("removeAreaBtn", "position", "-110 -30 -270")
    self.UI.setAttribute("removeAreaBtn", "textColor", "white")
    
    self.UI.setAttribute("conditionMenuToggleBtn", "scale", "0.4 0.4 0.4")
    self.UI.setAttribute("conditionMenuToggleBtn", "position", "-110 -60 -270")
    
    self.UI.setAttribute("ConditionMenu", "scale", "0.4 0.4 0.4")
    self.UI.setAttribute("ConditionMenu", "position", "-250 -40 -270")

    self.UI.setAttribute("BlackName", "position", "0 -40 -50")
    self.UI.setAttribute("BlackName", "scale", "1 1 1")
    self.UI.setAttribute("BlackRoll", "position", "0 -40 -100")
    self.UI.setAttribute("BlackRoll", "scale", "1 1 1")
end



local myData = {}
local initialized = false
local restored = false

local _tokenName = ""
local _tokenColor = nil
local _spawnedDie = nil
local _color = "Black"
local _bossSize = 1.0

local _vSize = "128"

local _token = nil
local _myAC = 0
local _myMod = 0

local _blackName = ""

local _myMovement = ""
local _mySide = ""

--local _states = {
--    ["player"] = {color = {0, 0, 0.545098}, state = 1},
--    ["enemy"] = {color = {0.517647, 0, 0.098039}, state = 2},
--    ["ally"] = {color = {0.039216, 0.368627, 0.211765}, state = 3},
--    ["neutral"] = {color = {0.764706, 0.560784, 0}, state = 4}
--}

local _myID = -1

local _UIInput = ""

local _master = nil

local _diePosition = {x = 105.85, y = 4.8, z = -0.01}

local currentHP = 0
local tempHP = 0
local maxHP = 0

function onLoad(save_state)
    _imMonster = self.type ~= "Tileset"

    local ypos = 0.2

    loadXML()

    self.createButton(
        {
            click_function = "resetFlyButton",
            function_owner = self,
            label = "+999",
            position = _imMonster and {x = 1.5, y = ypos, z = 1.6} or {x = 0.7, y = ypos, z = 0},
            rotation = {0, 180, 0},
            width = 750,
            height = 500,
            font_size = 323,
            color = {0,0.4550,0.8510, 1},
            font_color = {1, 1, 1, 1},
            tooltip = "Height",
            scale = _imMonster and {1, 1, 1} or {0.3, 0.3, 0.3}
        }
    )

    self.createButton(
        {
            click_function = "reset",
            function_owner = self,
            label = "R",
            position = _imMonster and {x = -1.61, y = ypos, z = 1.6} or {x = -0.8, y = ypos, z = 0},
            rotation = {0, 180, 0},
            width = 500,
            height = 500,
            font_size = 323,
            color = {1, 0, 0},
            font_color = {1, 1, 1},
            tooltip = "Reset Visualizer",
            scale = _imMonster and {1, 1, 1} or {0.3, 0.3, 0.3}
        }
    )

    self.createInput(
        {
            input_function = "name",
            function_owner = self,
            label = "Name",
            alignment = 3,
            position = {x = 0, y = ypos, z = _imMonster and -1.7 or -0.5},
            rotation = {0, 180, 0},
            width = 2200,
            height = 475,
            font_size = 380,
            validation = 1,
            scale = _imMonster and {1, 1, 1} or {0.3, 0.3, 0.3}
        }
    )

    -- self.addContextMenuItem("[b][3D9970]Visible[-][/b]", toggleVisibilityMenu, false)
    addContextMenus(false)

    myData = JSON.decode(save_state)
    if myData ~= nil then
        _restore(myData)
    end
end

function none() end

function _starter(params)
    self.setCustomObject(
        {
            image = params.image,
            image_scalar = params.boss_size
        }
    )
    self.reload()
end

function _init(params)
    initialized = true
    restored = false

    _master = params.master

    _token = params.obj
    currentHP = _token.hp
    maxHP = _token.maxhp
    _myID = _token.id
    _myAC = _token.ac
    _myMod = _token.atk
    _myMovement = _token.movement
    _mySide = _token.side
    _blackName = _token.blackName
    if not _imMonster then
        _bossSize = _token.bossSize
    end

    self.editInput({index = 0, value = _token.name})

    updateName()
    --create_die()

    setupUI()

    self.setScale({_token.size, _token.size, _token.size})
    updateSave()
end

local _visible = true
function toggleVisibilityMenu(player_color)
    if player_color ~= "Black" then
        return
    end

    local temp = not _visible

    local objs = Player["Black"].getSelectedObjects()
    for i = 1, #objs do
        local gm = objs[i].getGMNotes()
        if gm == "monster_token" or gm == "boss_token" then
            if objs[i] == self then
                toggleTokenVisibility({visible = temp})
            else
                objs[i].call("toggleTokenVisibility", {visible = temp})
            end
        end
    end
end

function toggleTokenVisibility(params)
    _visible = params.visible
    if _visible then
        self.setInvisibleTo({})
        self.highlightOn(Color.Green, 1)
    else
        self.setInvisibleTo(hideFromPlayersArray())
        self.highlightOn({221, 221, 221}, 1) -- silver color
    end

    self.UI.setAttribute("hpButton", "active", _visible)
    self.UI.setAttribute("states", "visibility", _visible and "" or "Black")

    local visibilityString = _visible and "[3D9970]Visible[-]" or "[FF4136]Invisible[-]"
    local menuString = "[b]" .. visibilityString .. "[/b]"
    -- need to do this since for some reason I can't edit context menues
    -- berserk, u can do better smh
    addContextMenus(true)
end

function addContextMenus(clear)
    if clear then
        self.clearContextMenu()
    end

    local visibilityString = _visible and "[3D9970]Visible[-]" or "[FF4136]Invisible[-]"
    local menuString = "[b]" .. visibilityString .. "[/b]"
    self.addContextMenuItem(menuString, toggleVisibilityMenu, false)
    self.addContextMenuItem("Fly Up", flyUp, true)
    self.addContextMenuItem("Fly Down", flyDown, true)
end

local _flyOffset = 0
local _floating = false
local _myPosition = nil
local OFFSET_VALUE = Grid.sizeX

function flyUp(player_color)
    if player_color ~= "Black" then
        return
    end
    _flyOffset = _flyOffset + OFFSET_VALUE
    setFloat()
end
function flyDown(player_color)
    if player_color ~= "Black" then
        return
    end
    if _floating then 
        _flyOffset = _flyOffset - OFFSET_VALUE
    end
    setFloat()
end

function resetFlyButton(obj, color)
    if color == "Black" then
        _flyOffset = 0
        setFloat()
    end
end

function setFloat()
    if _flyOffset == 0 then 
        _floating = false
        hideHeightButton()
    else 
        _floating = true 
        showHeightButton()
        setHeightText()
    end
end

function onUpdate()
    if _floating then
        if _myPosition == nil then
            _myPosition = self.getPosition()
        end

        self.setPositionSmooth({_myPosition.x, _myPosition.y + _flyOffset, _myPosition.z}, false, false)
    end
end

-- credits: https://steamcommunity.com/sharedfiles/filedetails/?id=2454472719

function onPickUp(pcolor)
    _floating = false
    destabilize()
    createMoveToken(pcolor, self)
end

function onDrop(dcolor)
    stabilize()
    _myPosition = self.getPosition()
    setFloat()
    destroyMoveToken()
end

function stabilize()
    local rb = self.getComponent("Rigidbody")
    rb.set("freezeRotation", true)
end

function destabilize()
    local rb = self.getComponent("Rigidbody")
    rb.set("freezeRotation", false)
end

function destroyMoveToken()
    if string.match(tostring(myMoveToken), "Custom") then
        destroyObject(myMoveToken)
    end
end

function createMoveToken(mcolor, mtoken)
    destroyMoveToken()
    tokenRot = Player[mcolor].getPointerRotation()
    movetokenparams = {
        image = "http://cloud-3.steamusercontent.com/ugc/1021697601906583980/C63D67188FAD8B02F1B58E17C7B1DB304B7ECBE3/",
        thickness = 0.1,
        type = 2
    }
    startloc = mtoken.getPosition()
    local hitList =
        Physics.cast(
        {
            origin = mtoken.getBounds().center,
            direction = {0, -1, 0},
            type = 1,
            max_distance = 10,
            debug = false
        }
    )
    for _, hitTable in ipairs(hitList) do
        -- Find the first object directly below the mini
        if hitTable ~= nil and hitTable.point ~= nil and hitTable.hit_object ~= mtoken then
            startloc = hitTable.point
            break
        end
    end
    tokenScale = {
        x = Grid.sizeX / 2.2,
        y = 0.1,
        z = Grid.sizeX / 2.2
    }
    spawnparams = {
        type = "Custom_Tile",
        position = startloc,
        rotation = {x = 0, y = tokenRot, z = 0},
        scale = tokenScale,
        sound = false
    }

    local moveToken = spawnObject(spawnparams)
    moveToken.setLock(true)
    moveToken.setCustomObject(movetokenparams)
    mtoken.setVar("myMoveToken", moveToken)
    moveToken.setVar("measuredObject", mtoken)
    moveToken.setVar("myPlayer", mcolor)
    moveToken.setVar("className", "MeasurementToken_Move")
    moveToken.interactable = false
    moveToken.setInvisibleTo(hideFromPlayersArray())

    moveButtonParams = {
        click_function = "onLoad",
        function_owner = self,
        label = "00",
        position = {x = 0, y = 0.1, z = 0},
        width = 0,
        height = 0,
        font_size = 600
    }

    moveButton = moveToken.createButton(moveButtonParams)
    luaScript =
        "function onUpdate()self.interactable=false;local a=self.getPosition()if measuredObject==nil or measuredObject.held_by_color==nil then destroyObject(self)return end;local b=measuredObject.getPosition()local c=measuredObject.held_by_color;b.y=b.y-Player[myPlayer].lift_height*5;mdiff=a-b;if c then mDistance=math.abs(mdiff.x)zDistance=math.abs(mdiff.z)if zDistance>mDistance then mDistance=zDistance end;mDistance=mDistance*5.0/Grid.sizeX;mDistance=math.floor((mDistance+2.5)/5.0)*5;self.editButton({index=0,label=tostring(mDistance)})end end"
    moveToken.setLuaScript(luaScript)
end

-- end credits

function updateSave(value)
    myData = {
        name = _tokenName,
        cHP = currentHP,
        mHP = maxHP,
        AC = _myAC,
        MOD = _myMod,
        MOV = _myMovement,
        SIDE = _mySide,
        tCOLOR = _tokenColor,
        tHP = tempHP,
        blackName = _blackName
    }    
    self.script_state = JSON.encode(myData)
end

function _restore(data)
    initialized = true
    restored = true
    currentHP = data.cHP
    maxHP = data.mHP
    _myAC = data.AC
    _myMod = data.MOD
    _myMovement = data.MOV
    _mySide = data.SIDE
    _tokenColor = data.tCOLOR
    tempHP = data.tHP
    _blackName = data.blackName

    self.editInput({index = 0, value = data.name})
    updateName()
    setupUI()

    updateSave()
end

function onSave()
    if initialized then
        return self.script_state
    end
end

function setupUI()
    setHP()

    self.UI.setAttribute("ac", "text", "AC\n" .. _myAC)
    self.UI.setAttribute("movement", "text", _myMovement)
    self.UI.setAttribute("BlackRoll", "text", "")

    toggleVisualize({input = false})
    setOperation()

    -- change the color of the height button
    hideHeightButton()
end

function hideHeightButton()
    -- rgb(0, 0.454902, 0.85098)
    
    self.editButton({index = 0, font_color = {1,1,1,0}})
    self.editButton({index = 0, color = {0,0.4550,0.8510,0}})
end

function showHeightButton()
    self.editButton({index = 0, font_color = {1,1,1,1}})
    self.editButton({index = 0, color = {0,0.4550,0.8510,1}})
end

function setHeightText()
    local height_index = _flyOffset / OFFSET_VALUE
    self.editButton({index = 0, label = "+" .. height_index * 5})
end


function reset(obj, color)
    if color == "Black" then
        toggleVisualize({input = false})
    end
end

function setOperation()
    self.UI.setAttribute("calculate", "onEndEdit", self.getGUID() .. "/UIUpdateInput(value)")
    self.UI.setAttribute("calculateButton", "onClick", self.getGUID() .. "/UICalculate()")
    self.UI.setAttribute("calculateButtonHalf", "onClick", self.getGUID() .. "/UICalculate(true)")
end

function UICalculate(_, halved, _)
    halved = halved == "true"
    local tmp = false
    local input = _UIInput
    if string.find(input, ":") then -- tmp hp
        input = input:gsub(":", "")
        tempHP = tonumber(input)
        tmp = true
    elseif string.find(input, ";") then -- shield
        input = input:gsub(";", "")
        tempHP = tempHP + tonumber(input)
        tmp = true
    else
        local calc = tonumber(input)
        if halved then
            if calc > 0 then
                calc = math.floor(calc / 2)
            elseif calc < 0 then
                calc = math.ceil(calc / 2)
            end
            if calc == 0 then
                calc = -1
            end
        end
        HPMod(calc)
    end
    setHP()
    updateSave()
end

function HPMod(value)
    local calc = tonumber(value)
    if tempHP > 0 then
        if calc < 0 then
            tempHP = tempHP + calc
            if tempHP <= 0 then
                calc = tempHP
                tempHP = 0
            else
                calc = 0
            end
        end
    end
    currentHP = currentHP + calc
    if currentHP >= maxHP then
        currentHP = maxHP
    elseif currentHP < 0 then
        currentHP = 0
    end

    self.UI.setAttribute("oldValue", "text", calc)

    Wait.time(
        function()
            self.UI.setAttribute("oldValue", "text", "")
            self.UI.setAttribute("BlackRoll", "text", "")
        end,
        7
    )
    return calc
end

function GlobalCalculate(params)
    local i = params.input
    local t = params.t

    if t == "Temp" then
        tempHP = tonumber(i)
    else
        HPMod(tonumber(i))
    end
    setHP()
    updateSave()
end

function GlobalRoll(params)
    local mod = params.input
    local mode = params.mode
    local roll = 0
    if mode == "adv" then
        local r1,
            r2

        local seed = math.random() * os.time() -- some random number to make things random
        math.randomseed(seed) -- gotta set a seed that is always different else the rolls will be always the same

        r1 = math.random(1, 20)
        r2 = math.random(1, 20)
        roll = math.max(r1, r2)
    elseif mode == "dis" then
        local r1,
            r2

        local seed = math.random() * os.time() -- some random number to make things random
        math.randomseed(seed) -- gotta set a seed that is always different else the rolls will be always the same

        r1 = math.random(1, 20)
        r2 = math.random(1, 20)
        roll = math.min(r1, r2)
    else
        roll = math.random(1, 20)
    end

    local final = roll + mod
    final = final > 0 and final or 1

    self.UI.setAttribute("BlackRoll", "text", final)
end

function UIUpdateInput(player, value)
    _UIInput = value
    updateSave()
end

function setHP()
    self.UI.setAttribute("hp", "text", currentHP .. " / " .. maxHP)
    self.UI.setAttribute("hpBar", "percentage", (currentHP / maxHP) * 100)

    if tempHP > 0 then
        self.UI.setAttribute("tempHP", "active", "true")
        self.UI.setAttribute("tempHP", "text", tempHP)
        if tempHP >= 100 then
            if tempHP >= 1000 then
                self.UI.setAttribute("tempHP", "width", "80")
            else
                self.UI.setAttribute("tempHP", "width", "60")
            end
        else
            self.UI.setAttribute("tempHP", "width", "40")
        end
    else
        self.UI.setAttribute("tempHP", "active", "false")
    end

    setMyPercentage()
    updateSave()
end

function setMyPercentage()
    local _rough = "#FFDC00FF"
    local _very_rough = "#FF4136FF"
    local _fine = "#2ECC40FF"

    local color = _fine
    local p = ((currentHP + tempHP) / maxHP) * 100
    if p <= 25 then
        color = _very_rough
    elseif p <= 50 then
        color = _rough
    end

    self.UI.setAttribute("hpButton", "color", color)
    updateSave()
end

function updateTable(xmlTable)
    self.UI.setXmlTable(xmlTable)
    updateSave()
end

function destroy_all(obj, color, _, _skipUpdate)
    if color == _color or color == nil then
        self.destruct()
    else
        printToColor("m8 don't u even dare", color)
    end
end

function spawn_callback(spawned, name, color)
    spawned.setName(name)
    spawned.setColorTint(color)
    spawned.setDescription(_myMod)
    spawned.use_grid = false
end

--function take_initiative(spawned, name)
--    local i = getInitiative()
--    spawned.editInput({index=0, value=name.."\n"..i.value})
--    spawned.setDescription(i.value.."\n"..i.initiative.."+"..i.modifier)
--    initiative.set = true
--    initiative.obj = spawned
--end

function take_hp(spawned, name, color)
    spawned.editInput({index = 2, value = name})
    spawned.setColorTint(color)
    hp.set = true
    hp.obj = spawned
    _hpPosition = {x = 45.00, y = 3, z = -3.69}

    local difference = 3
    local zone = getObjectFromGUID(_hpZone)
    local objs = zone.getObjects()
    for i = 0, #objs do
        local obj = objs[i]
        if obj then
            if obj.getName() == _hpname then
                obj.setPositionSmooth(_hpPosition, false, false)
                obj.setRotationSmooth({0, 270, 0}, false, true)
                _hpPosition.z = _hpPosition.z + difference
            end
        end
    end
    spawned.use_grid = false
end

function getInitiative()
    local modifier = tonumber(getObjectFromGUID(_notecard).getDescription())
    local initiative = math.random(1, 20)
    local v = initiative + modifier
    if v == 0 then
        v = 1
    end
    return {value = v, initiative = initiative, modifier = modifier}
end

function updateName()
    _tokenName = self.getInputs()[1].value
    self.setName(_tokenName)
    if not _tokenColor then
        _tokenColor = randomColor()
        self.setColorTint(_tokenColor)
    end

    self.UI.setAttribute("BlackName", "text", _blackName and _blackName or "")
end

function name(obj, color, input, stillEditing)
    if not stillEditing then
        _tokenName = input
        self.setName(input)

        if not _tokenColor then
            _tokenColor = randomColor()
            obj.setColorTint(_tokenColor)
        end
        if _spawnedDie then
            _spawnedDie.setName(_tokenName)
        end
    end
end

function randomColor()
    local color = {r = 0, g = 0, b = 0}
    if _mySide == "ally" then
        local ally = {
            {r = 154, g = 205, b = 50},
            {r = 85, g = 107, b = 47},
            {r = 107, g = 142, b = 35},
            {r = 124, g = 252, b = 0},
            {r = 127, g = 255, b = 0},
            {r = 173, g = 255, b = 47},
            {r = 0, g = 100, b = 0},
            {r = 0, g = 128, b = 0},
            {r = 34, g = 139, b = 34},
            {r = 0, g = 255, b = 0},
            {r = 50, g = 205, b = 50},
            {r = 144, g = 238, b = 144},
            {r = 152, g = 251, b = 152},
            {r = 143, g = 188, b = 143}
        }
        color = ally[math.random(1, #ally)]
    elseif _mySide == "enemy" then
        local enemy = {
            {r = 128, g = 0, b = 0},
            {r = 139, g = 0, b = 0},
            {r = 165, g = 42, b = 42},
            {r = 178, g = 34, b = 34},
            {r = 220, g = 20, b = 60},
            {r = 255, g = 0, b = 0},
            {r = 255, g = 99, b = 71},
            {r = 255, g = 127, b = 80},
            {r = 205, g = 92, b = 92},
            {r = 240, g = 128, b = 128},
            {r = 233, g = 150, b = 122},
            {r = 250, g = 128, b = 114},
            {r = 255, g = 160, b = 122},
            {r = 255, g = 69, b = 0}
        }
        color = enemy[math.random(1, #enemy)]
    elseif _mySide == "neutral" then
        local neutral = {
            {r = 255, g = 215, b = 0},
            {r = 184, g = 134, b = 11},
            {r = 218, g = 165, b = 32},
            {r = 238, g = 232, b = 170},
            {r = 189, g = 183, b = 107},
            {r = 240, g = 230, b = 140},
            {r = 255, g = 255, b = 0}
        }
        color = neutral[math.random(1, #neutral)]
    end

    return {r = color.r / 255, g = color.g / 255, b = color.b / 255}
end

function randomRotation()
    --Credit for this function goes to Revinor (forums)
    --Get 3 random numbers
    local u1 = math.random()
    local u2 = math.random()
    local u3 = math.random()
    --Convert them into quats to avoid gimbal lock
    local u1sqrt = math.sqrt(u1)
    local u1m1sqrt = math.sqrt(1 - u1)
    local qx = u1m1sqrt * math.sin(2 * math.pi * u2)
    local qy = u1m1sqrt * math.cos(2 * math.pi * u2)
    local qz = u1sqrt * math.sin(2 * math.pi * u3)
    local qw = u1sqrt * math.cos(2 * math.pi * u3)
    --Apply rotation
    local ysqr = qy * qy
    local t0 = -2.0 * (ysqr + qz * qz) + 1.0
    local t1 = 2.0 * (qx * qy - qw * qz)
    local t2 = -2.0 * (qx * qz + qw * qy)
    local t3 = 2.0 * (qy * qz - qw * qx)
    local t4 = -2.0 * (qx * qx + ysqr) + 1.0
    --Correct
    if t2 > 1.0 then
        t2 = 1.0
    end
    if t2 < -1.0 then
        ts = -1.0
    end
    --Convert back to X/Y/Z
    local xr = math.asin(t2)
    local yr = math.atan2(t3, t4)
    local zr = math.atan2(t1, t0)
    --Return result
    return {math.deg(xr), math.deg(yr), math.deg(zr)}
end

function getLines(text)
    local returner = {}
    for s in text:gmatch("[^\r\n]+") do
        table.insert(returner, s)
    end
    return returner
end

function toggleVisualize(params)
    local t = params.input
    if t then
        --Player[params.color].pingTable(self.getPosition())
        self.UI.setAttribute("visualizeButton", "width", _vSize)
        self.UI.setAttribute("visualizeButton", "height", _vSize)
        self.UI.setAttribute("visualizeButton2", "width", _vSize)
        self.UI.setAttribute("visualizeButton2", "height", _vSize)
    else
        self.UI.setAttribute("visualizeButton", "width", "0")
        self.UI.setAttribute("visualizeButton", "height", "0")
        self.UI.setAttribute("visualizeButton2", "width", "0")
        self.UI.setAttribute("visualizeButton2", "height", "0")
    end
end

function UI_ConditionMenu(params)
    local v = self.UI.getAttribute("ConditionMenu", "active")
    if v == "true" then
        self.UI.setAttribute("ConditionMenu", "active", "false")
    elseif v == "false" then
        self.UI.setAttribute("ConditionMenu", "active", "true")
    end
end

function UI_ClickTMP(params)
    HPMod(-tempHP)
    setHP()
    updateSave()
end

local _conditions = {
    blinded = {
        desc = "A blinded creature can't see and automatically fails any ability check that requires sight.\nAttack rolls against the creature have advantage, and the creature's attack rolls have disadvantage.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275757198/B9460859AEC458C86D9657C1E2B1580623F8B5BC/"
    },
    charmed = {
        desc = "A charmed creature can't attack the charmer or target the charmer with harmful abilities or magical effects.\nThe charmer has advantage on any ability check to interact socially with the creature.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275760191/6D2618C57A6A8D5752E50125742B960D0D414D6D/"
    },
    concentration = {
        desc = "Whenever you take damage while you are concentrating on a spell, you must make a Constitution saving throw to maintain your Concentration. The DC equals 10 or half the damage you take, whichever number is higher. If you take damage from multiple sources, such as an arrow and a dragon’s breath, you make a separate saving throw for each source of damage.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275760557/8157E260CED63CE99037D31D371B2F5A132CAA11/"
    },
    deafened = {
        desc = "A deafened creature can't hear and automatically fails any ability check that requires hearing.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275760974/AC8120DF8234240B586A9BD4DA9CD35C52DFF29D/"
    },
    frightened = {
        desc = "A frightened creature has disadvantage on ability checks and attack rolls while the source of its fear is within line of sight.\nThe creature can't willingly move closer to the source of its fear.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275761396/8C91C898822015B04A84DF5D906C1D168775BF1E/"
    },
    grappled = {
        desc = "A grappled creature's speed becomes 0, and it can't benefit from any bonus to its speed.\nThe condition ends if the grappler is incapacitated.\nThe condition also ends if an effect removes the grappled creature from the reach of the grappler or grappling effect, such as when a creature is hurled away by the thunderwave spell.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275761896/5F051E43B6A18D016B30EA7743A55FE4F9A09B8F/"
    },
    incapacitated = {
        desc = "An incapacitated creature can't take actions or reactions.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275762313/53D74876998BEE4A165CEBFF9B368731F71E5BCD/"
    },
    invisible = {
        desc = "An invisible creature is impossible to see without the aid of magic or a special sense. For the purpose of hiding, the creature is heavily obscured. The creature's location can be detected by any noise it makes or any tracks it leaves.\nAttack rolls against the creature have disadvantage, and the creature's attack rolls have advantage.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275762789/7E623448A878DC2413455BEF0F9424636CB684B6/"
    },
    on_fire = {
        desc = "A creature who is on fire takes 2d6 damage at the start of each of their turns.\nThe creature sheds bright light in a 20-foot radius and dim light for an additional 20 feet.\nThe effect can be ended early with the Extinguish action.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275763230/067BB26B3F9F76BD16053956D7617A25697F9B44/"
    },
    paralyzed = {
        desc = "A paralyzed creature is incapacitated and can't move or speak.\nThe creature automatically fails Strength and Dexterity saving throws.\nAttack rolls against the creature have advantage.\nAny attack that hits the creature is a critical hit if the attacker is within 5 feet of the creature.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275763685/0015B9C114E51C9FDDA0BB646DEE5C2D33BA3996/"
    },
    petrified = {
        desc = "A petrified creature is transformed, along with any nonmagical object it is wearing or carrying, into a solid inanimate substance (usually stone). Its weight increases by a factor of ten, and it ceases aging.\nThe creature is incapacitated, can't move or speak, and is unaware of its surroundings.\nAttack rolls against the creature have advantage.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275764185/EECDE8DEC9F8652B7C039D25465E8005F27EADD6/"
    },
    poisoned = {
        desc = "A poisoned creature has disadvantage on attack rolls and ability checks.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275764643/52B35B1737B0E3B7CF037E15F4BEED36FB72385B/"
    },
    restrained = {
        desc = "A restrained creature's speed becomes 0, and it can't benefit from any bonus to its speed.\nAttack rolls against the creature have advantage, and the creature's attack rolls have disadvantage.\nThe creature has disadvantage on Dexterity saving throws.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275765227/4AC985009CE1EE4CB2D3797194FD6E57567C3951/"
    },
    stunned = {
        desc = "A stunned creature is incapacitated, can't move, and can speak only falteringly.\nThe creature automatically fails Strength and Dexterity saving throws.\nAttack rolls against the creature have advantage.",
        image = "http://cloud-3.steamusercontent.com/ugc/772860839275765722/2700DCCA22E84BA5297581E0B5C75581616D92E8/"
    }
}

function manage_state(player, request, v)
    -- request is the requested variable (in this case ID)
    -- v is the value of said variable. in this case we are in the button
    if player.color == "Black" then
        self.UI.setAttribute(v, "active", "false")
        self.UI.setAttribute("btn_" .. v:gsub(" ", "_"), "color", "#ffffff")
    else
        printToColor(v .. ": " .. _conditions[(v:gsub(" ", "_"))].desc, player.color, {r = 1, g = 1, b = 1})
    end
end

local areaObj = nil
function onCollisionEnter(info)
    local obj = info.collision_object
    if obj ~= nil then
        local name = obj.getName()
        if name ~= "" and name ~= nil then
            if isCondition((name:gsub(" ", "_"))) then
                if obj.tag == "Tile" or obj.tag == "GoPiece" then
                    self.UI.setAttribute(string.lower(obj.getName()), "active", "true")
                    obj.destruct()
                end
            elseif obj.getName() == "Clear Area" then
                removeArea()
            elseif isAreaObject(name) then
                makeJoined(obj)
            end
        end
    end
end

function makeJoined(obj)
    removeArea()

    obj.jointTo(
        self,
        {
            type = "Fixed",
            collision = false
        }
    )
    obj.setVar("parent", self)
    obj.setLuaScript(
        'function onLoad()(self.getComponent("BoxCollider")or self.getComponent("MeshCollider")).set("enabled",false)Wait.condition(function()(self.getComponent("BoxCollider")or self.getComponent("MeshCollider")).set("enabled",false)end,function()return not self.loading_custom end)end;function onUpdate()if parent~=nil then if not parent.resting then self.setPosition(parent.getPosition())local a=parent.getScale()if a.x<=1 then self.setScale({x=1.70,y=0.01,z=1.70})end end else self.destruct()end end'
    )
    obj.getComponent("MeshRenderer").set("receiveShadows", false)
    obj.mass = 0
    obj.bounciness = 0
    obj.drag = 0
    obj.use_snap_points = false
    obj.use_grid = false
    obj.use_gravity = false
    obj.auto_raise = false
    obj.sticky = false
    obj.interactable = true
    Wait.time(
        function()
            local s = obj.getScale()
            obj.setScale({x = s.x, y = 0.01, z = s.z})
            obj.setRotationSmooth({x = 0, y = obj.getRotation().y, z = 0}, false, true)
            areaObj = obj
        end,
        0.5
    )
end

function removeArea()
    if areaObj then
        areaObj.destruct()
        areaObj = nil
    end
end

function isAreaObject(name)
    local areas = {
        "10'r",
        "15'r",
        "20'r",
        "30'r",
        "40'r",
        "10'cone",
        "15'cone",
        "30'cone",
        "60'cone",
        "10'c",
        "15'c",
        "20'c",
        "30'c",
        "40'c"
    }
    for i = 1, #areas do
        if name == areas[i] then
            return true
        end
    end
    return false
end

function UI_RemoveArea(player)
    removeArea()
end

function UI_AddCondition(player, request, id)
    local condition = string.lower(string.gsub(id, "btn_", ""))

    local color = self.UI.getAttribute(id, "color")
    if color == "#00ff00" then -- is selected
        -- need to remove condition
        color = "#ffffff"
        self.UI.setAttribute(condition:gsub("_", " "), "active", "false")
    else
        -- add condition
        local newPos = self.getPosition()
        newPos.y = newPos.y + 4
        local custom_object = {
            type = "go_game_piece_black",
            position = newPos,
            callback_function = function(obj)
                obj.setName(condition:gsub("_", " "))
            end
        }
        spawnObject(custom_object)

        color = "#00ff00"
    end

    self.UI.setAttribute(id, "color", color)

    self.UI.setAttribute("ConditionMenu", "active", "false")
end

function UI_ShowCondition(player, request, id)
    local condition = string.lower(string.gsub(id, "btn_", ""))
    condition = condition:gsub("_", " ")
    condition = condition:gsub("^%l", string.upper)
    self.UI.setAttribute("ConditionType", "text", condition)
end

function UI_DefaultCondition()
    self.UI.setAttribute("ConditionType", "text", "Condition")
end

function isCondition(condition)
    if condition ~= nil then
        condition = string.lower(condition)
        if _conditions[condition] ~= nil then
            return _conditions[condition].desc ~= nil
        else
            return nil
        end
    end
end

function hideFromPlayersArray()
    return {
        "White",
        "Brown",
        "Red",
        "Orange",
        "Yellow",
        "Green",
        "Teal",
        "Blue",
        "Purple",
        "Pink",
        "Grey"
    }
end
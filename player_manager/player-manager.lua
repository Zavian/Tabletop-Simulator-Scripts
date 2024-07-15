--[[StartXML
<Defaults>
<Button class="heal" colors="#2ECC40|#55DF65|#43A34E|gray" TextColor="white" textAlignment="MiddleCenter" FontSize="25" />
<Button class="damage" colors="#FF4136|#FB8881|#C93931|gray" TextColor="black" textAlignment="MiddleCenter" FontSize="25" />
<InputField textAlignment="MiddleCenter" FontSize="30" placeholder=" " />
<Button class="condition" width="150" height="150" iconWidth="85" iconColor="White" onclick="UI_AddCondition(id)" onmouseenter="UI_ShowCondition(id)" onmouseexit="UI_DefaultCondition()" />
<Button class="shape" width="150" height="150" iconWidth="85" iconColor="White" onclick="UI_AddCondition(id)" onmouseenter="UI_ShowCondition(id)" onmouseexit="UI_DefaultCondition()" fontSize="25" fontStyle="Bold" textColor="#353c45" />
<Button class="reminder" width="150" height="65" fontSize="26" />
</Defaults>


<Panel showAnimation="FadeIn" position="440 0 -50" width="650" height="300" rotation="0 0 0" color="#FFFFFF50" id="main">
<Button width="230" height="75" position="-200 80 0" class="heal" text="HEAL" id="healButton" />
<InputField width="230" height="75" position="-200 0 0" id="hpVariance" text="" />
<Button width="230" height="75" position="-200 -80 0" class="damage" text="DAMAGE" id="damageButton" />

<Text text="CURRENT" width="105" height="75" FontSize="20" color="#E4E4E4" position="-10 55 0" />
<InputField width="105" height="75" position="-20 0 0" id="currentHP" colors="#FFFFFF20|#E4E4E4|#FFFFFF|gray" text="" />

<Text text="/" width="10" height="75" FontSize="32" position="50 0 0" color="#E4E4E4" />

<Text text="MAX" width="105" height="75" FontSize="20" color="#E4E4E4" position="110 55 0" />
<InputField width="105" height="75" position="110 0 0" id="maxHP" colors="#FFFFFF20|#E4E4E4|#FFFFFF|gray" text="" />

<Text text="HIT POINTS" FontSize="25" FontStyle="Bold" position="50 -80 0" />

<Text text="TEMP" width="105" height="75" FontSize="20" color="#E4E4E4" position="230 55 0" />
<InputField width="105" height="75" position="230 0 0" id="tempHP" colors="#FFFFFF20|#E4E4E4|#FFFFFF|gray" text="" placeholder="--" />

</Panel>

<Panel showAnimation="FadeIn" id="ConditionMenu" width="550" height="425" position="-310 0 -50" color="#FFFFFF50" scale=".75 .75 .75">
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

<Panel showAnimation="FadeIn" id="ReminderMenu" width="435" height="155" position="0 -280 -50" color="#FFFFFF50" scale=".75 .75 .75">
<Text offsetXY="0 60" fontStyle="Bold" fontSize="28" color="#00000FF">Manage Reminders</Text>
<Button class="reminder" offsetXY="-90 0" onClick="UI_ManageStartReminder">Start</Button>
<Button class="reminder" offsetXY="90 0" onClick="UI_ManageEndReminder">End</Button>
</Panel>
StopXML--xml]]


local linked = nil

local elements = {
    heal = "healButton",
    damage = "damageButton",
    half = "damageHalfButton",
    hp = "currentHP",
    maxhp = "maxHP",
    temphp = "tempHP",
    varhp = "hpVariance",
    mini = {
        bar = "hpBar",
        temphp = "tmpHP",
        status = "status"
    }
}

function loadXML()
    local script = self.getLuaScript()
    local xml = script:sub(script:find("StartXML")+8, script:find("StopXML")-1)
    self.UI.setXml(xml)
    
    Wait.frames(function()
        local guid = self.getGUID()
        self.UI.setAttribute(elements.heal, "onClick", guid .. "/UIHealButton_Click()")
        self.UI.setAttribute(elements.damage, "onClick", guid .. "/UIDamageButton_Click()")
        self.UI.setAttribute(elements.half, "onClick", guid .. "/UIDamageHalfButton_Click()")
        self.UI.setAttribute(elements.varhp, "onEndEdit", guid .. "/VarHPEndEdit(value)")
        self.UI.setAttribute(elements.hp, "onEndEdit", guid .. "/CurrentHPEndEdit(value)")
        self.UI.setAttribute(elements.maxhp, "onEndEdit", guid .. "/MaxHPEndEdit(value)")
        self.UI.setAttribute(elements.temphp, "onEndEdit", guid .. "/TempHPEndEdit(value)")
        
        self.UI.hide("main")
        self.UI.hide("ConditionMenu")
        self.UI.hide("ReminderMenu")
    end, 20)
end

function onLoad()
    loadXML()
    self.createButton(
    {
        click_function = "InjectMini",
        function_owner = self,
        label = "Link",
        position = {0, 0.4, 0},
        rotation = {180, 0, 180},
        scale = {0.5, 0.5, 0.5},
        width = 1800,
        height = 1200,
        font_size = 400,
        color = {0.18, 0.8, 0.25, 1}
    }
)
end

function UIHealButton_Click(player, value, id)
    local v = tonumber(self.UI.getAttribute(elements.varhp, "text"))
    local c = tonumber(self.UI.getAttribute(elements.hp, "text"))
    local m = tonumber(self.UI.getAttribute(elements.maxhp, "text"))
    
    if v == nil or c == nil or m == nil then
        broadcastToColor("You have to fill in the numbers!", player.color, {r = 1, g = 1, b = 1})
        return
    end
    local newhp = c + v
    if newhp > m then
        newhp = m
    end
    
    self.UI.setAttribute(elements.hp, "text", newhp)
    if linked then
        linked.hp = newhp
        linked.object.UI.setAttribute(elements.mini.bar, "percentage", (newhp / linked.maxHP) * 100)
        setPercentage(linked.object, linked.hp, linked.maxHP)
    end
end

function calculateDamage(value, temp_hp, current_hp, player)
    -- give the broadcast now as temporary hp damage is still calculated into the dc
    -- https://twitter.com/JeremyECrawford/status/503958007177166848
    if isUnderCondition("concentration") then
        broadcastToColor(
        string.format(
        "You have taken [b]%s[/b] damage.\nYou need to succeed on a DC [FF4136][b]%s[/b][-] concentration check.",
        value,
        calcConcentrationCheck(value)
    ),
    player.color,
    Color.White
)
end

if temp_hp ~= "" then
    temp_hp = tonumber(temp_hp)
    if temp_hp > 0 then
        
        local minusT = temp_hp - value
        if minusT > 0 then
            self.UI.setAttribute(elements.temphp, "text", minusT)
            if linked then
                linked.object.UI.setAttribute(elements.mini.temphp, "text", "TMP: " .. minusT)
            end
            value = 0
        elseif minusT < 0 then
            self.UI.setAttribute(elements.temphp, "text", "")
            if linked then
                linked.object.UI.setAttribute(elements.mini.temphp, "text", "")
            end
            value = -1 * minusT
        elseif minusT == 0 then
            self.UI.setAttribute(elements.temphp, "text", "")
            if linked then
                linked.object.UI.setAttribute(elements.mini.temphp, "text", "")
            end
            value = 0
        end
    end
end

local newhp = current_hp - value
if newhp < 0 then
    newhp = 0
end

self.UI.setAttribute(elements.hp, "text", newhp)
if linked then
    linked.hp = newhp
    linked.object.UI.setAttribute(elements.mini.bar, "percentage", (newhp / linked.maxHP) * 100)
    setPercentage(linked.object, linked.hp, linked.maxHP)
end
end

function UIDamageButton_Click(player, value, id)
    local v = tonumber(self.UI.getAttribute(elements.varhp, "text"))
    local t = self.UI.getAttribute(elements.temphp, "text")
    local c = tonumber(self.UI.getAttribute(elements.hp, "text"))
    
    if v == nil or c == nil then
        broadcastToColor("You have to fill in the numbers!", player.color, {r = 1, g = 1, b = 1})
        return
    end
    
    calculateDamage(v, t, c, player)
end

function UIDamageHalfButton_Click(player, value, id)
    local v = tonumber(self.UI.getAttribute(elements.varhp, "text"))
    local t = self.UI.getAttribute(elements.temphp, "text")
    local c = tonumber(self.UI.getAttribute(elements.hp, "text"))
    
    v = math.floor(v/2)
    
    if v == nil or c == nil then
        broadcastToColor("You have to fill in the numbers!", player.color, {r = 1, g = 1, b = 1})
        return
    end
    
    calculateDamage(v, t, c, player)
    
end

function calcConcentrationCheck(damage)
    local dc = math.floor(damage / 2)
    if dc < 10 then
        dc = 10
    end
    
    return dc
end

function VarHPEndEdit(player, value)
    self.UI.setAttribute(elements.varhp, "text", value)
end

function CurrentHPEndEdit(player, value)
    self.UI.setAttribute(elements.hp, "text", value)
    if linked then
        linked.hp = value
        if linked.maxHP ~= nil then
            linked.object.UI.setAttribute(elements.mini.bar, "percentage", (value / linked.maxHP) * 100)
            setPercentage(linked.object, linked.hp, linked.maxHP)
        end
    end
end
function MaxHPEndEdit(player, value)
    self.UI.setAttribute(elements.maxhp, "text", value)
    if linked then
        linked.maxHP = value
        if linked.hp ~= nil then
            linked.object.UI.setAttribute(elements.mini.bar, "percentage", (linked.hp / value) * 100)
            setPercentage(linked.object, linked.hp, linked.maxHP)
        end
    end
end
function TempHPEndEdit(player, value)
    self.UI.setAttribute(elements.temphp, "text", value)
    if linked then
        linked.object.UI.setAttribute(elements.mini.temphp, "text", "TMP: " .. value)
        if tonumber(value) == 0 then
            linked.object.UI.setAttribute(elements.mini.temphp, "text", "")
        end
        setMyData(linked.object, linked.hp, linked.maxHP)
    end
end

local _OWNER_COLOR = ""

function getOwnerColor()
    return _OWNER_COLOR
end


function InjectMini(obj, color, alt_click)
    _OWNER_COLOR = color -- why at the top? so that it doesn't get fucked if another player presses it
    
    
    if self.getDescription() == "" then
        broadcastToColor("You have to set the ID, ask your DM what to do!", color, Color.White)
            return
        end
        if linked then
            Player[color].pingTable(linked.object.getPosition())
            broadcastToColor("You've already clicked me, no reason to click me again!", color, Color.White)
            return
        end
        
        
        local id = self.getDescription()
        local object = getObjectFromGUID(id)
        -- <Image raycasttarget="false" id="visualizeButton2" scale="5 5 5" position="0 0 0" rotation="0 0 0" height="0" width="0" fontSize="0" color="#FF00ffff" visibility="Black" />
        local xml = object.UI.getXmlTable()
        -- class="state" preserveAspect="true" onclick="manage_state(id)"
        local default = {
            tag = "Defaults",
            children = {
                {
                    tag = "Image",
                    attributes = {
                        class = "state",
                        preserveAspect = "true",
                        onclick = "manage_state(id)"
                    }
                }
            }
        }
        
        local visualizer = {
            tag = "Image",
            attributes = {
                raycasttarget = "false",
                id = elements.mini.status,
                position = "0 0 0",
                width = "210",
                height = "210",
                color = "#2ECC40"
            }
        }
        -- <ProgressBar id="hpBar" width="175" height="33" color="#000000E0" fillImageColor="#2ECC40" showPercentageText="false" percentage="100" />
        local bar = {
            tag = "ProgressBar",
            attributes = {
                id = elements.mini.bar,
                width = "255",
                height = "50",
                color = "#000000E0",
                fillImageColor = "#2ECC40",
                showPercentageText = "true",
                percentage = "37",
                position = "0 0 -300",
                rotation = "270 270 90",
                visibility = "White|Teal|Brown|Blue|Red|Purple|Orange|Pink|Yellow|Green"
            }
        }
        
        local tmp = {
            tag = "Text",
            attributes = {
                id = elements.mini.temphp,
                color = "#0074D9",
                text = "",
                position = "0 0 -360",
                rotation = "270 270 90",
                visibility = "White|Teal|Brown|Blue|Red|Purple|Orange|Pink|Yellow|Green",
                fontSize = "32"
            }
        }
        --<HorizontalLayout width="150" height="75" position="0 0 -250" rotation="270 270 90" id="states" childForceExpandWidth="false" childForceExpandHeight="false">
        --    <Image class="state" active="true" id="blinded" image="blinded" />
        --    <Image class="state" active="false" id="charmed" image="charmed" />
        --    <Image class="state" active="false" id="concentration" image="concentration" />
        --    <Image class="state" active="false" id="deafened" image="deafened" />
        --    <Image class="state" active="false" id="frightened" image="frightened" />
        --    <Image class="state" active="false" id="grappled" image="grappled" />
        --    <Image class="state" active="false" id="incapacitated" image="incapacitated" />
        --    <Image class="state" active="false" id="invisible" image="invisible" />
        --    <Image class="state" active="false" id="on fire" image="on fire" />
        --    <Image class="state" active="false" id="paralyzed" image="paralyzed" />
        --    <Image class="state" active="false" id="petrified" image="petrified" />
        --    <Image class="state" active="false" id="poisoned" image="poisoned" />
        --    <Image class="state" active="false" id="restrained" image="restrained" />
        --    <Image class="state" active="false" id="stunned" image="stunned" />
        --</HorizontalLayout>
        local conditions = {
            "blinded",
            "charmed",
            "concentration",
            "deafened",
            "frightened",
            "grappled",
            "incapacitated",
            "invisible",
            "on fire",
            "paralyzed",
            "petrified",
            "poisoned",
            "restrained",
            "stunned"
        }
        local layoutChildren = {}
        for i = 1, #conditions do
            local img = {
                tag = "Image",
                attributes = {
                    class = "state",
                    active = "false",
                    id = conditions[i],
                    image = conditions[i]
                }
            }
            table.insert(layoutChildren, img)
        end
        
        local layout = {
            tag = "HorizontalLayout",
            attributes = {
                width = "150",
                height = "40",
                position = "0 0 -370",
                rotation = "270 270 90",
                id = "states",
                childForceExpandWidth = "false",
                childForceExpandHeight = "false"
            },
            children = layoutChildren
        }
        table.insert(xml, default)
        table.insert(xml, visualizer)
        table.insert(xml, bar)
        table.insert(xml, tmp)
        table.insert(xml, layout)
        object.UI.setXmlTable(xml)
        
        local script =
        '-- This file is compatible with player-manager only, do not use it somewhere else\n\nlocal master = "' ..
            self.getGUID() .. '";'
            
            script =
            script ..
            [[
            local master_obj = nil
local areaObj = nil
            
function manage_state(player, request, v)
    -- request is the requested variable (in this case ID)
    -- v is the value of said variable. in this case we are in the button
    if master ~= "" then
        master_obj = getObjectFromGUID(master)
    end
    if player.color == "Black" then
        self.UI.setAttribute(v, "active", "false")
    else
        self.UI.setAttribute(v, "active", "false")
        master_obj.call("manage_condition", {c = v})
    end
end
            
function onCollisionEnter(info)
    if master ~= "" then
        master_obj = getObjectFromGUID(master)
    end
            
    if master_obj ~= nil then
        local obj = info.collision_object
        if isCondition((obj.getName():gsub(" ", "_"))) then
            self.UI.setAttribute(string.lower(obj.getName()), "active", "true")
            obj.destruct()
        elseif obj.getName() == "Clear Area" then
            removeArea()
        elseif isAreaObject(obj.getName()) then
            makeJoined(obj)
        elseif isReminderObject(obj.getName()) then
            processReminderObject(obj)
            obj.destruct()
        end
    end
end
            
function isReminderObject(name)
    if name == "reminder_start" or name == "reminder_end" then
        return true
    end
    return false
end
            
function processReminderObject(obj)
    local time = obj.getName():gsub("reminder_", "") == "start" and "start" or "end"
    
    master_obj.call("makeReminderFromParams", {time = "_" .. time, reminder = obj.getDescription()})    
            
    self.highlightOn(Color.White, 1.5)
    printToColor("[" .. self.getColorTint():toHex() .. "] (Reminder " .. time .. ") " 
    .. self.getName() .. "[-]: " .. obj.getDescription(), master_obj.call("getOwnerColor"), Color.White)
            
    Global.UI.setAttribute(self.getGUID(), "active", "true")
end
            
function isCondition(condition)
    condition = string.lower(condition)
    local conditions = {
        "blinded",
        "charmed",
        "concentration",
        "deafened",
        "frightened",
        "grappled",
        "incapacitated",
        "invisible",
        "on_fire",
        "paralyzed",
        "petrified",
        "poisoned",
        "restrained",
        "stunned"
    }
    for i = 1, #conditions do
        if conditions[i] == condition then
            return true
        end
    end
    return false
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
            
-- credits: https://steamcommunity.com/sharedfiles/filedetails/?id=2454472719
            
function onPickUp(pcolor)
    destabilize()
    createMoveToken(pcolor, self)
end
            
function onDrop(dcolor)
    stabilize()
    destroyMoveToken()
end
            
function stabilize()
    local rb = self.getComponent("Rigidbody")
    rb.set("freezeRotation", true)
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
            
function stabilize()
    local rb = self.getComponent("Rigidbody")
    rb.set("freezeRotation", true)
end
            
function destabilize()
    local rb = self.getComponent("Rigidbody")
    rb.set("freezeRotation", false)
end
    ]]
            -- script =
            -- 	script ..
            -- 	'local a=nil;local b=nil;function manage_state(c,d,e)if master~=""then a=getObjectFromGUID(master)end;if c.color=="Black"then self.UI.setAttribute(e,"active","false")else self.UI.setAttribute(e,"active","false")a.call("manage_condition",{c=e})end end;function onCollisionEnter(f)if master~=""then a=getObjectFromGUID(master)end;if a~=nil then local g=f.collision_object;if isCondition(g.getName():gsub(" ","_"))then self.UI.setAttribute(string.lower(g.getName()),"active","true")g.destruct()elseif g.getName()=="Clear Area"then removeArea()elseif isAreaObject(g.getName())then makeJoined(g)end end end;function isCondition(h)h=string.lower(h)local i={"blinded","charmed","concentration","deafened","frightened","grappled","incapacitated","invisible","on_fire","paralyzed","petrified","poisoned","restrained","stunned"}for j=1,#i do if i[j]==h then return true end end;return false end;function makeJoined(g)removeArea()g.jointTo(self,{type="Fixed",collision=false})g.setVar("parent",self)g.setLuaScript(\'function onLoad()(self.getComponent("BoxCollider")or self.getComponent("MeshCollider")).set("enabled",false)Wait.condition(function()(self.getComponent("BoxCollider")or self.getComponent("MeshCollider")).set("enabled",false)end,function()return not self.loading_custom end)end;function onUpdate()if parent~=nil then if not parent.resting then self.setPosition(parent.getPosition())local a=parent.getScale()if a.x<=1 then self.setScale({x=1.70,y=0.01,z=1.70})end end else self.destruct()end end\')g.getComponent("MeshRenderer").set("receiveShadows",false)g.mass=0;g.bounciness=0;g.drag=0;g.use_snap_points=false;g.use_grid=false;g.use_gravity=false;g.auto_raise=false;g.sticky=false;g.interactable=true;Wait.time(function()local k=g.getScale()g.setScale({x=k.x,y=0.01,z=k.z})g.setRotationSmooth({x=0,y=g.getRotation().y,z=0},false,true)b=g end,0.5)end;function removeArea()if b then b.destruct()b=nil end end;function isAreaObject(l)local m={"10\'r","15\'r","20\'r","30\'r","40\'r","10\'cone","15\'cone","30\'cone","60\'cone","10\'c","15\'c","20\'c","30\'c","40\'c"}for j=1,#m do if l==m[j]then return true end end;return false end'
            object.setLuaScript(script)
            linked = {object = object, id = id}
            
            --broadcastToColor("Pinging your miniature! Set your stats on the new panel now!", color, {r = 1, g = 1, b = 1})
            
            self.UI.show("main")
            if self.getName() ~= "" then
                if readMyData() == true then
                    broadcastToColor(
                    "I have found your mini and some data from last session. I used that data.",
                    color,
                    {r = 1, g = 1, b = 1}
                )
            else
                broadcastToColor(
                "Pinging your miniature! Set your stats on the new panel now!",
                color,
                {r = 1, g = 1, b = 1}
            )
        end
    end
    
    self.UI.show("ConditionMenu")
    --self.UI.show("ReminderMenu")
    
    Player[color].pingTable(linked.object.getPosition())
    
    self.createButton(
    {
        click_function = "removeArea",
        function_owner = self,
        label = "Remove\nArea",
        position = {0, 0.4, 1.18},
        rotation = {180, 0, 180},
        scale = {0.5, 0.5, 0.5},
        width = 1800,
        height = 800,
        font_size = 300,
        color = {1, 0.25, 0.21, 1},
        font_color = {1, 1, 1, 1},
        tooltip = "Remove\nArea"
    }
)

self.createButton(
{
    click_function = "toggleReminderManager",
    function_owner = self,
    label = "Reminders",
    position = {0, 0.4, -1.18},
    rotation = {180, 0, 180},
    scale = {0.5, 0.5, 0.5},
    width = 1800,
    height = 800,
    font_size = 300,
    color = {0.25, 0.35, 0.96, 1},
    font_color = {1, 1, 1, 1},
    tooltip = "Manage reminders"
}
)

Global.call(setPlayerManager, {color = color, guid = self.getGUID()})
end

function removeArea()
    linked.object.call("removeArea", nil)
end

function toggleReminderManager()
    local isActive = self.UI.getAttribute("ReminderMenu", "active")
    if isActive == "false" then -- i hate TTS and the fact this is a string https://www.youtube.com/watch?v=JeXbjhBTq7Y
        self.UI.show("ReminderMenu")
    else 
        self.UI.hide("ReminderMenu")
    end
end

function setPercentage(mini, currentHP, maxHP)
    local _rough = "#FFDC00FF"
    local _very_rough = "#FF4136FF"
    local _fine = "#2ECC40FF"
    local _dead = "#111111FF"
    
    local color = _fine
    local p = (currentHP / maxHP) * 100
    if p == 0 then
        color = _dead
    elseif p <= 25 then
        color = _very_rough
    elseif p <= 50 then
        color = _rough
    end
    
    mini.UI.setAttribute(elements.mini.status, "color", color)
    setMyData(mini, currentHP, maxHP)
end

function setMyData(mini, currentHP, maxHP)
    local miniName = mini.getName()
    if miniName then
        Wait.time(
        function()
            local newName = miniName .. "|" .. currentHP .. "/" .. maxHP
            local t = self.UI.getAttribute(elements.temphp, "text")
            if t ~= "0" and t ~= "" then
                newName = newName .. ":" .. t
            end
            self.setName(newName)
        end,
        0.5
    )
end
end

function readMyData(mini)
    local data = mysplit(self.getName(), "|")
    if #data == 2 then
        local name = data[1]
        local curHP = mysplit(data[2], "/")[1]
        local maxHP = mysplit(data[2], "/")[2]
        local t = ""
        
        if #mysplit(maxHP, ":") == 2 then
            t = mysplit(maxHP, ":")[2]
            maxHP = mysplit(maxHP, ":")[1]
        end
        --print(name)
        --print(curHP)
        --print(maxHP)
        
        self.UI.setAttribute(elements.hp, "text", curHP)
        self.UI.setAttribute(elements.maxhp, "text", maxHP)
        print(t)
        self.UI.setAttribute(elements.temphp, "text", t)
        if linked then
            linked.hp = curHP
            linked.maxHP = maxHP
            
            local waited = function()
                linked.object.UI.setAttribute(elements.mini.bar, "percentage", (curHP / maxHP) * 100)
                if t ~= "" then
                    linked.object.UI.setAttribute(elements.mini.temphp, "text", "TMP: " .. t)
                end
                setPercentage(linked.object, linked.hp, linked.maxHP)
            end
            
            Wait.time(waited, 0.5)
        end
        
        return true
    end
    return false
end

function isUnderCondition(conditionName)
    -- "blinded",
    -- "charmed",
    -- "concentration",
    -- "deafened",
    -- "frightened",
    -- "grappled",
    -- "incapacitated",
    -- "invisible",
    -- "on fire",
    -- "paralyzed",
    -- "petrified",
    -- "poisoned",
    -- "restrained",
    -- "stunned"
    return self.UI.getAttribute("btn_" .. conditionName:gsub(" ", "_"), "color") == "#00ff00"
end

function UI_AddCondition(player, request, id)
    local condition = string.lower(string.gsub(id, "btn_", ""))
    
    local color = self.UI.getAttribute(id, "color")
    local active = linked.object.UI.getAttribute(condition:gsub("_", " "), "active")
    
    if color == "#00ff00" then -- is selected
        -- need to remove condition
        color = "#ffffff"
        linked.object.UI.setAttribute(condition:gsub("_", " "), "active", "false")
    else
        -- add condition
        
        local newPos = linked.object.getPosition()
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
    
    --self.UI.setAttribute("ConditionMenu", "active", "false")
end

function manage_condition(params)
    local condition = params.c
    condition = condition:gsub(" ", "_")
    self.UI.setAttribute("btn_" .. condition, "color", "#ffffff")
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

function UI_ManageStartReminder(player)
    local currentReminder = Global.call("getReminderForColor", {color = player.color, time = "_start"})
    player.showInputDialog("Set Start Reminder", currentReminder,
    function (text, player_color)
        Global.call("setReminderForColor", {color = player_color, reminder = text, time = "_start"})
        printToColor("Reminder set!", player_color, player_color)
    end)
end

function UI_ManageEndReminder(player)
    local currentReminder = Global.call("getReminderForColor", {color = player.color, time = "_end"})
    player.showInputDialog("Set End Reminder", currentReminder,
    function (text, player_color)
        Global.call("setReminderForColor", {color = player_color, reminder = text, time = "_end"})
        printToColor("Reminder set!", player_color, player_color)
    end)
end

function makeReminderFromParams(params)
    local time = params.time
    local reminder = params.reminder
    
    Global.call("setReminderForColor", {color = _OWNER_COLOR, reminder = reminder, time = time})
end

function mysplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
local set = nil
local areaObj = nil

function manage_state(player, request, v)
    -- request is the requested variable (in this case ID)
    -- v is the value of said variable. in this case we are in the button
    if master ~= "" then
        set = getObjectFromGUID(master)
    end
    if player.color == "Black" then
        self.UI.setAttribute(v, "active", "false")
    else
        self.UI.setAttribute(v, "active", "false")
        set.call("manage_condition", {c = v})
    end
end

function onCollisionEnter(info)
    if master ~= "" then
        set = getObjectFromGUID(master)
    end

    if set ~= nil then
        local obj = info.collision_object
        if isCondition((obj.getName():gsub(" ", "_"))) then
            self.UI.setAttribute(string.lower(obj.getName()), "active", "true")
            obj.destruct()
        elseif obj.getName() == "Clear Area" then
            removeArea()
        elseif isAreaObject(obj.getName()) then
            makeJoined(obj)
        end
    end
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

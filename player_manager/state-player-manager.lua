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
    --{
    --    collision_object = objectReference
    --    contact_points = {
    --        {x=5, y=0, z=-2, 5, 0, -2},
    --    }
    --    relative_velocity = {x=0, y=20, z=0, 0, 20, 0}
    --}
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

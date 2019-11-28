local linked = nil

local elements = {
    heal = "healButton",
    damage = "damageButton",
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

function onLoad()
    local guid = self.getGUID()

    self.UI.setAttribute(elements.heal, "onClick", guid .. "/UIHealButton_Click()")
    self.UI.setAttribute(elements.damage, "onClick", guid .. "/UIDamageButton_Click()")
    self.UI.setAttribute(elements.varhp, "onEndEdit", guid .. "/VarHPEndEdit(value)")
    self.UI.setAttribute(elements.hp, "onEndEdit", guid .. "/CurrentHPEndEdit(value)")
    self.UI.setAttribute(elements.maxhp, "onEndEdit", guid .. "/MaxHPEndEdit(value)")
    self.UI.setAttribute(elements.temphp, "onEndEdit", guid .. "/TempHPEndEdit(value)")

    self.UI.hide("main")

    self.createButton(
        {
            click_function = "InjectMini",
            function_owner = self,
            label = "Link",
            position = {0, 0.4, 0},
            rotation = {180, 0, 180},
            scale = {0.5, 0.5, 0.5},
            width = 1200,
            height = 1200,
            font_size = 400,
            color = {0.7984, 0.8693, 0.3922, 1}
        }
    )
end

function UIHealButton_Click(player, value, id)
    local v = tonumber(self.UI.getAttribute(elements.varhp, "text"))
    local c = tonumber(self.UI.getAttribute(elements.hp, "text"))
    local m = tonumber(self.UI.getAttribute(elements.maxhp, "text"))

    if v == nil or c == nil or m == nil then
        broadcastToColor("You have to fill in the numbers, you wanker!", player.color, {r = 1, g = 1, b = 1})
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

function UIDamageButton_Click(player, value, id)
    local v = tonumber(self.UI.getAttribute(elements.varhp, "text"))
    local t = self.UI.getAttribute(elements.temphp, "text")
    local c = tonumber(self.UI.getAttribute(elements.hp, "text"))

    if v == nil or c == nil then
        broadcastToColor("You have to fill in the numbers, you wanker!", player.color, {r = 1, g = 1, b = 1})
        return
    end

    if t ~= "" then
        t = tonumber(t)
        if t > 0 then
            local minusT = t - v
            if minusT > 0 then
                self.UI.setAttribute(elements.temphp, "text", minusT)
                if linked then
                    linked.object.UI.setAttribute(elements.mini.temphp, "text", "TMP: " .. minusT)
                end
                return
            elseif minusT < 0 then
                self.UI.setAttribute(elements.temphp, "text", "0")
                if linked then
                    linked.object.UI.setAttribute(elements.mini.temphp, "text", "")
                end
                v = -1 * minusT
            elseif minusT == 0 then
                self.UI.setAttribute(elements.temphp, "text", "0")
                if linked then
                    linked.object.UI.setAttribute(elements.mini.temphp, "text", "")
                end
                return
            end
        end
    end

    local newhp = c - v
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
    end
end

function InjectMini(obj, color, alt_click)
    if self.getDescription() == "" then
        broadcastToColor("You have to set the ID, ask your DM what to do!", color, {r = 1, g = 1, b = 1})
        return
    end
    if linked then
        Player[color].pingTable(linked.object.getPosition())
        broadcastToColor("You've already clicked me, no reason to click me again!", color, {r = 1, g = 1, b = 1})
        return
    end

    local id = self.getDescription()
    local object = getObjectFromGUID(id)
    -- <Image raycasttarget="false" id="visualizeButton2" scale="5 5 5" position="0 0 0" rotation="0 0 0" height="0" width="0" fontSize="0" color="#FF00ffff" visibility="Black" />
    local xml = object.UI.getXmlTable()
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
            position = "0 0 -250",
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
            position = "0 0 -310",
            rotation = "270 270 90",
            visibility = "White|Teal|Brown|Blue|Red|Purple|Orange|Pink|Yellow|Green",
            fontSize = "32"
        }
    }

    table.insert(xml, visualizer)
    table.insert(xml, bar)
    table.insert(xml, tmp)
    object.UI.setXmlTable(xml)

    linked = {object = object, id = id}

    broadcastToColor("Pinging your miniature! Set your stats on the new panel now!", color, {r = 1, g = 1, b = 1})
    Player[color].pingTable(linked.object.getPosition())

    self.UI.show("main")
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
end

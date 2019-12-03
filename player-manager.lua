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
    log(layout)
    table.insert(xml, default)
    table.insert(xml, visualizer)
    table.insert(xml, bar)
    table.insert(xml, tmp)
    table.insert(xml, layout)
    object.UI.setXmlTable(xml)
    log(object.UI.getXmlTable())

    local script =
        '-- This file is compatible with player-manager only, do not use it somewhere else\n\nlocal master = "' ..
        self.getGUID() ..
            '"\nlocal set = nil\n\nlocal _conditions = {\n    blinded = "A blinded creature can\'t see and automatically fails any ability check that requires sight.\\nAttack rolls against the creature have advantage, and the creature\'s attack rolls have disadvantage.",\n    charmed = "A charmed creature can\'t attack the charmer or target the charmer with harmful abilities or magical effects.\\nThe charmer has advantage on any ability check to interact socially with the creature.",\n    concentration = "Whenever you take damage while you are concentrating on a spell, you must make a Constitution saving throw to maintain your Concentration. The DC equals 10 or half the damage you take, whichever number is higher. If you take damage from multiple sources, such as an arrow and a dragon’s breath, you make a separate saving throw for each source of damage.",\n    deafened = "A deafened creature can\'t hear and automatically fails any ability check that requires hearing.",\n    frightened = "A frightened creature has disadvantage on ability checks and attack rolls while the source of its fear is within line of sight.\\nThe creature can\'t willingly move closer to the source of its fear.",\n    grappled = "A grappled creature\'s speed becomes 0, and it can\'t benefit from any bonus to its speed.\\nThe condition ends if the grappler is incapacitated.\\nThe condition also ends if an effect removes the grappled creature from the reach of the grappler or grappling effect, such as when a creature is hurled away by the thunderwave spell.",\n    incapacitated = "An incapacitated creature can\'t take actions or reactions.",\n    invisible = "An invisible creature is impossible to see without the aid of magic or a special sense. For the purpose of hiding, the creature is heavily obscured. The creature\'s location can be detected by any noise it makes or any tracks it leaves.\\nAttack rolls against the creature have disadvantage, and the creature\'s attack rolls have advantage.",\n    on_fire = "A creature who is on fire takes 2d6 damage at the start of each of their turns.\\nThe creature sheds bright light in a 20-foot radius and dim light for an additional 20 feet.\\nThe effect can be ended early with the Extinguish action.",\n    paralyzed = "A paralyzed creature is incapacitated and can\'t move or speak.\\nThe creature automatically fails Strength and Dexterity saving throws.\\nAttack rolls against the creature have advantage.\\nAny attack that hits the creature is a critical hit if the attacker is within 5 feet of the creature.",\n    petrified = "A petrified creature is transformed, along with any nonmagical object it is wearing or carrying, into a solid inanimate substance (usually stone). Its weight increases by a factor of ten, and it ceases aging.\\nThe creature is incapacitated, can\'t move or speak, and is unaware of its surroundings.\\nAttack rolls against the creature have advantage.",\n    poisoned = "A poisoned creature has disadvantage on attack rolls and ability checks.",\n    restrained = "A restrained creature\'s speed becomes 0, and it can\'t benefit from any bonus to its speed.\\nAttack rolls against the creature have advantage, and the creature\'s attack rolls have disadvantage.\\nThe creature has disadvantage on Dexterity saving throws.",\n    stunned = "A stunned creature is incapacitated, can\'t move, and can speak only falteringly.\\nThe creature automatically fails Strength and Dexterity saving throws.\\nAttack rolls against the creature have advantage."\n}\n\nfunction manage_state(player, request, v)\n    -- request is the requested variable (in this case ID)\n    -- v is the value of said variable. in this case we are in the button\n    if player.color == "Black" then\n        self.UI.setAttribute(v, "active", "false")\n    else\n        printToColor(v .. ": " .. _conditions[(v:gsub(" ", "_"))], player.color, {r = 1, g = 1, b = 1})\n    end\nend\n\nfunction onCollisionEnter(info)\n    --{\n    --    collision_object = objectReference\n    --    contact_points = {\n    --        {x=5, y=0, z=-2, 5, 0, -2},\n    --    }\n    --    relative_velocity = {x=0, y=20, z=0, 0, 20, 0}\n    --}\n    if master ~= "" then\n        set = getObjectFromGUID(master)\n    end\n\n    if set ~= nil then\n        local obj = info.collision_object\n        if isCondition((obj.getName():gsub(" ", "_"))) then\n            self.UI.setAttribute(string.lower(obj.getName()), "active", "true")\n            obj.destruct()\n        end\n    end\nend\n\nfunction isCondition(condition)\n    condition = string.lower(condition)\n    return _conditions[condition] ~= nil\nend\n'
    object.setLuaScript(script)
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

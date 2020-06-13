local set = nil

local _conditions = {
    blinded = "A blinded creature can't see and automatically fails any ability check that requires sight. Attack rolls against the creature have advantage, and the creature's attack rolls have disadvantage.",
    charmed = "A charmed creature can't attack the charmer or target the charmer with harmful abilities or magical effects. The charmer has advantage on any ability check to interact socially with the creature.",
    concentration = "Whenever you take damage while you are concentrating on a spell, you must make a Constitution saving throw to maintain your Concentration. The DC equals 10 or half the damage you take, whichever number is higher. If you take damage from multiple sources, such as an arrow and a dragon’s breath, you make a separate saving throw for each source of damage.",
    deafened = "A deafened creature can't hear and automatically fails any ability check that requires hearing.",
    frightened = "A frightened creature has disadvantage on ability checks and attack rolls while the source of its fear is within line of sight. The creature can't willingly move closer to the source of its fear.",
    grappled = "A grappled creature's speed becomes 0, and it can't benefit from any bonus to its speed. The condition ends if the grappler is incapacitated. The condition also ends if an effect removes the grappled creature from the reach of the grappler or grappling effect, such as when a creature is hurled away by the thunderwave spell.",
    incapacitated = "An incapacitated creature can't take actions or reactions.",
    invisible = "An invisible creature is impossible to see without the aid of magic or a special sense. For the purpose of hiding, the creature is heavily obscured. The creature's location can be detected by any noise it makes or any tracks it leaves. Attack rolls against the creature have disadvantage, and the creature's attack rolls have advantage.",
    on_fire = "A creature who is on fire takes 2d6 damage at the start of each of their turns. The creature sheds bright light in a 20-foot radius and dim light for an additional 20 feet. The effect can be ended early with the Extinguish action.",
    paralyzed = "A paralyzed creature is incapacitated and can't move or speak. The creature automatically fails Strength and Dexterity saving throws. Attack rolls against the creature have advantage. Any attack that hits the creature is a critical hit if the attacker is within 5 feet of the creature.",
    petrified = "A petrified creature is transformed, along with any nonmagical object it is wearing or carrying, into a solid inanimate substance (usually stone). Its weight increases by a factor of ten, and it ceases aging. The creature is incapacitated, can't move or speak, and is unaware of its surroundings. Attack rolls against the creature have advantage.",
    poisoned = "A poisoned creature has disadvantage on attack rolls and ability checks.",
    restrained = "A restrained creature's speed becomes 0, and it can't benefit from any bonus to its speed. Attack rolls against the creature have advantage, and the creature's attack rolls have disadvantage. The creature has disadvantage on Dexterity saving throws.",
    stunned = "A stunned creature is incapacitated, can't move, and can speak only falteringly. The creature automatically fails Strength and Dexterity saving throws. Attack rolls against the creature have advantage."
}

function measureButton()
    print("kek")
end

function _init()
    self.createButton(
        {
            click_function = "measureButton",
            function_owner = self,
            label = "M",
            position = {0, 0.1, 0.4},
            scale = {0.5, 0.5, 0.5},
            width = 500,
            height = 500,
            font_size = 400,
            color = {0.2598, 0.824, 0.4087, 1},
            tooltip = "Measure Distance"
        }
    )
end

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
        end
    end
end

function isCondition(condition)
    condition = string.lower(condition)
    return _conditions[condition] ~= nil
end

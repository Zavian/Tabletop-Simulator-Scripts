--Runs when the scripted button inside the button is clicked
function buttonPress()
    if lockout == false then
        local desc = self.getDescription()
        if desc ~= "" then
            local obj = getObjectFromGUID(desc)

            local notes = obj.getGMNotes()
            local pos = {}
            local rot = {}

            if notes == "" then
                pos = {115.27, 11.88, -79.46}
                rot = {347.94, 314.99, 0.35}
            else
                local vars = JSON.decode(notes)
                pos = {vars.pos.x, vars.pos.y, vars.pos.z}
                rot = {vars.rot.x, vars.rot.y, vars.rot.z}
            end
            obj.setPositionSmooth(pos, false, true)
            obj.setRotationSmooth(rot, false, true)
            obj.setLock(true)
            self.setDescription("")
        end

        self.AssetBundle.playTriggerEffect(0) --triggers animation/sound
        lockout = true --locks out the button
        startLockoutTimer() --Starts up a timer to remove lockout
    end
end

--Runs on load, creates button and makes sure the lockout is off
function onload()
    self.createButton(
        {
            label = "Big Red Button\n\nBy: MrStump",
            click_function = "buttonPress",
            function_owner = self,
            position = {0, 0.25, 0},
            height = 1400,
            width = 1400
        }
    )
    lockout = false
end

function onCollisionEnter(info)
    local obj = info.collision_object
    if obj.interactable then
        if obj.getGUID() then
            self.setDescription(obj.getGUID())
        end
    end
end

--Starts a timer that, when it ends, will unlock the button
function startLockoutTimer()
    Timer.create({identifier = self.getGUID(), function_name = "unlockLockout", delay = 0.5})
end

--Unlocks button
function unlockLockout()
    lockout = false
end

--Ends the timer if the object is destroyed before the timer ends, to prevent an error
function onDestroy()
    Timer.destroy(self.getGUID())
end

--Runs when the scripted button inside the button is clicked
function buttonPress()
    if lockout == false then
        tokens = {
            "ede93f", --erik
            "e5b5f7", --sai
            "3fe46d", --varan
            "374881", --chance
            "6ea5eb" --erreus
        }
        local coin = "a2f185" --coin
        local startingPoint = {x = -82.45, y = 5.18, z = 22.95}

        for i = 1, #tokens do
            --local token_info = tokens[i]
            local obj = getObjectFromGUID(tokens[i])
            local pos = startingPoint
            local rotation = {0, 90.00, 0}

            obj.setRotationSmooth(rotation, false, true)
            obj.setPositionSmooth(pos, false, false)

            startingPoint.z = startingPoint.z - 2.5
        end
        local obj = getObjectFromGUID(coin)
        obj.setRotationSmooth({0, 90.0, 0}, false, true)
        obj.setPositionSmooth({-87.35, 6.3, 12.09}, false, false)

        startingPoint = {x = -48.96, y = 3.5, z = 23.16}
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

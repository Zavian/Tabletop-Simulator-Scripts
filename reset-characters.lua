--Runs when the scripted button inside the button is clicked
function buttonPress()
    if lockout == false then
        local notes = self.getGMNotes()
        local j = JSON.decode(notes)

        local tokens = j.players
        local coin = j.coin
        local point = {
            x = j.startingPoint.x and j.startingPoint.x or self.getPosition().x,
            y = j.startingPoint.y and j.startingPoint.y or 5,
            z = j.startingPoint.z and j.startingPoint.z or self.getPosition().z
        }
        local coinPos = {
            x = j.coinPos.x and j.coinPos.x or self.getPosition().x,
            y = j.coinPos.y and j.coinPos.y or 5,
            z = j.coinPos.z and j.coinPos.z or self.getPosition().z
        }
        local spacing = j.spacing and j.spacing or 1.7

        for i = 1, #tokens do
            --local token_info = tokens[i]
            local obj = getObjectFromGUID(tokens[i])
            local pos = point
            local rotation = {0, 90.00, 0}

            obj.setRotationSmooth(rotation, false, true)
            obj.setPositionSmooth(pos, false, false)

            point.z = point.z - spacing
            if i % 3 == 0 then
                point.z = j.startingPoint.z and j.startingPoint.z or self.getPosition().z
                point.x = point.x + spacing
            end
        end
        local obj = getObjectFromGUID(coin)
        obj.setRotationSmooth({0, 90.0, 0}, false, true)
        obj.setPositionSmooth(coinPos, false, false)
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

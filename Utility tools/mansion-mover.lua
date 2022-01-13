local _floors = {
    [1] = {
        id = "c18d92",
        initial_pos = {x = 0.02, y = 1.18, z = -0.09}
    },
    [2] = {
        id = "7d3103",
        initial_pos = {x = 0.02, y = 1.48, z = -0.09}
    },
    [3] = {
        id = "94c856",
        initial_pos = {x = 0.02, y = 1.78, z = -0.09}
    }
}

function onLoad()
	dim_floor(_floors[2])

    self.createButton(
        {
            click_function = "show_all_floors",
            function_owner = self,
            label = "Show All Floors",
            position = {6, 0.6, 7},
            scale = {0.5, 0.5, 0.5},
            color = {0, 0.4117, 0.7058},
            width = 3000,
            height = 800,
            font_size = 400
        }
    )
	self.createButton({
	   click_function = 'toggle_first_floor',
	   function_owner = self,
	   label = '1st Floor',
	   position = {6.6, 0.6, 6.2},
	   scale = {0.3, 0.3, 0.3},
	   color = {0.2784, 0.7255, 0.2784},
	   width = 3000,
	   height = 800,
	   font_size = 400,
	   tooltip = 'Visible'
	})

	self.createButton({
	   click_function = 'toggle_second_floor',
	   function_owner = self,
	   label = '2nd Floor',
	   position = {6.6, 0.6, 5.7},
	   scale = {0.3, 0.3, 0.3},
	   color = {0.2784, 0.7255, 0.2784},
	   width = 3000,
	   height = 800,
	   font_size = 400,
	   tooltip = 'Visible'
	})

	self.createButton({
	   click_function = 'toggle_third_floor',
	   function_owner = self,
	   label = '3rd Floor',
	   position = {6.6, 0.6, 5.2},
	   scale = {0.3, 0.3, 0.3},
	   color = {0.2784, 0.7255, 0.2784},
	   width = 3000,
	   height = 800,
	   font_size = 400,
	   tooltip = 'Visible'
	})
end


local can_set = true
local showing_all = false

function move_floor(floor, offset)
    local obj = getObjectFromGUID(floor.id)
    local pos = obj.getPosition()
    local newPos = {
        x = pos.x + offset, 
        y = _floors[1].initial_pos.y, 
        z = pos.z
    }
    if obj then
        obj.setPositionSmooth(newPos, false, false)
    end
end

function reset_floor(floor)
	local obj = getObjectFromGUID(floor.id)
	local pos = floor.initial_pos
	if obj then
		obj.setPositionSmooth(pos, false, false)
	end
end

function mat_floor(floor)
	local obj = getObjectFromGUID(floor.id)
	if obj then
		obj.setColorTint({r = 1, g = 1, b = 1, a = 1})
	end
end

function dim_floor(floor)
	local obj = getObjectFromGUID(floor.id)
	if obj then
		obj.setColorTint({r = 0.5568, g = 0.5568, b = 0.5568, a = 1})
	end
end

function isVisible(floor_number)
	return self.getButtons()[floor_number+1].tooltip == 'Visible'
end

function toggle_floor(floor_number)
	local floor = _floors[floor_number]
	if isVisible(floor_number) then
		getObjectFromGUID(floor.id).setInvisibleTo({
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
			"Grey",
			"Black"
		})
		self.editButton({index = floor_number, tooltip = "Invisible", color = {r = 1, g = 0.2549, b = 0.2117}})
	else
		getObjectFromGUID(floor.id).setInvisibleTo({})
		self.editButton({index = floor_number, tooltip = "Visible", color = {0.2784, 0.7255, 0.2784}})
	end
end

function toggle_first_floor()
	toggle_floor(1)
end

function toggle_second_floor()
	toggle_floor(2)
end

function toggle_third_floor()
	toggle_floor(3)
	if isVisible(2) and not showing_all then
		mat_floor(_floors[2])
	end

	if isVisible(3) and not showing_all then
		dim_floor(_floors[2])
	end
end


function show_all_floors()
    local offset = 17
    if not showing_all then
		if can_set then
			_floors[1].initial_pos = getObjectFromGUID(_floors[1].id).getPosition()
			_floors[2].initial_pos = getObjectFromGUID(_floors[2].id).getPosition()
			_floors[3].initial_pos = getObjectFromGUID(_floors[3].id).getPosition()
			can_set = false
			Wait.time(function() can_set = true end, 10)			
		end

        move_floor(_floors[2], offset)
        move_floor(_floors[3], offset * -1)

		mat_floor(_floors[2])

		for i = 1, 3 do
			self.editButton({index = i, width = 0, height = 0, label = ""})
			getObjectFromGUID(_floors[i].id).setName(
				i == 1 and "1st Floor" 
				or i == 2 and "2nd Floor" 
				or "3rd Floor"
			)
		end
	else
		reset_floor(_floors[2])
		reset_floor(_floors[3])

		dim_floor(_floors[2])

		for i = 1, 3 do
			self.editButton({index = i, width = 3000, height = 800, 
				label = 
					i == 1 and "1st Floor" 
					or i == 2 and "2nd Floor" 
					or "3rd Floor"
				}
			)
			getObjectFromGUID(_floors[i].id).setName("")
		end
	end

	showing_all = not showing_all
end
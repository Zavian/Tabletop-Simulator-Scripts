function onLoad()
    self.createButton({
        click_function = 'showMemo',
        function_owner = self,
        label = 'MEMO',
        position = {0, 0, 0},
        rotation = {180, 180, 0},
        scale = {0.3, 0.3, 0.3},
        width = 1200,
        height = 800,
        font_size = 400,
        color = {1,0.863,0},
        tooltip = 'Show Memo'
    })
end

local _SAVED_GUID = null

function onCollisionEnter(collision_info)
    -- collision_info table:
    --   collision_object    Object
    --   contact_points      Table     {Vector, ...}
    --   relative_velocity   Vector
    if(not collision_info.collision_object.interactable) then return end
    if(collision_info.collision_object == self) then return end
    _SAVED_GUID = collision_info.collision_object.getGUID()
    print("GUID Found: ".._SAVED_GUID)
    collision_info.collision_object.highlightOn(Color.Green, 1)
end

function showMemo(obj, player_color) 
    if player_color ~= "Black" then return end
    if _SAVED_GUID == null then broadcastToColor("Must select an object first!", player_color, Color.red); return; end
    -- print(getObjectFromGUID(_SAVED_GUID).)
    
    local chosen_object = getObjectFromGUID(_SAVED_GUID)

    Player["Black"].showMemoDialog("Memo of " .. _SAVED_GUID, chosen_object.memo, 
        function(input, player_color)
            -- print(input)
            if input ~= chosen_object.memo then
                -- chosen_object.setDescription(input)
                Player["Black"].showConfirmDialog("Memo and text don't match, confirm change?", 
                    function()
                        broadcastToColor("Memo saved!", player_color, Color.green)
                        chosen_object.memo = input
                    end
                )
            end
        end
    )
end
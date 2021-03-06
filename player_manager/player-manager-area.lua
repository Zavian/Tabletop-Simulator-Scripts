function onLoad()
    (self.getComponent("BoxCollider") or self.getComponent("MeshCollider")).set("enabled", false)
    Wait.condition(
        function()
            (self.getComponent("BoxCollider") or self.getComponent("MeshCollider")).set("enabled", false)
        end,
        function()
            return not (self.loading_custom)
        end
    )
end
function onUpdate()
    if (parent ~= nil) then
        if (not parent.resting) then
            self.setPosition(parent.getPosition())

            local scale = parent.getScale()
            if scale.x <= 1 then -- minumum size for medium crea
                self.setScale({x = 1.70, y = 0.01, z = 1.70})
            end
        end
    else
        self.destruct()
    end
end

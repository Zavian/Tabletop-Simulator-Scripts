function onUpdate()
    self.interactable = false
    local mypos = self.getPosition()
    if measuredObject == nil or measuredObject.held_by_color == nil then
        destroyObject(self)
        return
    end
    local opos = measuredObject.getPosition()
    local oheld = measuredObject.held_by_color
    opos.y = opos.y - (Player[myPlayer].lift_height * 5)
    mdiff = mypos - opos
    if oheld then
        mDistance = math.abs(mdiff.x)
        zDistance = math.abs(mdiff.z)
        if zDistance > mDistance then
            mDistance = zDistance
        end
        mDistance = mDistance * (5.0 / Grid.sizeX)
        mDistance = (math.floor((mDistance + 2.5) / 5.0) * 5)
        self.editButton({index = 0, label = tostring(mDistance)})
    end
end

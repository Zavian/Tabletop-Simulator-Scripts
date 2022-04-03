function onload()
    local gm = self.getGMNotes()
    if gm == "" then
        self.setGMNotes("true")
        gm = "true"
    end

    if gm == "true" then
        self.addContextMenuItem("[2ECC40]Visible[-]", hideMe)
    else  
        self.addContextMenuItem("[FF4136]Invisible[-]", showMe)
    end
end

function hideMe()
    self.setGMNotes("false")
    self.setInvisibleTo(
        {
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
            "Grey"
        }
    )

    self.clearContextMenu()
    self.addContextMenuItem("[FF4136]Invisible[-]", showMe)
end

function showMe()
    self.setGMNotes("true")
    self.setInvisibleTo({})

    self.clearContextMenu()
    self.addContextMenuItem("[2ECC40]Visible[-]", hideMe)
end
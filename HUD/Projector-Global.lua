--#region projector
function toggleProjectorGUI(player, value, btn_id)
    local color = player.color:lower()
    self.UI.setAttribute("projector-panel-" .. color, "active", "false")
end
--#endregion

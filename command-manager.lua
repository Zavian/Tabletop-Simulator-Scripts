local _messages

function onLoad()
    updateMessages()
end

function updateMessages()
    _messages = {}    
    for _, containedObject in ipairs(self.getObjects()) do
        local command = containedObject.name
        local desc = containedObject.description

        table.insert(_messages, {command = command, desc = desc})

    end
end

function isContained(command)
    for i = 1, #_messages do
        if _messages[i].command == command then
            return _messages[i]
        end
    end

    return false
end

function onChat(message, player)
    local contained = isContained(message)

    if contained then
        createDialog(contained)
    end
end

function createDialog(message)
    Player["Black"].showMemoDialog(message.command, message.desc)
end

function onObjectEnterContainer(container, enter_object)
    if container == self then
        updateMessages()
    end
end

function onObjectLeaveContainer(container, leave_object)
    if container == self then
        updateMessages()
    end
end
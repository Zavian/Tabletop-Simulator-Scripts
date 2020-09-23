--calls to API events
function onLoad()
    proj = {
        --simple data structure for use by the projector
        hasloaded = true,
        debug = false,
        guid = 0,
        face_down = 0,
        on = false,
        color_active = "rgba(1,0,0,0.8)",
        color_inactive = "rgba(0,1,0,0.8)",
        style = {
            btn_color_active = "rgba(1.00, 0.00, 0.00, 0.8)",
            btn_color_inactive = "rgba(0.00, 1.00, 0.00, 0.8)",
            --
            title_text_color = "rgba(0.80, 0.80, 0.80, 1.0)",
            title_outline_color = "rgba(0.20, 0.20, 0.20, 1.0)",
            title_shadow_color = "rgba(0.90, 0.90, 0.90, 1.0)",
            --
            desc_text_color = "rgba(0.80, 0.80, 0.80, 1.0)",
            desc_outline_color = "rgba(0.20, 0.20, 0.20, 1.0)",
            desc_shadow_color = "rgba(0.20, 0.20, 0.20, 1.0)"
        },
        assets = resetCustomAssets(),
        about = [[
			This tool was written by stom, also known as Me, I'm Counting. More 
			information about it may be available on the authors website at 
			www.stom66.co.uk
			--
			It is available to use and redistribute for any means compatible with 
			the informal policy of "don't be a dick". If you make something particularly 
			cool, intersting or profitable then let me know.
			--
			Problems can be reported in the comments section of the Steam Workshop page.
		]]
    }
    if checkCustomAssets() then
        Wait.frames(drawGuis, 3)
    end
    --Wait.time(redrawGlobalGUI, 10, -1)
end

function onCollisionEnter(collision_info)
    --when an object collides with the projector we assign it as the current
    --object to be projected and trigger the assignObject function
    if proj and proj.hasloaded and proj.guid then
        local obj = collision_info.collision_object
        if proj.debug and obj.guid then
            log("Object " .. obj.guid .. " collider with projector")
        end
        if obj.tag == "Tile" or obj.tag == "Notecard" or obj.tag == "Tileset" then
            local title,
                desc = obj.getName(), obj.getDescription()
            assignObject(obj, obj.tag, title, desc)
        else
            if proj.debug then
                log(obj.tag)
            end
        end
    end
end

function onChat(msg, player)
    if msg == "!projector" then
        if not player.admin then
            return false
        end
        log("Resetting projector. Removing all custom assets")
        proj.assets = resetCustomAssets()

        local assets = assetsWithoutAdded()
        Global.UI.setCustomAssets(assets)
    end
end

function assetsWithoutAdded()
    local returner = {}
    local currentAssets = Global.UI.getCustomAssets()

    for i = 1, #currentAssets do
        local name = currentAssets[i].name
        if not name:find("|") then
            table.insert(returner, currentAssets[i])
        end
    end
    return returner
end

--custom asset management
--deals with adding new assets to the urrently loaded customassets
function checkCustomAssets()
    local currentAssets = Global.UI.getCustomAssets()
    for _, v in ipairs(proj.assets) do
        --cycle through each of the custom assets for the projector and add them to
        --global custom assets if they're not already present
        local found = false
        for _, vv in ipairs(currentAssets) do
            if vv.name == v.name and vv.url == v.url then
                found = true
                break
            end
        end
        if not found then
            table.insert(currentAssets, v)
            if proj.debug then
                log("Adding " .. v.name .. " to custom assets")
            end
        end
    end
    Global.UI.setCustomAssets(currentAssets)
    return true
end
function addCustomAsset(name, url)
    if proj.debug then
        log("addCustomAsset(" .. name .. ", " .. url .. ")")
    end
    --adds an asset to proj.assets and triggers its load
    if not name or not url then
        return false
    end
    table.insert(
        proj.assets,
        {
            name = tostring(name),
            url = tostring(url)
        }
    )
    if proj.debug then
        log("Added new asset to proj.assets: " .. name .. ": " .. url)
    end
    checkCustomAssets()
end
function resetCustomAssets()
    return {
        {
            name = "projector_cbh",
            url = "https://i.imgur.com/ETwxacC.png"
        },
        {
            name = "projector_close",
            url = "https://i.imgur.com/3r9AnD8.png"
        }
    }
end

--
-- Here be the main event.
-- assignObject is responsible for reading information from an object and
-- updating the internally generated XML UI with the appropriate values
-- and settings. If you're trying to make changes to what gets shown, chances
-- are this is the place to do it.
--
function assignObject(obj, tag, title, desc)
    if obj.guid and (obj.guid ~= proj.guid or proj.face_down ~= obj.is_face_down) then
        local colors = {"green", "purple", "red", "blue", "yellow", "brown", "white", "teal", "orange", "pink", "black"}
        proj.guid = obj.guid --save the target guid of the slide
        proj.face_down = obj.is_face_down --save the current fac up/down status so we can tell if it gets flipped
        flashObj(obj) --flash the object, make it easy to see

        if tag == "Tile" then
            --get custom object (p)arams and set some blank values
            local p = obj.getCustomObject()
            if proj.debug then
                log("obj.getCustomObject(" .. obj.guid .. ")")
                log(p)
            end

            --check for top and bottom images and add them to global assets
            if p.image and p.image ~= "" then
                addCustomAsset(obj.guid .. "|top", p.image)
            end
            if p.image_bottom and p.image_bottom ~= "" then
                addCustomAsset(obj.guid .. "|bottom", p.image_bottom)
            end

            --add suffix to image name when storing to account for double-sided tokens
            local suffix = "|top"
            if obj.is_face_down and p.image_bottom and p.image_bottom ~= "" then
                suffix = "|bottom"
            end

            --wait a few frames so that global assets can be updated before
            --updating the global UI with new values
            Wait.frames(
                function()
                    for i = 1, #colors do
                        Global.UI.setAttribute("pit-" .. colors[i], "text", title)
                        Global.UI.setAttribute("pid-" .. colors[i], "text", desc)
                        Global.UI.setAttribute("pi-" .. colors[i], "active", true)
                        Global.UI.setAttribute("pi-" .. colors[i], "image", obj.guid .. suffix)
                    end
                    --Wait.frames(redrawGlobalGUI, 5)
                end,
                5
            )
        elseif tag == "Tileset" then
            --Adds custom tile figurines
            local p = obj.getCustomObject()
            if proj.debug then
                log("obj.getCustomObject(" .. obj.guid .. ")")
                log(p)
            end

            --check for front and back images and add them to global assets
            if p.image and p.image ~= "" then
                addCustomAsset(obj.guid .. "|top", p.image)
            end
            if p.image_secondary and p.image_secondary ~= "" then
                addCustomAsset(obj.guid .. "|bottom", p.image_secondary)
            end

            --add suffix to image name when storing to account for double-sided tokens
            local suffix = "|top"
            if obj.is_face_down and p.image_secondary and p.image_secondary ~= "" then
                suffix = "|bottom"
            end

            --wait a few frames so that global assets can be updated before
            --updating the global UI with new values

            Wait.frames(
                function()
                    for i = 1, #colors do
                        Global.UI.setAttribute("pit-" .. colors[i], "text", title)
                        Global.UI.setAttribute("pid-" .. colors[i], "text", desc)
                        Global.UI.setAttribute("pi-" .. colors[i], "active", true)
                        Global.UI.setAttribute("pi-" .. colors[i], "image", obj.guid .. suffix)
                    end

                    --Global.UI.setAttribute("projector_img_title", "text", title)
                    --Global.UI.setAttribute("projector_img_desc", "text", desc)
                    --Global.UI.setAttribute("projector_img", "active", true)
                    --Global.UI.setAttribute("projector_img", "image", obj.guid..suffix)
                    --Wait.frames(redrawGlobalGUI, 5)
                end,
                5
            )
        elseif tag == "Notecard" then
            --get info from notecards and display
            --these dont need any delays as all they do is toggle existing elements and update their values with text
            for i = 1, #colors do
                Global.UI.setAttribute("pit-" .. colors[i], "text", title)
                Global.UI.setAttribute("pid-" .. colors[i], "text", desc)
                Global.UI.setAttribute("pi-" .. colors[i], "active", false)
            end
        end

        --spit out current values for debugging, if appropriate
        if proj.debug then
            log("assignObject(" .. obj.guid .. ", " .. tag .. "):")
            log("\t Title:" .. title)
            log("\t Description:" .. desc)
            if tag == "Tile" or tag == "Tileset" or tag == "Token" then
                log("\t Image: " .. Global.UI.getAttribute("projector_img", "image"))
            end
        end
    end
end

--simple function to flash an object a few times
function flashObj(obj, repetitions, flash_duration, interval, color)
    local r = repetitions or 5
    local d = flash_duration or 0.15
    local i = interval or 0.15
    local c = color or {0.2, 1, 0}
    local function flash()
        obj.highlightOn(c, d)
    end
    for f = 0, r - 1 do
        local t = f * (d + i)
        Wait.time(flash, t)
    end
end

--triggers the rawing of both local and Global XML UIs
function drawGuis()
    drawLocalGUI()
    --drawGlobalGUI()
end

--toggles the visibility of the projector (global XML UI) and plays a sound
function toggleGui(player, value, btn_id)
    local colors = {"green", "purple", "red", "blue", "yellow", "brown", "white", "teal", "orange", "pink", "black"}
    for i = 1, #colors do
        Global.UI.setAttribute("projector-panel-" .. colors[i], "active", "true")
    end
    self.UI.setAttribute("power", "color", proj.style.btn_color_active)
    self.AssetBundle.playTriggerEffect(0)
    --proj.on = not proj.on
    --if proj.on then
    --
    --else
    --    for i = 1, #colors do
    --        Global.UI.setAttribute("projector-panel-" .. colors[i], "active", "false")
    --    end
    --    self.UI.setAttribute("power", "color", proj.style.btn_color_inactive)
    --    self.AssetBundle.playTriggerEffect(1)
    --end
    --log("toggleGui: " .. tostring(proj.on))
end

function drawLocalGUI()
    --contains the XML UI for the local UI, specifically the visible
    --power button on top of the projector and the invisible power button
    --slightly beneath it

    self.UI.setXmlTable(
        {
            {
                tag = "Panel",
                attributes = {
                    active = true,
                    height = "250",
                    id = "projector-button",
                    position = "0 15 -69.5",
                    width = "250"
                },
                children = {
                    {
                        --Small power button
                        tag = "Button",
                        attributes = {
                            color = proj.style.btn_color_inactive,
                            height = "16",
                            id = "power",
                            onClick = self.guid .. "/toggleGui",
                            rectAlignment = "CenterMiddle",
                            tooltip = "Fuck my ass",
                            tooltipPosition = "Above",
                            width = "16"
                        }
                    },
                    {
                        --Big invisible button
                        tag = "Button",
                        attributes = {
                            active = true,
                            color = "rgba(0.1,0.1,0.1,0.1)",
                            height = "65",
                            onClick = self.guid .. "/toggleGui",
                            position = "0 0 1.5",
                            tooltip = "Toggle Projector",
                            tooltipPosition = "Above",
                            width = "50"
                        }
                    }
                }
            }
        }
    )
end
function redrawGlobalGUI()
    --less than ideal. bug with current xml ui means that images maintain their
    --properties after source has been changed. reading and re-applying the xml
    --fixes this.
    local xml = Global.UI.getXmlTable()
    Wait.frames(
        function()
            Global.UI.setXmlTable(xml)
        end,
        5
    )
end

function drawGlobalGUI()
    --contains the XML UI for the global UI, which is the slideshow itself
    Global.UI.setXmlTable(
        {
            {
                tag = "Panel",
                attributes = {
                    active = false,
                    childForceExpandHeight = false,
                    childForceExpandWidth = false,
                    height = "500",
                    id = "projector-panel",
                    raycastTarget = true,
                    rectAlignment = "MiddleCenter",
                    width = "500",
                    color = "#28282850",
                    allowDragging = "true",
                    returnToOriginalPositionWhenReleased = "false"
                },
                children = {
                    -- {	--background button at top right
                    -- 	tag        = "Button",
                    -- 	attributes = {
                    --         colors        = "#282828FF|#c8329bFF|#ff9b38FF|#00000000",
                    -- 		textColor     = "#f0f0f0ff",
                    -- 		height        = "82",
                    -- 		offsetXY      = "0 18",
                    -- 		rectAlignment = "UpperRight",
                    -- 		tooltip       = "Close the image",
                    --         width         = "75",
                    --         text          = "Close",
                    --         textAlignment = "LowerCenter",
                    --         onClick       = self.guid.."/toggleGui",
                    --     }
                    -- },
                    {
                        --close button at top right
                        tag = "Button",
                        attributes = {
                            colors = "#f0f0f0|#c8329bFF|#ff9b38FF|#00000000",
                            color = "rgba(0.94, 0.94, 0.94, 1)",
                            height = "64",
                            image = "projector_close",
                            offsetXY = "0 0",
                            onClick = self.guid .. "/toggleGui",
                            rectAlignment = "UpperRight",
                            tooltip = "Close the image",
                            width = "72",
                            textColor = "#f0f0f0"
                        }
                    },
                    {
                        tag = "VerticalLayout",
                        attributes = {
                            childAlignment = "MiddleCenter",
                            childForceExpandHeight = false,
                            childForceExpandWidth = false,
                            height = "100%",
                            rectAlignment = "MiddleCenter",
                            width = "100%",
                            spacing = "10"
                        },
                        children = {
                            {
                                --main title
                                tag = "Text",
                                attributes = {
                                    color = proj.style.title_text_color,
                                    fontSize = "48",
                                    fontStyle = "Bold",
                                    horizontalOverflow = "Wrap",
                                    id = "projector_img_title",
                                    outline = proj.style.title_outline_color,
                                    resizeTextForBestFit = true,
                                    shadow = proj.style.title_shadow_color,
                                    text = "Projector"
                                }
                            },
                            {
                                --main image
                                tag = "Image",
                                attributes = {
                                    active = true,
                                    flexibleHeight = false,
                                    flexibleWidth = false,
                                    id = "projector_img",
                                    image = "projector_cbh",
                                    preserveAspect = true,
                                    raycastTarget = false
                                }
                            },
                            {
                                --description
                                tag = "Text",
                                attributes = {
                                    alignment = "LowerCenter",
                                    color = proj.style.desc_text_color,
                                    fontSize = "22",
                                    horizontalOverflow = "Wrap",
                                    id = "projector_img_desc",
                                    outline = proj.style.desc_outline_color,
                                    shadow = proj.style.desc_shadow_color,
                                    rectAlignment = "LowerCenter",
                                    resizeTextForBestFit = false,
                                    text = "Drop an image tile, token, or a notecard onto the projector to load the image and associated text.\n\n Use the power button to toggle the image for all players."
                                }
                            }
                        }
                    }
                }
            }
        }
    )
end

local linked = nil

local elements = {
	heal = "healButton",
	damage = "damageButton",
	hp = "currentHP",
	maxhp = "maxHP",
	temphp = "tempHP",
	varhp = "hpVariance",
	mini = {
		bar = "hpBar",
		temphp = "tmpHP",
		status = "status"
	}
}

function onLoad()
	local guid = self.getGUID()

	self.UI.setAttribute(elements.heal, "onClick", guid .. "/UIHealButton_Click()")
	self.UI.setAttribute(elements.damage, "onClick", guid .. "/UIDamageButton_Click()")
	self.UI.setAttribute(elements.varhp, "onEndEdit", guid .. "/VarHPEndEdit(value)")
	self.UI.setAttribute(elements.hp, "onEndEdit", guid .. "/CurrentHPEndEdit(value)")
	self.UI.setAttribute(elements.maxhp, "onEndEdit", guid .. "/MaxHPEndEdit(value)")
	self.UI.setAttribute(elements.temphp, "onEndEdit", guid .. "/TempHPEndEdit(value)")

	self.UI.hide("main")
	self.UI.hide("ConditionMenu")

	self.createButton(
		{
			click_function = "InjectMini",
			function_owner = self,
			label = "Link",
			position = {0, 0.4, 0},
			rotation = {180, 0, 180},
			scale = {0.5, 0.5, 0.5},
			width = 1200,
			height = 1200,
			font_size = 400,
			color = {0.18, 0.8, 0.25, 1}
		}
	)
end

function UIHealButton_Click(player, value, id)
	local v = tonumber(self.UI.getAttribute(elements.varhp, "text"))
	local c = tonumber(self.UI.getAttribute(elements.hp, "text"))
	local m = tonumber(self.UI.getAttribute(elements.maxhp, "text"))

	if v == nil or c == nil or m == nil then
		broadcastToColor("You have to fill in the numbers, you wanker!", player.color, {r = 1, g = 1, b = 1})
		return
	end
	local newhp = c + v
	if newhp > m then
		newhp = m
	end

	self.UI.setAttribute(elements.hp, "text", newhp)
	if linked then
		linked.hp = newhp
		linked.object.UI.setAttribute(elements.mini.bar, "percentage", (newhp / linked.maxHP) * 100)
		setPercentage(linked.object, linked.hp, linked.maxHP)
	end
end

function UIDamageButton_Click(player, value, id)
	local v = tonumber(self.UI.getAttribute(elements.varhp, "text"))
	local t = self.UI.getAttribute(elements.temphp, "text")
	local c = tonumber(self.UI.getAttribute(elements.hp, "text"))

	if v == nil or c == nil then
		broadcastToColor("You have to fill in the numbers, you wanker!", player.color, {r = 1, g = 1, b = 1})
		return
	end

	if t ~= "" then
		t = tonumber(t)
		if t > 0 then
			local minusT = t - v
			if minusT > 0 then
				self.UI.setAttribute(elements.temphp, "text", minusT)
				if linked then
					linked.object.UI.setAttribute(elements.mini.temphp, "text", "TMP: " .. minusT)
				end
				v = 0
			elseif minusT < 0 then
				self.UI.setAttribute(elements.temphp, "text", "")
				if linked then
					linked.object.UI.setAttribute(elements.mini.temphp, "text", "")
				end
				v = -1 * minusT
			elseif minusT == 0 then
				self.UI.setAttribute(elements.temphp, "text", "")
				if linked then
					linked.object.UI.setAttribute(elements.mini.temphp, "text", "")
				end
				v = 0
			end
		end
	end

	local newhp = c - v
	if newhp < 0 then
		newhp = 0
	end

	self.UI.setAttribute(elements.hp, "text", newhp)
	if linked then
		linked.hp = newhp
		linked.object.UI.setAttribute(elements.mini.bar, "percentage", (newhp / linked.maxHP) * 100)
		setPercentage(linked.object, linked.hp, linked.maxHP)
	end
end

function VarHPEndEdit(player, value)
	self.UI.setAttribute(elements.varhp, "text", value)
end

function CurrentHPEndEdit(player, value)
	self.UI.setAttribute(elements.hp, "text", value)
	if linked then
		linked.hp = value
		if linked.maxHP ~= nil then
			linked.object.UI.setAttribute(elements.mini.bar, "percentage", (value / linked.maxHP) * 100)
			setPercentage(linked.object, linked.hp, linked.maxHP)
		end
	end
end
function MaxHPEndEdit(player, value)
	self.UI.setAttribute(elements.maxhp, "text", value)
	if linked then
		linked.maxHP = value
		if linked.hp ~= nil then
			linked.object.UI.setAttribute(elements.mini.bar, "percentage", (linked.hp / value) * 100)
			setPercentage(linked.object, linked.hp, linked.maxHP)
		end
	end
end
function TempHPEndEdit(player, value)
	self.UI.setAttribute(elements.temphp, "text", value)
	if linked then
		linked.object.UI.setAttribute(elements.mini.temphp, "text", "TMP: " .. value)
		if tonumber(value) == 0 then
			linked.object.UI.setAttribute(elements.mini.temphp, "text", "")
		end
		setMyData(linked.object, linked.hp, linked.maxHP)
	end
end

function InjectMini(obj, color, alt_click)
	if self.getDescription() == "" then
		broadcastToColor("You have to set the ID, ask your DM what to do!", color, {r = 1, g = 1, b = 1})
		return
	end
	if linked then
		Player[color].pingTable(linked.object.getPosition())
		broadcastToColor("You've already clicked me, no reason to click me again!", color, {r = 1, g = 1, b = 1})
		return
	end

	local id = self.getDescription()
	local object = getObjectFromGUID(id)
	-- <Image raycasttarget="false" id="visualizeButton2" scale="5 5 5" position="0 0 0" rotation="0 0 0" height="0" width="0" fontSize="0" color="#FF00ffff" visibility="Black" />
	local xml = object.UI.getXmlTable()
	-- class="state" preserveAspect="true" onclick="manage_state(id)"
	local default = {
		tag = "Defaults",
		children = {
			{
				tag = "Image",
				attributes = {
					class = "state",
					preserveAspect = "true",
					onclick = "manage_state(id)"
				}
			}
		}
	}

	local visualizer = {
		tag = "Image",
		attributes = {
			raycasttarget = "false",
			id = elements.mini.status,
			position = "0 0 0",
			width = "210",
			height = "210",
			color = "#2ECC40"
		}
	}
	-- <ProgressBar id="hpBar" width="175" height="33" color="#000000E0" fillImageColor="#2ECC40" showPercentageText="false" percentage="100" />
	local bar = {
		tag = "ProgressBar",
		attributes = {
			id = elements.mini.bar,
			width = "255",
			height = "50",
			color = "#000000E0",
			fillImageColor = "#2ECC40",
			showPercentageText = "true",
			percentage = "37",
			position = "0 0 -300",
			rotation = "270 270 90",
			visibility = "White|Teal|Brown|Blue|Red|Purple|Orange|Pink|Yellow|Green"
		}
	}

	local tmp = {
		tag = "Text",
		attributes = {
			id = elements.mini.temphp,
			color = "#0074D9",
			text = "",
			position = "0 0 -360",
			rotation = "270 270 90",
			visibility = "White|Teal|Brown|Blue|Red|Purple|Orange|Pink|Yellow|Green",
			fontSize = "32"
		}
	}
	--<HorizontalLayout width="150" height="75" position="0 0 -250" rotation="270 270 90" id="states" childForceExpandWidth="false" childForceExpandHeight="false">
	--    <Image class="state" active="true" id="blinded" image="blinded" />
	--    <Image class="state" active="false" id="charmed" image="charmed" />
	--    <Image class="state" active="false" id="concentration" image="concentration" />
	--    <Image class="state" active="false" id="deafened" image="deafened" />
	--    <Image class="state" active="false" id="frightened" image="frightened" />
	--    <Image class="state" active="false" id="grappled" image="grappled" />
	--    <Image class="state" active="false" id="incapacitated" image="incapacitated" />
	--    <Image class="state" active="false" id="invisible" image="invisible" />
	--    <Image class="state" active="false" id="on fire" image="on fire" />
	--    <Image class="state" active="false" id="paralyzed" image="paralyzed" />
	--    <Image class="state" active="false" id="petrified" image="petrified" />
	--    <Image class="state" active="false" id="poisoned" image="poisoned" />
	--    <Image class="state" active="false" id="restrained" image="restrained" />
	--    <Image class="state" active="false" id="stunned" image="stunned" />
	--</HorizontalLayout>
	local conditions = {
		"blinded",
		"charmed",
		"concentration",
		"deafened",
		"frightened",
		"grappled",
		"incapacitated",
		"invisible",
		"on fire",
		"paralyzed",
		"petrified",
		"poisoned",
		"restrained",
		"stunned"
	}
	local layoutChildren = {}
	for i = 1, #conditions do
		local img = {
			tag = "Image",
			attributes = {
				class = "state",
				active = "false",
				id = conditions[i],
				image = conditions[i]
			}
		}
		table.insert(layoutChildren, img)
	end

	local layout = {
		tag = "HorizontalLayout",
		attributes = {
			width = "150",
			height = "40",
			position = "0 0 -370",
			rotation = "270 270 90",
			id = "states",
			childForceExpandWidth = "false",
			childForceExpandHeight = "false"
		},
		children = layoutChildren
	}
	log(layout)
	table.insert(xml, default)
	table.insert(xml, visualizer)
	table.insert(xml, bar)
	table.insert(xml, tmp)
	table.insert(xml, layout)
	object.UI.setXmlTable(xml)
	log(object.UI.getXmlTable())

	local script =
		'-- This file is compatible with player-manager only, do not use it somewhere else\n\nlocal master = "' ..
		self.getGUID() .. '";'
	script =
		script ..
		'local a=nil;local b=nil;function manage_state(c,d,e)if master~=""then a=getObjectFromGUID(master)end;if c.color=="Black"then self.UI.setAttribute(e,"active","false")else self.UI.setAttribute(e,"active","false")a.call("manage_condition",{c=e})end end;function onCollisionEnter(f)if master~=""then a=getObjectFromGUID(master)end;if a~=nil then local g=f.collision_object;if isCondition(g.getName():gsub(" ","_"))then self.UI.setAttribute(string.lower(g.getName()),"active","true")g.destruct()elseif g.getName()=="Clear Area"then removeArea()elseif isAreaObject(g.getName())then makeJoined(g)end end end;function isCondition(h)h=string.lower(h)local i={"blinded","charmed","concentration","deafened","frightened","grappled","incapacitated","invisible","on_fire","paralyzed","petrified","poisoned","restrained","stunned"}for j=1,#i do if i[j]==h then return true end end;return false end;function makeJoined(g)removeArea()g.jointTo(self,{type="Fixed",collision=false})g.setVar("parent",self)g.setLuaScript(\'function onLoad()(self.getComponent("BoxCollider")or self.getComponent("MeshCollider")).set("enabled",false)Wait.condition(function()(self.getComponent("BoxCollider")or self.getComponent("MeshCollider")).set("enabled",false)end,function()return not self.loading_custom end)end;function onUpdate()if parent~=nil then if not parent.resting then self.setPosition(parent.getPosition())local a=parent.getScale()if a.x<=1 then self.setScale({x=1.70,y=0.01,z=1.70})end end else self.destruct()end end\')g.getComponent("MeshRenderer").set("receiveShadows",false)g.mass=0;g.bounciness=0;g.drag=0;g.use_snap_points=false;g.use_grid=false;g.use_gravity=false;g.auto_raise=false;g.sticky=false;g.interactable=true;Wait.time(function()local k=g.getScale()g.setScale({x=k.x,y=0.01,z=k.z})g.setRotationSmooth({x=0,y=g.getRotation().y,z=0},false,true)b=g end,0.5)end;function removeArea()if b then b.destruct()b=nil end end;function isAreaObject(l)local m={"10\'r","15\'r","20\'r","30\'r","40\'r","10\'cone","15\'cone","30\'cone","60\'cone","10\'c","15\'c","20\'c","30\'c","40\'c"}for j=1,#m do if l==m[j]then return true end end;return false end'
	object.setLuaScript(script)
	linked = {object = object, id = id}

	--broadcastToColor("Pinging your miniature! Set your stats on the new panel now!", color, {r = 1, g = 1, b = 1})

	self.UI.show("main")
	if self.getName() ~= "" then
		if readMyData() == true then
			broadcastToColor(
				"I have found your mini and some data from last session. I used that data.",
				color,
				{r = 1, g = 1, b = 1}
			)
		else
			broadcastToColor("Pinging your miniature! Set your stats on the new panel now!", color, {r = 1, g = 1, b = 1})
		end
	end

	self.UI.show("ConditionMenu")

	Player[color].pingTable(linked.object.getPosition())

	self.createButton(
		{
			click_function = "removeArea",
			function_owner = self,
			label = "Remove\nArea",
			position = {0, 0.4, 1.18},
			rotation = {180, 0, 180},
			scale = {0.5, 0.5, 0.5},
			width = 1200,
			height = 800,
			font_size = 300,
			color = {1, 0.25, 0.21, 1},
			font_color = {1, 1, 1, 1},
			tooltip = "Remove\nArea"
		}
	)
end

function removeArea()
	linked.object.call("removeArea", nil)
end

function setPercentage(mini, currentHP, maxHP)
	local _rough = "#FFDC00FF"
	local _very_rough = "#FF4136FF"
	local _fine = "#2ECC40FF"
	local _dead = "#111111FF"

	local color = _fine
	local p = (currentHP / maxHP) * 100
	if p == 0 then
		color = _dead
	elseif p <= 25 then
		color = _very_rough
	elseif p <= 50 then
		color = _rough
	end

	mini.UI.setAttribute(elements.mini.status, "color", color)
	setMyData(mini, currentHP, maxHP)
end

function setMyData(mini, currentHP, maxHP)
	local miniName = mini.getName()
	if miniName then
		Wait.time(
			function()
				local newName = miniName .. "|" .. currentHP .. "/" .. maxHP
				local t = self.UI.getAttribute(elements.temphp, "text")
				if t ~= "0" and t ~= "" then
					newName = newName .. ":" .. t
				end
				self.setName(newName)
			end,
			0.5
		)
	end
end

function readMyData(mini)
	local data = mysplit(self.getName(), "|")
	if #data == 2 then
		local name = data[1]
		local curHP = mysplit(data[2], "/")[1]
		local maxHP = mysplit(data[2], "/")[2]
		local t = ""

		if #mysplit(maxHP, ":") == 2 then
			t = mysplit(maxHP, ":")[2]
			maxHP = mysplit(maxHP, ":")[1]
		end
		--print(name)
		--print(curHP)
		--print(maxHP)

		self.UI.setAttribute(elements.hp, "text", curHP)
		self.UI.setAttribute(elements.maxhp, "text", maxHP)
		print(t)
		self.UI.setAttribute(elements.temphp, "text", t)
		if linked then
			linked.hp = curHP
			linked.maxHP = maxHP

			local waited = function()
				linked.object.UI.setAttribute(elements.mini.bar, "percentage", (curHP / maxHP) * 100)
				if t ~= "" then
					linked.object.UI.setAttribute(elements.mini.temphp, "text", "TMP: " .. t)
				end
				setPercentage(linked.object, linked.hp, linked.maxHP)
			end

			Wait.time(waited, 0.5)
		end

		return true
	end
	return false
end

function UI_AddCondition(player, request, id)
	local condition = string.lower(string.gsub(id, "btn_", ""))

	local color = self.UI.getAttribute(id, "color")
	local active = linked.object.UI.getAttribute(condition:gsub("_", " "), "active")

	if color == "#00ff00" then -- is selected
		-- need to remove condition
		color = "#ffffff"
		linked.object.UI.setAttribute(condition:gsub("_", " "), "active", "false")
	else
		-- add condition

		local newPos = linked.object.getPosition()
		newPos.y = newPos.y + 4
		local custom_object = {
			type = "go_game_piece_black",
			position = newPos,
			callback_function = function(obj)
				obj.setName(condition:gsub("_", " "))
			end
		}
		spawnObject(custom_object)

		color = "#00ff00"
	end

	self.UI.setAttribute(id, "color", color)

	--self.UI.setAttribute("ConditionMenu", "active", "false")
end

function manage_condition(params)
	local condition = params.c
	condition = condition:gsub(" ", "_")
	--print(condition)
	self.UI.setAttribute("btn_" .. condition, "color", "#ffffff")
end

function UI_ShowCondition(player, request, id)
	local condition = string.lower(string.gsub(id, "btn_", ""))
	condition = condition:gsub("_", " ")
	condition = condition:gsub("^%l", string.upper)
	self.UI.setAttribute("ConditionType", "text", condition)
end

function UI_DefaultCondition()
	self.UI.setAttribute("ConditionType", "text", "Condition")
end

function mysplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	i = 1
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

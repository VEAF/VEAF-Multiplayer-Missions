--To provide custom AI Attack Tasks 
--Script attached to mission and executed via trigger
--Functions accessed via LUA Run Script on waypoint
------------------------------------------------------------------------------------------------------- 
-- Miguel Fichier Revision M45
------------------------------------------------------------------------------------------------------- 

-- miguel21 modification M45 : compatible with 2.7.0
-- CTS_DebugChecking01  creates custom files to observe 
-- CTS_debug14 Helicopter
-- CTS_debug13 strike bombing (old debug13)
-- CTS_debug12 strike ASM B52 (old debug12)


if not versionDCE then versionDCE = {} end
versionDCE["CustomTasksScript.lua"] = "1.5.5"


--function to turn a table into a string
function TableSerialization(t, i)
	
	
	
	local text = "{\n"
	local tab = ""
	for n = 1, i + 1 do																	--controls the indent for the current text line
		tab = tab .. "\t"
	end
	for k,v in pairs(t) do
		if type(k) == "string" then
			text = text .. tab .. "['" .. k .. "'] = "
		else
			text = text .. tab .. "[" .. k .. "] = "
		end
		if type(v) == "string" then
			text = text .. "'" .. v .. "',\n"
		elseif type(v) == "number" then
			text = text .. v .. ",\n"
		elseif type(v) == "table" then
			text = text .. TableSerialization(v, i + 1)
		elseif type(v) == "boolean" then
			if v == true then
				text = text .. "true,\n"
			else
				text = text .. "false,\n"
			end
		elseif type(v) == "function" then
			text = text .. v .. ",\n"
		elseif v == nil then
			text = text .. "nil,\n"
		end
	end
	tab = ""
	for n = 1, i do																		--indent for closing bracket is one less then previous text line
		tab = tab .. "\t"
	end
	if i == 0 then
		text = text .. tab .. "}\n"														--the last bracket should not be followed by an comma
	else
		text = text .. tab .. "},\n"													--all brackets with indent higher than 0 are followed by a comma
	end
	return text
end


			
local AttackCounter	= {}													--table to count how many flights have already attacked and distribute subsequent attacks accordingly

--function to return heading between two vector2 points
local function GetHeading(p1, p2)
	local deltax = p2.x - p1.x
	local deltay = p2.z - p1.z
	if (deltax > 0) and (deltay == 0) then
		return 0
	elseif (deltax > 0) and (deltay > 0) then
		return math.deg(math.atan(deltay / deltax))
	elseif (deltax == 0) and (deltay > 0) then
		return 90
	elseif (deltax < 0) and (deltay > 0) then
		return 90 - math.deg(math.atan(deltax / deltay))
	elseif (deltax < 0) and (deltay == 0) then
		return 180
	elseif (deltax < 0) and (deltay < 0) then
		return 180 + math.deg(math.atan(deltay / deltax))
	elseif (deltax == 0) and (deltay < 0) then
		return 270
	elseif (deltax > 0) and (deltay < 0) then
		return 270 - math.deg(math.atan(deltax / deltay))
	else
		return 0
	end
end


----- attack group -----
--allows each wingman of a flight to attack its own target in a vahicle/ship group simultaneously, then proceed to Egress point to join up (flight would not climb during egress if wingmen would joing leader imediately after attack)
function CustomGroupAttack(FlightName, TargetName, expend, weaponType, attackType, attackAlt)
	local TargetGroup = Group.getByName(TargetName)						--get target group
	if TargetGroup then													--target group exists
		
		if weaponType == 4161536 or weaponType == 14 then				-- Guided bombs or ASM -- + CTS_debug13 strike bombing
			
			idTypeStrike  = "AttackUnit"
		else 
			idTypeStrike  = "Bombing"
		end
		
		if AttackCounter[TargetName] then								--counter with number of flights that have already attacked this target
			AttackCounter[TargetName] = AttackCounter[TargetName] + 1	--increase counter by one
		else															--no flight has attacked this target yet
			AttackCounter[TargetName] = 1								--set to one
		end
		local AttackN = AttackCounter[TargetName]
		
		local target = TargetGroup:getUnits()							--get target units
	
		if attackType ~= "Dive" then
			attackType = nil
		end
		
		local flight = Group.getByName(FlightName)						--get group of attacking flight
		local wingman = flight:getUnits()								--get list of units from attacking flights
		
		local EgressWP
		for coalition_name,coal in pairs(env.mission.coalition) do
			local stop = false
			for country_n,country in pairs(coal.country) do
				if country.plane then
					for group_n,group in pairs(country.plane.group) do
						-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
						if FlightName == group.name then
							for w = 1, #group.route.points do												--iterate through all group waypoints
								-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
								if string.find(group.route.points[w].name, "Egress") then
									EgressWP = group.route.points[w]										--store Egress waypoint
									stop = true
									break
								end
							end
						end
						if stop then
							break
						end
					end
				end
				if country.helicopter then
					for group_n,group in pairs(country.helicopter.group) do
						-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
						if FlightName == group.name then	
							for w = 1, #group.route.points do												--iterate through all group waypoints
								-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
								if string.find(group.route.points[w].name, "Egress") then
									EgressWP = group.route.points[w]										--store Egress waypoint
									stop = true
									break
								end
							end
						end
						if stop then
							break
						end
					end
				end
				if stop then
					break
				end
			end
			if stop then
				break
			end
		end
		
		for n = 1, #wingman do											--iterate through all aircraft in flight
			local cntrl 
			if n == 1 then												--for leader
				cntrl = flight:getController()							--get controller of group
			else														--for wingmen
				cntrl = wingman[n]:getController()						--get controller of individual aircraft in flight
				cntrl:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2) 	--set to evade fire again, as controller for individual unit does not take over options from parent group
			end
			
			local ComboTask = {											--define combo task to hold multiple attack tasks
				id = 'ComboTask',
				params = {
					tasks = {},
				},
			}
			
			for t = 1, #target do										--iterate thourgh targets
			
				--each wingman gets one attack task for each target
				local num = t + math.ceil((n - 1) * (#target / #wingman))	--distribute target numbers across flight
				num = num + AttackN - 1										--increase target number to adjust for previous attacks
				while num > #target do
					num = num - #target
				end

				local task_entry = {									--define attack task
					["enabled"] = true,
					["auto"] = false,
					["id"] = "Bombing",
					["number"] = #ComboTask.params.tasks + 1,
					["params"] = {
						["x"] = target[num]:getPoint().x,
						["y"] = target[num]:getPoint().z,
						["expend"] = expend,
						["weaponType"] = weaponType,
						["groupAttack"] = false,
						["attackType"] = attackType,
						["attackQtyLimit"] = true,
						["attackQty"] = 1,
						["altitudeEdited"] = true,
						["altitudeEnabled"] = true,
						["altitude"] = attackAlt,
						["directionEnabled"] = false,
						["direction"] = 0,
					},
				}
								
				--auto expend
				if expend == "Auto" or target[num]:getDesc().category == 3 then		--if auto expend or target unit is a ship
					task_entry["id"] = "AttackUnit"									--attack unit instead of bombing task
					task_entry.params["unitId"] = target[num]:getID()
				end
				
				table.insert(ComboTask.params.tasks, task_entry)
			end
			
			-- if n > 1 then												--for all wingmen
				-- local MissionTask = {									--mission task to store go-to Egress waypoint task for wingmen (wingmen need to fly to Egress individually, otherwise out-of-formation flight will not climb during egress)
					-- id = 'Mission',
					-- params = {
						-- route = {
							-- points = {}
						-- }
					-- }
				-- }
				-- table.insert(MissionTask.params.route.points, EgressWP)	--add egress waypoint into MissionTask
				-- MissionTask.params.route.points[1].x = MissionTask.params.route.points[1].x + math.random(-500, 500)	--add some randomness to egress waypoint location to prevent all aircraft in flight converging on same point
				-- MissionTask.params.route.points[1].y = MissionTask.params.route.points[1].y + math.random(-500, 500)
				-- MissionTask.params.route.points[1].alt = MissionTask.params.route.points[1].alt + math.random(-100, 100)
				-- MissionTask.params.route.points[1].task = {}
				-- table.insert(ComboTask.params.tasks, MissionTask)		--add mission task fly to Egress waypoint individually, where the task will end and the wingmen will join their leader
			-- end
			

		
		-- --export custom mission log
		-- local logStr = "ComboTask = " .. TableSerialization(ComboTask, 0)
		-- local logFile = io.open(path ..FlightName.."_"..n.."_".. "CustomGroupAttack.lua", "w")
		-- logFile:write(logStr)
		-- logFile:close()		
		-- _affiche(cntrl, "CtS cntrl_"..n.."_CustomGroupAttack")
					
			cntrl:pushTask(ComboTask)									--push task to front of task list
		end
	end
end


----- attack multiple static objects -----
--allows each wingman of a flight to attack its own individual target simultaneously, then proceed to Egress point to join up (flight would not climb during egress if wingmen would joing leader imediately after attack)
function CustomStaticAttack(FlightName, TargetList, expend, weaponType, attackType, attackAlt)
	
	if AttackCounter[TargetList[1]] then									--counter with number of flights that have already attacked this target
		AttackCounter[TargetList[1]] = AttackCounter[TargetList[1]] + 1		--increase counter by one
	else																	--no flight has attacked this target yet
		AttackCounter[TargetList[1]] = 1									--set to one
	end
	local AttackN = AttackCounter[TargetList[1]]
	
	if attackType ~= "Dive" then
		attackType = nil
	end
	
	local flight = Group.getByName(FlightName)						--get group of attacking flight
	local wingman = flight:getUnits()								--get list of units from attacking flights
	
	local EgressWP
	for coalition_name,coal in pairs(env.mission.coalition) do
		local stop = false
		for country_n,country in pairs(coal.country) do
			if country.plane then
				for group_n,group in pairs(country.plane.group) do
					-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
					if FlightName == group.name then
						for w = 1, #group.route.points do												--iterate through all group waypoints
							-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
							if string.find(group.route.points[w].name, "Egress") then
								EgressWP = group.route.points[w]										--store Egress waypoint
								stop = true
								break
							end
						end
					end
					if stop then
						break
					end
				end
			end
			if country.helicopter then
				for group_n,group in pairs(country.helicopter.group) do
					-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
					if FlightName == group.name then
						for w = 1, #group.route.points do												--iterate through all group waypoints
							-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
							if string.find(group.route.points[w].name, "Egress") then
								EgressWP = group.route.points[w]										--store Egress waypoint
								stop = true
								break
							end
						end
					end
					if stop then
						break
					end
				end
			end
			if stop then
				break
			end
		end
		if stop then
			break
		end
	end
	
	for n = 1, #wingman do											--iterate through all aircraft in flight
		local cntrl 
		if n == 1 then												--for leader
			cntrl = flight:getController()							--get controller of group
		else														--for wingmen
			cntrl = wingman[n]:getController()						--get controller of individual aircraft in flight
			cntrl:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2) 	--set to evade fire again, as controller for individual unit does not take over options from parent group
		end
		
		local ComboTask = {											--define combo task to hold multiple attack tasks
			id = 'ComboTask',
			params = {
				tasks = {},
			},
		}
		
		for t = 1, #TargetList do									--iterate thourgh targets
		
			--each wingman gets one attack task for each target	
			local num = t + math.ceil((n - 1) * (#TargetList / #wingman))	--distribute target numbers across flight
			num = num + AttackN - 1											--increase target number to adjust for previous attacks
			while num > #TargetList do
				num = num - #TargetList
			end
		
			if StaticObject.getByName(TargetList[num]) then							--make sure that static object still exists
				local TargetID = StaticObject.getByName(TargetList[num]):getID()	--get static object ID

				local task_entry = {									--define attack task
					["enabled"] = true,
					["auto"] = false,
					["id"] = "Bombing",
					["number"] = #ComboTask.params.tasks + 1,
					["params"] = {
						["x"] = StaticObject.getByName(TargetList[num]):getPoint().x,
						["y"] = StaticObject.getByName(TargetList[num]):getPoint().z,
						["expend"] = expend,
						["weaponType"] = weaponType,
						["groupAttack"] = true,
						["attackType"] = attackType,
						["attackQtyLimit"] = true,
						["attackQty"] = 1,
						["altitudeEdited"] = true,
						["altitudeEnabled"] = true,
						["altitude"] = attackAlt,
						["directionEnabled"] = false,
						["direction"] = 0,
					},
				}
								
				--auto expend
				if expend == "Auto" then
					task_entry["id"] = "AttackUnit"
					task_entry.params["unitId"] = TargetID
					task_entry.params["attackQtyLimit"] = false
				end
				
				table.insert(ComboTask.params.tasks, task_entry)
			end
		end
		
		-- if n > 1 then												--for all wingmen
			-- local MissionTask = {									--mission task to store go-to Egress waypoint task for wingmen (wingmen need to fly to Egress individually, otherwise out-of-formation flight will not climb during egress)
				-- id = 'Mission',
				-- params = {
					-- route = {
						-- points = {}
					-- }
				-- }
			-- }
			-- table.insert(MissionTask.params.route.points, EgressWP)	--add egress waypoint into MissionTask
			-- MissionTask.params.route.points[1].x = MissionTask.params.route.points[1].x + math.random(-500, 500)	--add some randomness to egress waypoint location to prevent all aircraft in flight converging on same point
			-- MissionTask.params.route.points[1].y = MissionTask.params.route.points[1].y + math.random(-500, 500)
			-- MissionTask.params.route.points[1].alt = MissionTask.params.route.points[1].alt + math.random(-100, 100)
			-- table.insert(ComboTask.params.tasks, MissionTask)		--add mission task fly to Egress waypoint individually, where the task will end and the wingmen will join their leader
		-- end
		
		-- --export custom mission log
		-- local logStr = "ComboTask = " .. TableSerialization(ComboTask, 0)
		-- local logFile = io.open(path ..FlightName.."_"..n.."_".. "CustomStaticAttack.lua", "w")
		-- logFile:write(logStr)
		-- logFile:close()		
		-- _affiche(cntrl, "CtS cntrl_"..n.."_CustomStaticAttack")
		
		
		cntrl:pushTask(ComboTask)									--push task to front of task list
	end
end


----- attack multiple map objects -----
--allows each wingman of a flight to attack its own individual target simultaneously, then proceed to Egress point to join up (flight would not climb during egress if wingmen would joing leader imediately after attack)
function CustomMapObjectAttack(FlightName, TargetList, expend, weaponType, attackType, attackAlt)
	
	if AttackCounter[TargetList[1].x .. TargetList[1].y] then															--counter with number of flights that have already attacked this target
		AttackCounter[TargetList[1].x .. TargetList[1].y] = AttackCounter[TargetList[1].x .. TargetList[1].y] + 1		--increase counter by one
	else																												--no flight has attacked this target yet
		AttackCounter[TargetList[1].x .. TargetList[1].y] = 1															--set to one
	end
	local AttackN = AttackCounter[TargetList[1].x .. TargetList[1].y]
	
	if attackType ~= "Dive" then
		attackType = nil
	end
	
	local flight = Group.getByName(FlightName)						--get group of attacking flight
	local wingman = flight:getUnits()								--get list of units from attacking flights
		
	local EgressWP
	for coalition_name,coal in pairs(env.mission.coalition) do
		local stop = false
		for country_n,country in pairs(coal.country) do
			if country.plane then
				for group_n,group in pairs(country.plane.group) do
					-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
					if FlightName == group.name then
						for w = 1, #group.route.points do												--iterate through all group waypoints
							-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
							if string.find(group.route.points[w].name, "Egress") then
								EgressWP = group.route.points[w]										--store Egress waypoint
								stop = true
								break
							end
						end
					end
					if stop then
						break
					end
				end
			end
			if country.helicopter then
				for group_n,group in pairs(country.helicopter.group) do
					-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
					if FlightName == group.name then
						for w = 1, #group.route.points do												--iterate through all group waypoints
							-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
							if string.find(group.route.points[w].name, "Egress") then
								EgressWP = group.route.points[w]										--store Egress waypoint
								stop = true
								break
							end
						end
					end
					if stop then
						break
					end
				end
			end
			if stop then
				break
			end
		end
		if stop then
			break
		end
	end
	
	for n = 1, #wingman do											--iterate through all aircraft in flight
		local cntrl 
		if n == 1 then												--for leader
			cntrl = flight:getController()							--get controller of group
		else														--for wingmen
			cntrl = wingman[n]:getController()						--get controller of individual aircraft in flight
			cntrl:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2) 	--set to evade fire again, as controller for individual unit does not take over options from parent group
		end
		
		local ComboTask = {											--define combo task to hold multiple attack tasks
			id = 'ComboTask',
			params = {
				tasks = {},
			},
		}
		
		for t = 1, #TargetList do									--iterate thourgh targets
		
			--each wingman gets one attack task for each target
			local num = t + math.ceil((n - 1) * (#TargetList / #wingman))	--distribute target numbers across flight
			num = num + AttackN - 1											--increase target number to adjust for previous attacks
			while num > #TargetList do
				num = num - #TargetList
			end

			local task_entry = {									--define attack task
				["enabled"] = true,
				["auto"] = false,
				["id"] = "Bombing",
				["number"] = #ComboTask.params.tasks + 1,
				["params"] = {
					["x"] = TargetList[num].x,
					["y"] = TargetList[num].y,
					["expend"] = expend,
					["weaponType"] = weaponType,
					["groupAttack"] = true,
					["attackType"] = attackType,
					["attackQtyLimit"] = true,
					["attackQty"] = 1,
					["altitudeEdited"] = true,
					["altitudeEnabled"] = true,
					["altitude"] = attackAlt,
					["directionEnabled"] = false,
					["direction"] = 0,
				},
			}
							
			--auto expend
			if expend == "Auto" then
				task_entry["id"] = "AttackMapObject"
				-- task_entry.params["attackQtyLimit"] = false		-- + CTS_debug12 strike ASM B52 , bizarrement, lorsque attackQtyLimit=true cela permet de tirer tous les missiles d'un coup
			end
			
			table.insert(ComboTask.params.tasks, task_entry)
		end
		
		-- if n > 1 then												--for all wingmen
			-- local MissionTask = {									--mission task to store go-to Egress waypoint task for wingmen (wingmen need to fly to Egress individually, otherwise out-of-formation flight will not climb during egress)
				-- id = 'Mission',
				-- params = {
					-- route = {
						-- points = {}
					-- }
				-- }
			-- }
			-- table.insert(MissionTask.params.route.points, EgressWP)	--add egress waypoint into MissionTask
			-- MissionTask.params.route.points[1].x = MissionTask.params.route.points[1].x + math.random(-500, 500)	--add some randomness to egress waypoint location to prevent all aircraft in flight converging on same point
			-- MissionTask.params.route.points[1].y = MissionTask.params.route.points[1].y + math.random(-500, 500)
			-- MissionTask.params.route.points[1].alt = MissionTask.params.route.points[1].alt + math.random(-100, 100)
			-- table.insert(ComboTask.params.tasks, MissionTask)		--add mission task fly to Egress waypoint individually, where the task will end and the wingmen will join their leader
		-- end
		
		
		-- local logStr = "ComboTask = " .. TableSerialization(ComboTask, 0)
		-- local logFile = io.open(path ..FlightName.."_"..n.."_".. "CustomMapObjectAttack.lua", "w")
		-- logFile:write(logStr)
		-- logFile:close()		
		-- _affiche(cntrl, "CtS cntrl_"..n.."_CustomMapObjectAttack")
		
		cntrl:pushTask(ComboTask)									--push task to front of task list
	end
end


----- attack aircraft on ground -----
--allows each wingman of a flight to attack its own target aircraft on ground simultaneously, then proceed to Egress point to join up (flight would not climb during egress if wingmen would joing leader imediately after attack)
function CustomAirbaseAttack(FlightName, TargetPos, expend, weaponType, attackType, attackAlt)
	
	if AttackCounter[TargetPos.x .. TargetPos.y] then													--counter with number of flights that have already attacked this target
		AttackCounter[TargetPos.x .. TargetPos.y] = AttackCounter[TargetPos.x .. TargetPos.y] + 1		--increase counter by one
	else																								--no flight has attacked this target yet
		AttackCounter[TargetPos.x .. TargetPos.y] = 1													--set to one
	end
	local AttackN = AttackCounter[TargetPos.x .. TargetPos.y]
	
	if attackType ~= "Dive" then
		attackType = nil
	end
	
	local flight = Group.getByName(FlightName)						--get group of attacking flight
	local wingman = flight:getUnits()								--get list of units from attacking flights
		
	local EgressWP
	for coalition_name,coal in pairs(env.mission.coalition) do
		local stop = false
		for country_n,country in pairs(coal.country) do
			if country.plane then
				for group_n,group in pairs(country.plane.group) do
					-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
					if FlightName == group.name then		
						for w = 1, #group.route.points do												--iterate through all group waypoints
							-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
							if string.find(group.route.points[w].name, "Egress") then
								EgressWP = group.route.points[w]										--store Egress waypoint
								stop = true
								break
							end
						end
					end
					if stop then
						break
					end
				end
			end
			if country.helicopter then
				for group_n,group in pairs(country.helicopter.group) do
					-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
					if FlightName == group.name then
						for w = 1, #group.route.points do												--iterate through all group waypoints
							-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
							if string.find(group.route.points[w].name, "Egress") then
								EgressWP = group.route.points[w]										--store Egress waypoint
								stop = true
								break
							end
						end
					end
					if stop then
						break
					end
				end
			end
			if stop then
				break
			end
		end
		if stop then
			break
		end
	end
	
	--search for aircraft on ground and build target list
	local TargetList = {}
	
	local function Found(u)
		if u:getCoalition() ~= wingman[1]:getCoalition() then								--unit is hostile
			local desc = u:getDesc()														--get unit description
			if desc.category == 0 or desc.category == 1 then								--unit is an aircraft or helicopter
				if u:inAir() == false then													--aircraft is on ground
					local uV = u:getVelocity()												--get aircraft speed
					if (desc.category == 0 and uV.x == 0 and uV.y == 0 and uV.z == 0) or desc.category == 1 then	--aircraft is stationary/parked	(doesn't work for helicopters because for helos getVelocity returns IAS not absolute speed)	
						local uP = u:getPoint()												--get aircraft point
						table.insert(TargetList, {x = uP.x, y = uP.z})						--insert x-y coordinates into targetlist
					end
				end
			end
		end
		return true																			--continue search
	end

	local SearchArea = {
		id = world.VolumeType.SPHERE,
		params = {
			point = {
				x = TargetPos.x,
				y = land.getHeight({TargetPos.x, TargetPos.y}),
				z = TargetPos.y,
			},
			radius = 4500
		}
	}
	world.searchObjects(Object.Category.UNIT, SearchArea, Found)
	
	if #TargetList > 0 then												--if there is a target
		for n = 1, #wingman do											--iterate through all aircraft in flight
			local cntrl 
			if n == 1 then												--for leader
				cntrl = flight:getController()							--get controller of group
			else														--for wingmen
				cntrl = wingman[n]:getController()						--get controller of individual aircraft in flight
				cntrl:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2) 	--set to evade fire again, as controller for individual unit does not take over options from parent group
			end
			
			local ComboTask = {											--define combo task to hold multiple attack tasks
				id = 'ComboTask',
				params = {
					tasks = {},
				},
			}
					
			local num = 1 + math.ceil((n - 1) * (#TargetList / #wingman))	--distribute target numbers across flight
			num = num + AttackN - 1											--increase target number to adjust for previous attacks
			while num > #TargetList do
				num = num - #TargetList
			end
			
			local task_entry = {									--define attack task
				["enabled"] = true,
				["auto"] = false,
				["id"] = "Bombing",
				["number"] = #ComboTask.params.tasks + 1,
				["params"] = {
					["x"] = TargetList[num].x,
					["y"] = TargetList[num].y,
					["expend"] = expend,
					["weaponType"] = weaponType,
					["groupAttack"] = true,
					["attackType"] = attackType,
					["attackQtyLimit"] = true,
					["attackQty"] = 1,
					["altitudeEdited"] = true,
					["altitudeEnabled"] = true,
					["altitude"] = attackAlt,
					["directionEnabled"] = false,
					["direction"] = 0,
				},
			}
			
			table.insert(ComboTask.params.tasks, task_entry)
			
			if n > 1 then												--for all wingmen
				local MissionTask = {									--mission task to store go-to Egress waypoint task for wingmen (wingmen need to fly to Egress individually, otherwise out-of-formation flight will not climb during egress)
					id = 'Mission',
					params = {
						route = {
							points = {}
						}
					}
				}
				table.insert(MissionTask.params.route.points, EgressWP)	--add egress waypoint into MissionTask
				MissionTask.params.route.points[1].x = MissionTask.params.route.points[1].x + math.random(-500, 500)	--add some randomness to egress waypoint location to prevent all aircraft in flight converging on same point
				MissionTask.params.route.points[1].y = MissionTask.params.route.points[1].y + math.random(-500, 500)
				MissionTask.params.route.points[1].alt = MissionTask.params.route.points[1].alt + math.random(-100, 100)
				table.insert(ComboTask.params.tasks, MissionTask)		--add mission task fly to Egress waypoint individually, where the task will end and the wingmen will join their leader
			end
			
		-- local logStr = "ComboTask = " .. TableSerialization(ComboTask, 0)
		-- local logFile = io.open(path ..FlightName.."_"..n.."_".. "CustomAirbaseAttack.lua", "w")
		-- logFile:write(logStr)
		-- logFile:close()		
		-- _affiche(cntrl, "CtS cntrl_"..n.."_CustomAirbaseAttack")
			
			
			cntrl:pushTask(ComboTask)									--push task to front of task list
		end
	end
end


----- rejoin flight -----
--resets tasks of individual wingmen to rejoin the flight
function CustomRejoin(FlightName)
	local function Execute()
		local flight = Group.getByName(FlightName)						--get group of attacking flight
		local wingman = flight:getUnits()								--get list of units from attacking flights
		for n = 2, #wingman do											--iterate through wingmen in flight
			local cntrl = wingman[n]:getController()					--get controller of individual aircraft in flight
			cntrl:resetTask()											--reset task (wingman will rejoin with leader)
		end
	end
	timer.scheduleFunction(Execute, nil, timer.getTime() + 1)			--schedule function in one second. A small delay prevents a DCS crash when wingman calls this function on its own flight
end

----- target illumination with flares -----
function CustomFlareAttack(FlightName, tgt_x, tgt_y, grp_name, expend, weaponType, attackType, attackAlt)
	if attackType ~= "Dive" then
		attackType = nil
	end
	if tgt_x == "n/a" and tgt_y == "n/a" then						--if the coordinates are n/a, then the target is a vehicle/ship group
		local tgt_grp = Group.getByName(grp_name)					--get target group
		local tgt_units = tgt_grp:getUnits()						--get target units 
		local tgt_p = tgt_units[1]:getPoint()						--get group leader point
		tgt_x = tgt_p.x
		tgt_y = tgt_p.z
	end
	
	local flight = Group.getByName(FlightName)						--get group of attacking flight
	local wingman = flight:getUnits()								--get list of units from attacking flights
	
	local EgressWP
	for coalition_name,coal in pairs(env.mission.coalition) do
		local stop = false
		for country_n,country in pairs(coal.country) do
			if country.plane then
				for group_n,group in pairs(country.plane.group) do
					-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
					if FlightName == group.name then
						for w = 1, #group.route.points do												--iterate through all group waypoints
							-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
							if string.find(group.route.points[w].name, "Egress") then
								EgressWP = group.route.points[w]										--store Egress waypoint
								stop = true
								break
							end
						end
					end
					if stop then
						break
					end
				end
			end
			if country.helicopter then
				for group_n,group in pairs(country.helicopter.group) do
					-- if FlightName == env.getValueDictByKey(group.name) then								--find group in env.mission
					if FlightName == group.name then
						for w = 1, #group.route.points do												--iterate through all group waypoints
							-- if string.find(env.getValueDictByKey(group.route.points[w].name), "Egress") then		--find egress waypoint
							if string.find(group.route.points[w].name, "Egress") then
								EgressWP = group.route.points[w]										--store Egress waypoint
								stop = true
								break
							end
						end
					end
					if stop then
						break
					end
				end
			end
			if stop then
				break
			end
		end
		if stop then
			break
		end
	end
	
	for n = 1, #wingman do											--iterate through all aircraft in flight
		local cntrl 
		if n == 1 then												--for leader
			cntrl = flight:getController()							--get controller of group
		else														--for wingmen
			cntrl = wingman[n]:getController()						--get controller of individual aircraft in flight
			cntrl:setOption(AI.Option.Air.id.REACTION_ON_THREAT, 2) 	--set to evade fire again, as controller for individual unit does not take over options from parent group
		end
		
		local ComboTask = {											--define combo task to hold multiple attack tasks
			id = 'ComboTask',
			params = {
				tasks = {
					[1] = {											--define attack task
						["number"] = 1,
						["auto"] = false,
						["id"] = "Bombing",
						["enabled"] = true,
						["params"] = 
						{
							["x"] = tgt_x,
							["y"] = tgt_y,
							["direction"] = 0,
							["attackQtyLimit"] = false,
							["attackQty"] = 1,
							["expend"] = expend,
							["altitudeEdited"] = true,
							["altitudeEnabled"] = true,
							["altitude"] = attackAlt,
							["directionEnabled"] = false,
							["groupAttack"] = true,
							["weaponType"] = weaponType,
							["attackType"] = attackType,
						},
					}
				},
			},
		}
		
		if n > 1 then												--for all wingmen
			local MissionTask = {									--mission task to store go-to Egress waypoint task for wingmen (wingmen need to fly to Egress individually, otherwise out-of-formation flight will not climb during egress)
				id = 'Mission',
				params = {
					route = {
						points = {}
					}
				}
			}
			table.insert(MissionTask.params.route.points, EgressWP)	--add egress waypoint into MissionTask
			MissionTask.params.route.points[1].x = MissionTask.params.route.points[1].x + math.random(-500, 500)	--add some randomness to egress waypoint location to prevent all aircraft in flight converging on same point
			MissionTask.params.route.points[1].y = MissionTask.params.route.points[1].y + math.random(-500, 500)
			MissionTask.params.route.points[1].alt = MissionTask.params.route.points[1].alt + math.random(-100, 100)
			table.insert(ComboTask.params.tasks, MissionTask)		--add mission task fly to Egress waypoint individually, where the task will end and the wingmen will join their leader
		end
		
		cntrl:pushTask(ComboTask)									--push task to front of task list
	end
end


----- target laser illumination -----
function CustomLaserDesignation(FlightName, target, class, LaserCode)
	local laser														--variable to hold the laser spot

	if class == "vehicle" then										--target is a vehicle/ship group
	
		local function DesignationCycle()							--laser designation cycle function
			if laser then											--if there is already an existing laser spot
				laser:destroy()										--destroy it
			end
			
			local group = Group.getByName(target)					--get target group
			local units = group:getUnits()							--get target units
			
			local flight = Group.getByName(FlightName)				--get group of designating flight
			local wingman = flight:getUnits()						--get list of units from designating flights
			
			if wingman[1] and units[1] then							--if target group has a leader unit left
				local pos = units[1]:getPoint()						--get target position
				laser = Spot.createLaser(wingman[1], nil, pos, LaserCode)	--start laser spot
			end
			
			if laser then											--if there is a new laser spot
				return timer.getTime() + 2							--repeat designation cylce in 2 seconds
			else													--if no laser spot was created
				return												--stop designation cycle
			end
		end
		timer.scheduleFunction(DesignationCycle, nil, timer.getTime() + 1)	--start designation cylce
		
	elseif class == "static" then									--targets are static objects
		local u = 0													--TargetList counter
		
		local function DesignationCycle()							--laser designation cycle function
			if laser then											--if there is already an existing laser spot
				laser:destroy()										--destroy it
			end
			
			repeat
				u = u + 1											--iterate through all target elements
			until StaticObject.getByName(target[u]) or u == #target		--repeat until first alive static object is found in TargetList or end of TargetList is reached
			
			local static = StaticObject.getByName(target[u])		--get static object

			local flight = Group.getByName(FlightName)				--get group of designating flight
			local wingman = flight:getUnits()						--get list of units from designating flights
			
			if wingman[1] and static then							--if flight leader and static object are alive
				local pos = static:getPoint()						--get target position
				laser = Spot.createLaser(wingman[1], nil, pos, LaserCode)	--start laser spot
			end
			
			if laser then											--if there is a new laser spot
				return timer.getTime() + 2							--repeat designation cylce in 2 seconds
			else													--if no laser spot was created
				return												--stop designation cycle
			end
		end
		timer.scheduleFunction(DesignationCycle, nil, timer.getTime() + 1)	--start designation cylce
	
	elseif class == "scenery" then									--targets are scenery objects
		local u = 0													--TargetList counter
		
		local function DesignationCycle()							--laser designation cycle function
			if laser then											--if there is already an existing laser spot
				laser:destroy()										--destroy it
			end
			
			repeat
				u = u + 1											--iterate through all target elements
				
				local scenery
				local function IfFound(obj)							--function to run if scenery object is found
					scenery = obj									--store scenery object
				end
				
				local SearchArea = {								--scenery object search area centered on target position
					id = world.VolumeType.SPHERE,
					params = {
						point = {
							x = target[u].x,
							y = land.getHeight({x = target[u].x, y = target[u].y}),
							z = target[u].y
						},
						radius = 1
					}
				}
				world.searchObjects(Object.Category.SCENERY, SearchArea, IfFound)	--search for scenery object at target position
			until scenery or u == #target							--repeat until first alive scenery object is found in TargetList or end of TargetList is reached
			
			local flight = Group.getByName(FlightName)				--get group of designating flight
			local wingman = flight:getUnits()						--get list of units from designating flights
			
			if wingman[1]	then									--if flight leader is alive
				local pos = {										--get target position
					x = target[u].x,
					y = land.getHeight({x = target[u].x, y = target[u].y}),
					z = target[u].y
				}
				laser = Spot.createLaser(wingman[1], nil, pos, LaserCode)	--start laser spot
			end
			
			if laser then											--if there is a new laser spot
				return timer.getTime() + 2							--repeat designation cylce in 2 seconds
			else													--if no laser spot was created
				return												--stop designation cycle
			end
		end
		timer.scheduleFunction(DesignationCycle, nil, timer.getTime() + 1)	--start designation cylce
	end
end


----- search then engage task -----
--allows to engage targets within a set distance from own group. CAUTION: Once this function is running, it group can no longer receive waypoint actions (DCS treats engage task set via script as never completed)!
function CustomSearchThenEngage(FlightName, Radius, TargetType)

	local function ApplyEngageTargetsInZoneTask()							--engage targets in zone task needs to be applied continously to update zone position to group position
		local flight = Group.getByName(FlightName)							--get group
		if flight then														--group still exists
			local leader = flight:getUnit(1)								--get first unit in group
			if leader:inAir() and leader:getPlayerName() == nil then		--stop it for groups that have landed and don't apply it to players
				
				local cntrl = flight:getController()						--get controller of group
				local pos = leader:getPoint()								--get position

				local task_entry = {										--define engage task		
					id = 'ControlledTask', 
					params = { 
						task = {
							["enabled"] = true,
							["auto"] = false,
							["id"] = "EngageTargetsInZone",
							["number"] = 1,
							["params"] = {
								["targetTypes"] = {
									[1] = TargetType,
								},
								["x"] = pos.x,
								["y"] = pos.z,
								["value"] = TargetType .. ";",
								["priority"] = 0,
								["zoneRadius"] = Radius,
							}
						}, 
						stopCondition = {
							duration = 6,									--task is valid for 6 seconds only (after 5 seconds it is joined by the next iteration with updated zone position)
						}
					} 
				}
				cntrl:pushTask(task_entry)									--set task for group
				
		-- local TimeSearchEngage = timer.getTime() + 5
		-- local logStr = "task_entry = " .. TableSerialization(task_entry, 0)
		-- local logFile = io.open(path ..FlightName.."_"..TimeSearchEngage.."_".. "_CustomSearchThenEngage.lua", "w")
		-- logFile:write(logStr)
		-- logFile:close()		
		-- _affiche(cntrl, "CtS cntrl_"..timer.getTime().."_CustomSearchThenEngage")				
				
				return timer.getTime() + 5									--repeat function every 5 seconds
		
			end
		end
	end
	timer.scheduleFunction(ApplyEngageTargetsInZoneTask, nil, timer.getTime() + 1)			--schedule function
end


----- orbit position task -----
--lets flight orbit at the current position the task was applied (regardless of waypoints)
function OrbitPosition(FlightName, Alt, Speed, UntilTime)
	local flight = Group.getByName(FlightName)							--get group
	if flight then														--group still exists
		local leader = flight:getUnit(1)								--get first unit in group
		local cntrl = flight:getController()							--get controller of group
		local pos = leader:getPoint()									--get position
	
		local task_entry = {
			["enabled"] = true,
			["auto"] = false,
			["id"] = "ControlledTask",
			["number"] = 1,
			["params"] = 
			{
				["task"] = 
				{
					["id"] = "Orbit",
					["params"] = 
					{
						["altitude"] = Alt,
						["pattern"] = "Circle",
						["speed"] = Speed,
						["point"] = { x = pos.x, y = pos.z},
					},
				},
				["stopCondition"] = 
				{
					["time"] = UntilTime
				}
			}
		}
		cntrl:pushTask(task_entry)										--set task for group
	end
end
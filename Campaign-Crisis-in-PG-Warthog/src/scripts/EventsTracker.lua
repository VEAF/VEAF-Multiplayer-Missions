--To run during mission to track destroyed static objects and trigger debriefing actions on mission end 
--Script attached to mission and executed via trigger
--Requires DCS os and io functions sanitizer to be deactivated
------------------------------------------------------------------------------------------------------- 
-- MBot version 20200111
-------------------------------------------------------------------------------------------------------
-- Miguel Fichier Revision   M18.e
------------------------------------------------------------------------------------------------------- 

-- test01.b saved game on another DD
-- debug_ET02.b	n'affiche pas les messages d'error sauf � la fin de mission
-- debug_ET01.h

-- miguel21 modification M37.e SuperCarrier
-- Miguel21 modification M35.d (d: info log) version ScriptsMod
-- Miguel21 modification M18.e despawn (e: option confMod)(d: active unit) (c despawn/destroy Plane on BaseAirStart) destroy Plane Landing CVN + FARP 

if not versionDCE then versionDCE = {} end
versionDCE["EventsTracker.lua"] = "1.06.26"

if not camp.debug then 
	env.setErrorMessageBoxEnabled(false)
end


local function WarningText()
	local text = "WARNING:\n"
	text = text .. "sanitizeModule('os') in MissionScripting.lua has not been disabled. Mission results will not be accounted and campaign will not progress."
	text = text .. "\n\nMissionScripting.lua gets automatically restored to default state after every DCS update and has to be manually adjusted each time. Modification at your own risk."
	trigger.action.outText(text, 600)
end
local ErrorMessage = timer.scheduleFunction(WarningText, {}, timer.getTime() + 1)	--schedule output of warning text
local check = os.time()															--run random os function. If os functions are sanitized this will fail and stop the script
timer.removeFunction(ErrorMessage)												--if the script continues to here, os functions work and the sdchedzled warning message is removed

local function TableSerialization(t, i)											--function to turn a table into a string
	local text = "{\n"
	local tab = ""
	for n = 1, i + 1 do															--controls the indent for the current text line
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
		end
	end
	tab = ""
	for n = 1, i do																--indent for closing bracket is one less then previous text line
		tab = tab .. "\t"
	end
	if i == 0 then
		text = text .. tab .. "}\n"												--the last bracket should not be followed by an comma
	else
		text = text .. tab .. "},\n"											--all brackets with indent higher than 0 are followed by a comma
	end
	return text
end

local customLog = {}
local scenLog = {}

if not despawn then 
	despawn = {}
end

EventHandler = {}
function EventHandler:onEvent(event)

	--custom events log
	local log_entry = {															--create a custom log entry for this event
		t = timer.getTime()														--store time of event
	}
	if event.id == world.event.S_EVENT_SHOT then								--store type of event
		log_entry.type = "shot"
	elseif event.id == world.event.S_EVENT_HIT then
		log_entry.type = "hit"
	elseif event.id == world.event.S_EVENT_TAKEOFF then
		log_entry.type = "takeoff"
	elseif event.id == world.event.S_EVENT_LAND then
		log_entry.type = "land"
	elseif event.id == world.event.S_EVENT_CRASH then
		log_entry.type = "crash"
	elseif event.id == world.event.S_EVENT_EJECTION then
		log_entry.type = "eject"
	elseif event.id == world.event.S_EVENT_REFUELING then
		log_entry.type = "refueling"
	elseif event.id == world.event.S_EVENT_DEAD then
		log_entry.type = "dead"
	elseif event.id == world.event.S_EVENT_PILOT_DEAD then
		log_entry.type = "pilot dead"
	elseif event.id == world.event.S_EVENT_BASE_CAPTURED then
		log_entry.type = "base captured"
	elseif event.id == world.event.S_EVENT_MISSION_START then
		log_entry.type = "mission start"
	elseif event.id == world.event.S_EVENT_MISSION_END then
		log_entry.type = "mission end"
	elseif event.id == world.event.S_EVENT_TOOK_CONTROL then
		log_entry.type = "took control"
	elseif event.id == world.event.S_EVENT_REFUELING_STOP then
		log_entry.type = "refueling stop"
	elseif event.id == world.event.S_EVENT_BIRTH then
		log_entry.type = "birth"
	elseif event.id == world.event.S_EVENT_HUMAN_FAILURE then
		log_entry.type = "human failure"
	elseif event.id == world.event.S_EVENT_ENGINE_STARTUP then
		log_entry.type = "engine startup"
	elseif event.id == world.event.S_EVENT_ENGINE_SHUTDOWN then
		log_entry.type = "engine shutdown"
	elseif event.id == world.event.S_EVENT_PLAYER_ENTER_UNIT then
		log_entry.type = "player enter unit"
	elseif event.id == world.event.S_EVENT_PLAYER_LEAVE_UNIT then
		log_entry.type = "player leave unit"
	end
	
	
	-- miguel modification M18.d destroy Plane Landing CVN
	if (log_entry.type == "land" and event.place)  then										--hit event with initiator or any other event (excludes hit events without initiator, like collisions)
		if event.initiator then	
			local s =""
			s = s.." "..event.initiator:getCategory()
			s = s.." "..event.place:getCategory()
			s = s.." "..event.place:getName()
			s = s.." "..event.initiator:getID()
			s = s.." "..event.initiator:getTypeName()
			
			local typeCVN = tostring(event.place:getTypeName())
				
			env.info("Event CVN? "..s.." typeCVN: "..typeCVN)
			
			-- miguel21 modification M37.d SuperCarrier
			-- if (typeCVN == "CVN_71 - airbase" or typeCVN == "CVN_72 - airbase" or typeCVN == "CVN_73 - airbase" ) and camp.SC_FullPlaneOnDeck  then 								--si le joueur refuse les options du SC, on despawn les appontages comme sur Stennis
				-- return
			if (string.find(event.place:getName(),"CVN") or (string.find(event.place:getName(),"LHA") ) ) and camp.SC_FullPlaneOnDeck  then 								--si le joueur refuse les options du SC, on despawn les appontages comme sur Stennis
				env.info("Ajout Table CVN despawn "..s)
				table.insert(despawn, event.initiator)	
				-- return
			elseif (event.place:getCategory() == 1 or string.find(event.place:getName(),"FARP"))   and not event.initiator:getPlayerName() then 											-- category ship
				env.info("Ajout Table CVN despawn "..s)
				table.insert(despawn, event.initiator)	
			end
		end
	end	
	
	-- debug ET01.g
	if log_entry.type and ((log_entry.type == "hit" and event.initiator) or log_entry.type ~= "hit" ) then												--hit event with initiator or any other event (excludes hit events without initiator, like collisions) 	
		if event.initiator and event.initiator:getCategory() and event.initiator:getDesc() and event.initiator:getName()	then						--event has an initiator	
			local initDesc = event.initiator:getDesc()																									--debug ET01	
			if initDesc.displayName then
				log_entry.initiator = event.initiator:getName()																							--store initiator name
			end
			if event.initiator:getCategory() and event.initiator:getCategory() == Object.Category.UNIT and event.initiator:getPlayerName() then			--initiator is a unit debug_ET01.h
				log_entry.initiatorPilotName = event.initiator:getPlayerName()																			--store player name
			end
			if event.initiator:getCategory() and event.initiator:getCategory() ~= Object.Category.SCENERY and event.initiator:getID() then				--initator is not a scenery object debug_ET01.h
				log_entry.initiatorMissionID = event.initiator:getID()																					--store ID
			end
		end
		if event.target  and event.target:getCategory() and event.target:getDesc() and event.target:getName() then			--event has a target
			local initDesc = event.target:getDesc()																			--debug ET01
			if initDesc.displayName then
				log_entry.target = event.target:getName()																	--store target name
			end	
			if event.target:getCategory() == Object.Category.UNIT then														--target is a unit
				log_entry.targetPilotName = event.target:getPlayerName()													--store player name
				if log_entry.type == "hit" then																				--log entry is a hit event	
					if event.target:getGroup():getCategory() == 0 or event.target:getGroup():getCategory() == 1 then		--hit unit is aircraft or helo
						local life = event.target:getLife()																	--get current life of unit
						local init_life = event.target:getLife0()															--get initial life of unit
						log_entry.health = math.ceil(100 / init_life * life)												--store unit health to log entry
					end
				end
			end
			if event.target:getCategory() ~= Object.Category.SCENERY and event.target:getCategory() ~= Object.Category.WEAPON then	--target is not a scenery object or weapon									
				log_entry.targetMissionID = event.target:getID()															--store ID
			end
		end
		table.insert(customLog, log_entry)																					--add log entry to custom log
	end
	
	
	--mission end
	if event.id == world.event.S_EVENT_MISSION_END then
		
		--collect health of ships
		if camp.ShipHealth == nil then																						--table to store ship damage does not exist yet
			camp.ShipHealth = {}																							--create table to store ship damage
		end
		camp.ShipDamagedLast = {}																							--table to collect ship names that took new additional damage during this mission
		for coalition_name,coal in pairs(env.mission.coalition) do															--iterate through coalitions in mission
			for country_n,country in pairs(coal.country) do																	--iterate through countries in coalitions
				if country.ship then																						--country has ships
					for group_n,group in pairs(country.ship.group) do														--iterate through groups in ships
						for unit_n,unit in pairs(group.units) do															--iterate through units in group
							local u = Unit.getByName(unit.name)																--get unit
							if u then																						--unit exists
								local health = u:getLife()																	--get current health of unit
								local health0 = camp.ShipHealth0[unit.name]													--get maximum health of unit
								local newhealth = math.floor(health / health0 * 100)										--health percentage of ship
								
								if camp.ShipHealth[unit.name] then
									if newhealth < camp.ShipHealth[unit.name] - 5 then										--new health is lower than previous health
										camp.ShipDamagedLast[unit.name] = true												--mark that ship has taken new damage during this mission
									end
								else
									if newhealth < 100 then
										camp.ShipDamagedLast[unit.name] = true												--mark that ship has taken new damage during this mission
									end
								end
								camp.ShipHealth[unit.name] = newhealth														--store new health of ship
							end
						end
					end
				end
			end
		end
		

		env.info( "camp.path  "..tostring(camp.path) )
		
		--prepare campaign path
		local path = string.gsub(camp.path, "/", "\\")																		--replace slashes in campaign path with double-backslashes
		env.info( "DCE_path "..tostring(path) )
		
		-- Miguel21 modification M35.d (d: info log) version ScriptsMod
		if camp.versionPackageICM then 
			env.info( "DCE_versionPackageICM  "..tostring(camp.versionPackageICM) )
		end
		if camp.MissionFilename then 
			env.info( "DCE_MissionFilename  "..tostring(camp.MissionFilename) )
		end	
		if camp.version then 
			env.info( "DCE_versionCampaign  "..tostring(camp.version) )
		end	
			
		
		--export custom mission log
		local logStr = "events = " .. TableSerialization(customLog, 0)
		local logFile = io.open(path .. "MissionEventsLog.lua", "w")
		logFile:write(logStr)
		logFile:close()
		
		--export data for destroyed static objects (this is not tracked in DCS's debrief.log)
		local scenDescr = "--Destroyed scenery objects\n\n"
		local scenStr = "scen_log = " .. TableSerialization(scenLog, 0)
		local scenFile = io.open(path .. "scen_destroyed.lua", "w")
		scenFile:write(scenDescr .. scenStr)
		scenFile:close()
		
		--export camp stats file
		local campStr = "camp = " .. TableSerialization(camp, 0)
		local campFile = io.open(path .. "camp_status.lua", "w")
		campFile:write(campStr)
		campFile:close()
		

	--collect destroyed scenery objects
	elseif event.id == world.event.S_EVENT_HIT then
		if event.target and event.initiator then
			if event.target:getCategory() == 5 then								--if target is a scenery object
				local descr = event.target:getDesc()
				if descr.life and descr.life > 20 then							--only store destroyed scenery that had an initial health bigger than 20
					scenLog[event.target:getName()] = {							--add scenery object to table
						health0 = descr.life,									--store initial health of scenery object
						lasthit = event.initiator:getName(),					--store who hit the scenery object
					}
				end
			end
		end	
	elseif event.id == world.event.S_EVENT_DEAD then
		if event.initiator then
			if event.initiator:getCategory() == 5 then							--if initiator is a scenery object
				if scenLog[event.initiator:getName()] then
					local initPoint = event.initiator:getPoint()				--get point of dead scenery object
					scenLog[event.initiator:getName()].x = initPoint.x
					scenLog[event.initiator:getName()].y = initPoint.y
					scenLog[event.initiator:getName()].z = initPoint.z
				end
			end
		end
	end
end
world.addEventHandler(EventHandler)


--collect initial health of ships
if camp.ShipHealth0 == nil then																						--table does not exist yet
	camp.ShipHealth0 = {}																							--create table
end
for coalition_name,coal in pairs(env.mission.coalition) do															--iterate through coalitions in mission
	for country_n,country in pairs(coal.country) do																	--iterate through countries in coalitions
		if country.ship then																						--country has ships
			for group_n,group in pairs(country.ship.group) do														--iterate through groups in ships
				for unit_n,unit in pairs(group.units) do															--iterate through units in group
					local u = Unit.getByName(unit.name)																--get unit
					if u then																						--unit exists
						local health = u:getLife()																	--get current health of unit
						camp.ShipHealth0[unit.name] = health														--store initial ship health
					end
				end
			end
		end
	end
end

--apply ship damage
if camp.ShipHealth then																						--table with ship health exists
	for name,health_stored in pairs(camp.ShipHealth) do														--iterate through ships in table
		if health_stored < 66 and camp.ShipHealth0[name] > 10 then											--health is less than 100% and ship has more than 10 health points (do not do for exteremly small boats)
			local u = Unit.getByName(name)																	--get unit
			if u then																						--unit exists
				local counter = 1
				repeat
					local h = u:getLife()																	--get current health of unit
					local h0 = camp.ShipHealth0[name]														--get maximum health of unit
					local health_current = math.floor(h / h0 * 100)											--store health percentage of ship
					local point = u:getPoint()																--get position of ship
					local power = h0 / 100																	--explosive power is relatve to ship strenght
					--trigger.action.outText(counter .. " / Name: " .. name .. " / Power: " ..power .. " / Health: " .. health_current, 1)	--DEBUG
					trigger.action.explosion(point, power)													--apply explosion
					counter = counter + 1																	--counter to prevent runaway repeat
				until health_current < health_stored + 5 or counter > 100										--repeat until ship health reaches dieserd level or for a maximum of 100 times
			end
		end
	end
end

-- Miguel21 modification M18.c despawn/destroy Plane on BaseAirStart
local function CheckRtbAirbase()
		
	-- BaseAirStart = {
		-- ['BA Wahda'] = {
			-- coalition = "blue"
			-- x = 00549355,
			-- y = -00892454, 
			-- elevation = 0,
			-- airdromeId = nil,
			-- ATC_frequency = "0",
			-- BaseAirStart = true,
		-- },
	-- }
	
	if camp.BaseAirStart then 
		for base_name, base in pairs(camp.BaseAirStart) do			
			for country_n, country in pairs(env.mission.coalition[base.coalition].country) do					
				if country.plane then						
					for group_n,group in ipairs(country.plane.group) do			
						local groupAero = Group.getByName(group.name)																			
						if groupAero then																											
							for n=1  , #group.units do								
								local unitAero = groupAero:getUnit(n)	
								if unitAero and unitAero ~= nil and unitAero:isActive() and unitAero:inAir() then
									local unitAeroPoint = unitAero:getPoint()
									local unitAeroFuel = unitAero:getFuel()
									local alti = unitAeroPoint.y - base.elevation									
									-- env.info( "DCE EventsTracker.lua file PASSE 10 name "..tostring(group.units[n].name).." ||Alti: "..tostring(alti).." ||Fuel: "..tostring(unitAeroFuel) )
									if alti <= 1000 and unitAeroFuel <= 0.75 then	
									-- if alti <= 1000  then
										env.info( "DCE EventsTracker.lua file PASSE 11")										
										local distance = math.floor(math.sqrt(math.pow(base.x - unitAeroPoint.x, 2) + math.pow(base.y - unitAeroPoint.z, 2)))										
										if distance <= 20000 then										
											unitAero:destroy()											
											-- env.info( "DCE EventsTracker.lua file PASSE 12")
											-- env.info( "DCE BasAistart Despawn "..tostring(group.units[n].name) )											
										end										
									end
								end
							end						
						end
					end
				end				
			end		
		end
	end
	
	return timer.getTime() + 30
	
end




local function despawnIA()
		
	reset = false
	
	for n = 1, #despawn do	
		env.info("despawn "..n)
		-- trigger.action.outText("despawn "..n, 3)
		despawn[n]:destroy()
		reset = true
	end
		
	if reset then
		despawn = {}
	end
	
	return timer.getTime() + 30
	
end

timer.scheduleFunction(CheckRtbAirbase, nil, timer.getTime() + 5)

timer.scheduleFunction(despawnIA, nil, timer.getTime() + 10)









































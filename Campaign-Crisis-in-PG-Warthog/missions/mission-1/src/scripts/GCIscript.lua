--To run during mission to detect targets by EWR and launch interceptors
--Script attached to mission and executed via trigger
--Requires GCIdata.lua to be attached and run in mission in order to get access to table GCI
------------------------------------------------------------------------------------------------------- 
-- Miguel Fichier Revision  M11.j 
------------------------------------------------------------------------------------------------------- 
-- Miguel21 modification M11.j : Multiplayer

--example of data structure for table GCI supplied by GCIdata.lua
--[[
GCI = {
	EWR = {
		["blue"] = {
			["EWR 1"] = true,
			["EWR 2"] = true,
		},
		["red"] = {},
	},
	Interceptor = {
		["blue"] = {
			base = {
				["base_XYZ"] = {
					ready30 = {},
					ready15 = {},
					ready15_n = 0,
					ready = {},
					ready_n = 0,
				},
			},
			assigned = {},
		},
		["red"] = {
			base = {
				["base_XYZ"] = {
					ready30 = {},
					ready15 = {},
					ready15_n = 1,
					ready = {
						[1] = {
							name = "Flight 1",
							number = 2,
							range = 150000,
							x = 123,
							y = 123,
							tot_from,
							tot_to,
							airdromeId,
							time = -900,
						},
					},
					ready_n = 1,
				},
			},
			assigned = {},
		}
	}
}
]]--

--function to return a new point offset from an initial point
function GetOffsetPointIM(point, heading, distance)
	return {
		x = point.x + math.cos(math.rad(heading)) * distance,
		y = point.y + math.sin(math.rad(heading)) * distance
	}
end
--function to return heading between two vector2 points
function GetHeadingIM(p1, p2)
									
	local deltax = p2.x - p1.x
	local deltay = p2.y - p1.y
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


local ErrorMsg = ""																				--variable to store script status in case of error

--target tracks
local target_tracks = {
	["blue"] = {},
	["red"] = {}
}

local function GCI_Cycle()
	local current_time = timer.getTime()
	
	--remove old targets from target_tracks
	ErrorMsg = "Remove old tracks."																--Error message in case follow on code fails
	for track_side, side in pairs(target_tracks) do												--iterate through sides in target tracks table
		for target_name, target in pairs(side) do												--iterate through targets
			ErrorMsg = "Remove old tracks: " .. target_name .. " no time stamp."				--Error message in case follow on code fails
			if target.time + 300 < current_time then											--if target was not detected for more than 5 minutes
				target.assigned = 0
				target.number = 0																--make target void
			end
		end
	end
	
	--update assigned interceptors table
	ErrorMsg = "Update interceptor table."														--Error message in case follow on code fails
	for side_name, side in pairs(GCI.Interceptor) do											--iterate through sides in Interceptor table	
		for base_name, base in pairs(side.base) do													--iterate through bases in Interceptor table
			
			--trigger.action.outText(side_name .." / " .. base_name .. ": Ready: " .. #base.ready .. " / Ready15: " .. #base.ready15 .. " / Ready30: " .. #base.ready30, 5)	--FOR DEBGUG
			
			--move ready 15 flights to ready
			while #base.ready < base.ready_n and base.ready15[1] and base.ready15[1].time + 900 < current_time do		--less interceptor flights are ready than planned AND ready15 flights exist AND flight must be in ready15 since 15 minutes to move up (when coming from ready30, otherwise time is -900 for no delay)														
				base.ready15[1].time = current_time												--reset timer so that flight will not become ready until 15 minutes have passed
				table.insert(base.ready, base.ready15[1])										--move ready15 flight to ready
				table.remove(base.ready15, 1)													--move ready15 flight to ready		
			end
			
			--move ready 30 flights to ready 15
			while #base.ready15 < base.ready15_n and base.ready30[1] do							--less interceptor flights are ready15 than planned AND ready30 flights exist															
				base.ready30[1].time = current_time												--set timer so that flight will not become ready15 until 15 minutes have passed
				table.insert(base.ready15, base.ready30[1])										--move ready30 flight to ready15
				table.remove(base.ready30, 1)													--move ready30 flight to ready15	
			end
		end
			
		for flight_name, flight in pairs(side.assigned) do										--iterate through assigned interceptors
			ErrorMsg = "Update interceptor table: "	.. 	flight_name								--Error message in case follow on code fails
			local group = Group.getByName(flight_name)											--get group of flight
			if group then
				local units = group:getUnits()													--get alive units array of group
				local difference = #units - flight.number										--number of of interceptors that died since last cylce										
				target_tracks[side_name][flight.target].assigned = target_tracks[side_name][flight.target].assigned + difference	--remove dead interceptors from assigned number of target track
				flight.number = #units															--store new number of interceptors
			else																				--group doesnt exist
				target_tracks[side_name][flight.target].assigned = target_tracks[side_name][flight.target].assigned - flight.number	--remove dead interceptors from assigned number of target track
				side.assigned[flight_name] = nil												--remove flight from Interceptors table
			end
			if target_tracks[side_name][flight.target].assigned < 0 then						--make sure that assigned number of target track is not negative (lost track resets number to 0 and dead interceptor can further subtract form that)
				target_tracks[side_name][flight.target].assigned = 0
			end
		end
	end
	
	--EWR target detection
	ErrorMsg = "EWR target detection."																--Error message in case follow on code fails
	for ewr_side, ewr_table in pairs(GCI.EWR) do													--iterate through sides in EWR table
		for ewr_name, bool in pairs(ewr_table) do													--iterate through EWR radars	
			ErrorMsg = "EWR target detection: "	.. ewr_name											--Error message in case follow on code fails
			local unit = Unit.getByName(ewr_name)													--get EWR unit
			if unit then																			--if unit exists
				local ctr = unit:getGroup():getController()											--get unit controller
				local targets = ctr:getDetectedTargets()											--get detected targets of this EWR
				local track_update = {}																--local table to store which group tracks were already updated (to prevent multiple detected targets from the same group to update same track)
				for t = 1, #targets do																--iterate through detected targets
					if targets[t].object then
						local objCat = targets[t].object:getCategory()								--get object category
						if objCat == 1 then															--object is a unit
							local desc = targets[t].object:getDesc()								--get descriptor descriptor
							if desc.category == 0 or desc.category == 1 then						--descriptor category is airplane or helicopter
								local target_name = targets[t].object:getGroup():getName()			--get target group name
								if track_update[target_name] == nil then							--the target track for this group has not yet been updated
									track_update[target_name] = true								--the target track for this group is updated
									local target_number = targets[t].object:getGroup():getUnits()	--get target group size
									local target_point = targets[t].object:getPoint()				--get target point
									local target_typeName = targets[t].object:getGroup():getUnit(1):getTypeName()
									ErrorMsg = "EWR target detection: " .. ewr_name	.. "; Target: " .. target_name 	--Error message in case follow on code fails
									
									if target_tracks[ewr_side][target_name] then					--existing track
										if target_tracks[ewr_side][target_name].time > current_time - 30 then	--last detection was within 30 seconds
											target_tracks[ewr_side][target_name].history = target_tracks[ewr_side][target_name].history + 1		--increase detection history by one
										else																	--last detection is older than 30 seconds
											target_tracks[ewr_side][target_name].history = 0					--reset detection history to 0
										end
										target_tracks[ewr_side][target_name].number = #target_number
										target_tracks[ewr_side][target_name].time = current_time
										target_tracks[ewr_side][target_name].point = target_point
									else															--new track
										target_tracks[ewr_side][target_name] = {
											number = #target_number,								--number of aircraft in traget group
											time = current_time,									--time of current detection
											point = target_point,									--position of this target group
											typeName = target_typeName,
											history = 0,											--number of detections in sequence
											assigned = 0,											--number of interceptors assigned to this target group
										}
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	--assign interceptors to targets
	ErrorMsg = "Assign interceptors."																--Error message in case follow on code fails
	for track_side, side in pairs(target_tracks) do													--iterate throug sides in target_tracks table
		for target_name, target in pairs(side) do													--iterate through targets
			ErrorMsg = "Assign interceptors; Target: " .. target_name								--Error message in case follow on code fails
			if target.history > 0 then																--target was detected at least two times in sequence
				if target.assigned < target.number then												--if target has less interceptors assigned than it has aircraft in group
					
					--find all flights in range to intercept target
					local eligible_flights = {}														--table of flights eligible for interception of this target
					for base_name, base in pairs(GCI.Interceptor[track_side].base) do				--iterate through bases in GCI table
						for flight_n, flight in pairs(base.ready) do								--iterate through ready interceptor flights
							if flight.time + 900 < current_time then								--interceptor flight has moved to ready status (from ready15) longer than 15 minutes ago and is ready for action (time is -900 for flight starting ready at mission start).
								ErrorMsg = "Assign interceptors; Target: " .. target_name .. "; Interceptor: " .. flight.name						--Error message in case follow on code fails
								if current_time >= flight.tot_from and current_time <= flight.tot_to then											--flight can operate at current time							
									local distance = math.sqrt(math.pow(target.point.x - flight.x, 2) + math.pow(target.point.z - flight.y, 2))		--distance between interceptor airbase and target
									if distance < flight.range then									--target is in interception range
										eligible_flights[flight.name] = distance					--store flight name and interception distance in table
									end
								end
							end
						end
					end
					
					--select the flight closest to target for interception
					local selected_flight															--currently selected flight for interception
					local selected_distance = 9999999												--interception distance of currently selected flight
					for flight_name, distance in pairs(eligible_flights) do							--iterate through eligible flights
						if distance < selected_distance then										--if distance of current flight is lower than of currently selected flight
							selected_flight = flight_name											--select this flight instead
							selected_distance = distance											--make this the new distance
						end
					end				
					
					--assign selected flight to target
					ErrorMsg = "Assign interceptors; Target: " .. target_name .. "; Select Flight."					--Error message in case follow on code fails
					if selected_flight then
						for base_name, base in pairs(GCI.Interceptor[track_side].base) do				--iterate through bases in GCI table
							for flight_n, flight in pairs(base.ready) do								--iterate through ready interceptor flights						
								if flight.name == selected_flight then									--find selected interceptor flight in ready table
									trigger.action.setUserFlag(flight.flag, true)						--set flag true to launch interceptor
									
									
									-- Miguel21 modification M11.j : Multiplayer
									
									-- trigger.action.outText(selected_flight .. " 01 launched to intercept " .. target_name, 15)	--FOR DEBUG
									-- env.info(selected_flight .. " 01 launched to intercept " .. target_name)
									local idInfo = Group.getByName(selected_flight):getID()
									local _side = Group.getByName(selected_flight):getCoalition()
									
									-- on replace les vecteurs dans un repere x/y/z/
									local newTarget = {}
									newTarget.point = {}
									newTarget.point.x = target.point.x
									newTarget.point.y = target.point.z
									newTarget.point.z = target.point.y
									
									target.altitude = math.floor(target.point.y / 1000) * 1000
									target.distance = math.floor(selected_distance / 10000) * 10
									target.bearing = math.floor(GetHeadingIM(flight, newTarget.point))

									env.info(selected_flight .. " launched to intercept: " .. target.number .." "..target.typeName.." Bearing: "..target.bearing.." Angel: "..target.altitude.." Distance: "..target.distance.." Km")
									
									trigger.action.outTextForGroup(idInfo, selected_flight .. " launched to intercept: " .. target.number .." "..target.typeName.." Bearing: "..target.bearing.." Angel: "..target.altitude.." Distance: "..target.distance.." Km", 60 , true)

									-- trigger.action.outSoundForCoalition(_side, "l10n/DEFAULT/alarme.wav" )
									
									trigger.action.outSoundForGroup(idInfo, "l10n/DEFAULT/alarme.wav" )
									
									
									--assign mission task to interceptor flight
									ErrorMsg = "Assign interceptors; Target: " .. target_name .. "; Selected Flight: " .. selected_flight				--Error message in case follow on code fails
									local function AssignMission()												--function to set interception mission (to be executed with 2 seconds delay, in order for the group to activate first)
										local ctr = Group.getByName(selected_flight):getController()			--get controller of interceptor group
										local target_id = Group.getByName(target_name):getID()					--get target group ID
										local Mission = {														--define mission for interceptor group
											id = 'Mission', 
											params = {
												route = { 
													["points"] = {
														[1] = {
															["alt"] = 4000,
															["type"] = "Turning Point",
															["action"] = "Turning Point",
															["alt_type"] = "BARO",
															["formation_template"] = "",
															["ETA"] = 0,
															["y"] = GCI.Interceptor[track_side].assigned[selected_flight].y,
															["x"] = GCI.Interceptor[track_side].assigned[selected_flight].x,
															["speed"] = 250,
															["ETA_locked"] = false,
															["task"] = {
																["id"] = "ComboTask",
																["params"] = {
																	["tasks"] = {
																		[1] = 
																		{
																			["enabled"] = true,
																			["key"] = "CAP",
																			["id"] = "EngageTargets",
																			["number"] = 1,
																			["auto"] = true,
																			["params"] = 
																			{
																				["targetTypes"] = 
																				{
																					[1] = "Air",
																				}, -- end of ["targetTypes"]
																				["priority"] = 0,
																			}, -- end of ["params"]
																		}, -- end of [1]
																		[2] = {
																			["enabled"] = true,
																			["number"] = 2,
																			["auto"] = false,
																			["id"] = "EngageGroup",
																			["params"] = {
																				["visible"] = false,
																				["groupId"] = target_id,
																				["priority"] = 1,
																				-- ["weaponType"] = 1069547520,
																			},
																		},
																		-- [3] = {
																			-- ["enabled"] = true,
																			-- ["auto"] = false,
																			-- ["id"] = "EngageTargets",
																			-- ["number"] = 3,
																			-- ["key"] = "CAP",
																			-- ["params"] = {
																				-- ["targetTypes"] = {
																					-- [1] = "Air",
																				-- },
																				-- ["maxDistEnabled"] = true,
																				-- ["maxDist"] = GCI.Interceptor[track_side].assigned[selected_flight].range + 100000,
																				-- ["priority"] = 2,
																				-- ["value"] = "Air;",
																			-- },
																		-- },
																		[3] = {
																			["number"] = 3,
																			["auto"] = false,
																			["id"] = "ControlledTask",
																			["enabled"] = true,
																			["params"] = {
																				["task"] = {
																					["id"] = "Orbit",
																					["params"] = {
																						["altitude"] = 4000,
																						["pattern"] = "Circle",
																						["speed"] = 200,
																					},
																				},
																				["stopCondition"] = {
																					["time"] = current_time + 1200,
																				}
																			}
																		},
																	},
																},
															},
															["speed_locked"] = true,
														},
														[2] = {
															["alt"] = 10000,
															["type"] = "Land",
															["action"] = "Landing",
															["airdromeId"] = GCI.Interceptor[track_side].assigned[selected_flight].airdromeId,
															["alt_type"] = "BARO",
															["formation_template"] = "",
															["ETA"] = 0,
															["y"] = GCI.Interceptor[track_side].assigned[selected_flight].y,
															["x"] = GCI.Interceptor[track_side].assigned[selected_flight].x,
															["speed"] = 250,
															["ETA_locked"] = false,
															["task"] = {
																["id"] = "ComboTask",
																["params"] = {
																	["tasks"] = {
																	},
																},
															},
															["speed_locked"] = true,
														},
													},
												}
											}
										}
										Controller.setTask(ctr, Mission)																			--activate task with mission for interceptor group
									end
									timer.scheduleFunction(AssignMission, nil, timer.getTime() + 2)													--set intercept mission with 2 seconds delay
									
									ErrorMsg = "Assign interceptors; Target: " .. target_name .. "; Selected Flight: " .. selected_flight .. "; Update GCI Table."				--Error message in case follow on code fails
									

									GCI.Interceptor[track_side].assigned[selected_flight] = GCI.Interceptor[track_side].base[base_name].ready[flight_n]	--move flight from ready to assigned status
									table.remove(GCI.Interceptor[track_side].base[base_name].ready, flight_n)											--move flight from ready to assigned status
									GCI.Interceptor[track_side].assigned[selected_flight].target = target_name										--store target name
									target.assigned = target.assigned + GCI.Interceptor[track_side].assigned[selected_flight].number				--mark target as assigned for interception
									break
								end
							end
						end
					end
				end
			end
		end
	end
	
	ControlTime = timer.getTime()																--update ControlTime to tell ControlFunction() that cylce is still running
	return timer.getTime() + 18																	--repeat GCI cycle every 18 seconds (revolution time of 1L13 EWR radar)
end
timer.scheduleFunction(GCI_Cycle, nil, timer.getTime() + 1)										--start GCI cylce


--Control function to report when GCI_Cylce() stopped working
local function ControlFunction()
	if ControlTime + 30 < timer.getTime() then													--if ControlTime was not updated since 30 seconds
		trigger.action.outText("GCI_Cycle() Error: " .. ErrorMsg, 60)							--print error
	else
		return timer.getTime() + 15	
	end
end
timer.scheduleFunction(ControlFunction, nil, timer.getTime() + 2)	
--To turn carriers into wind for flight ops and resume route later
--Script attached to mission and executed via trigger
------------------------------------------------------------------------------------------------------- 
-- Miguel Fichier Revision  M45
-------------------------------------------------------------------------------------------------------

-- miguel21 modification M45 : compatible with 2.7.0
-- Miguel21 modification M36.d	(d: add timer) MenuRadio request manual TurnIntoWind
-- CIWS_Debug02.b	transforms an angle of more than 90° into 2 WPT of less than 90°
-- CIWS_Debug01.b SuperCarrier don't turn

if not versionDCE then versionDCE = {} end
versionDCE["CarrierIntoWindScript.lua"] = "1.4.9"


function rad2Deg(_rad)
	radToDeg = _rad * (180/math.pi)
	return radToDeg
end 

Vmax = 10																				--valeur limité pour spawner les F14 sans explosion
windDeck = 9																			--valeur limité pour spawner les F14 sans explosion

function ChangeValue()
	Vmax = camp.CVN_Vmax																--standard maxiumum speed value of carrier: 30 kts
	windDeck = camp.CVN_windDeck														--standard desired wind over deck value: 27 kts
end
	

timer.scheduleFunction(ChangeValue, nil, timer.getTime() + 28)							--pendant les 28 premieres secondes, la vitesse est faible pour éviter les collisions lors du spawn

	
--function to make a deep copy of a table
local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--table to store carrier names with flight ops ongoing
local FlightOpsOngoing = {}

--function to turn ship group into wind
function TurnIntoWind(GroupName, pos, heading)
	-- local Vmax = 10																			--standard maxiumum speed value of carrier: 30 kts		Vmax = 15.4333
	-- local windDeck = 9																			--standard desired wind over deck value: 27 kts		windDeck = 13.89
	local duration = 0 
	
	if type(GroupName) == "table" then
		-- _affiche(GroupName, "GroupName")
		duration = GroupName[4]
		GroupName = GroupName[1]
		heading = nil
		local groupCarrier = Group.getByName(GroupName)
		local carrier = groupCarrier:getUnit(1)
		pos = carrier:getPoint()
		
	end

	local groupCarrier = Group.getByName(GroupName)
	local carrier = groupCarrier:getUnit(1)	
	local carrierName = carrier:getName()													--get carrier name
	local Desc = carrier:getDesc()
	local txt = ""
	
	if heading == nil or not heading then
		heading = rad2Deg(getHeadingByPos(carrier))
	end
	
	local typeName = Group.getByName(GroupName):getUnit(1):getTypeName()
	if typeName == "LHA_Tarawa" then																--here it is possible to define individual values for specific carrier types
		Vmax = 12.3467																				--Tarawa max speed 24 kts 
		windDeck = 10.2889																			--Tarawa wind over deck 20 kts (?)
	elseif typeName == "KUZNECOW" then
		Vmax = 16.3889																				--Kuznetsov max speed 32 kts 
		windDeck = 99																				--Kuznetsov should get as much wind over deck as possible
	end
	
	pos.y = 10																						--set altitute to 10m above sea level to measure wind
	local wind = atmosphere.getWind(pos)															--measure wind at this position
	local windV = math.sqrt(math.pow(wind.x, 2) + math.pow(wind.z, 2))								--calculate wind speed in m/s
	local speed = windDeck - windV																	--movement speed into wind to get the required wind over deck
	
	local moveVec																					--normalized movement vector to create straight wind over deck
	if windV < 0.5 then																				--if there is almost no wind, keep moving in current direction
		txt = "It is not necessary to turn, the wind is less than 0.5 m/s."
		local carrierVec = Group.getByName(GroupName):getUnit(1):getPosition()						--get carrier movement vector
		moveVec = {
			x =	carrierVec.x.x,
			y = 0,
			z = carrierVec.x.z
		}
	else																							--if there is wind, move into wind
		moveVec = {
			x =	wind.x / windV * -1,
			y = 0,
			z = wind.z / windV * -1
		}
	end
	
	if speed < 0 then																				--if speed is negative (more wind than required wind over deck)
		moveVec.x = moveVec.x * -1																	--switch direction and move with wind
		moveVec.z = moveVec.z * -1																	--switch direction and move with wind
		speed = speed * -1																			--make speed positive again
	end
	
	if speed > Vmax then																			--if required speed is higher than maximum possible speed
		speed = Vmax																				--set speed to maximum speed
	elseif speed < 5.14444 then																		--if speed is lower than 10 kts
		speed = 5.14444																				--set speed to at least 10 knots for good maneuvering
	end
	
	-- Miguel21 modification M36.d	(d: add timer) MenuRadio request manual TurnIntoWind
	if duration then 
		timer.scheduleFunction(ResumeRoute, {GroupName, nil, carrierName}, timer.getTime() + (duration*60))	--schedule resume carrier on route
		-- env.info( "TurnIntoWind ResumeRoute? duration: "..tostring(duration))
	end
	--search original group route
	local _route = {}																				--variable to store a copy of the group route
	for coalition_name,coal in pairs(env.mission.coalition) do
		for country_n,country in ipairs(coal.country) do
			if country.ship then
				for group_n,group in ipairs(country.ship.group) do
					-- if GroupName == env.getValueDictByKey(group.name) then
					if GroupName == group.name then							--M45
						_route = deepcopy(group.route.points)										--make a copy of the route
					end
				end
			end
		end
	end
	
	--update first _route point to current position
	_route[1].x = pos.x
	_route[1].y = pos.z
	
	--define new group _route, create a waypoint to turn into wind
	if _route[2] then																				--if there is a waypoint 2, modify it
		_route[2].x = pos.x + moveVec.x * 200000														--point 200 km away
		_route[2].y = pos.z + moveVec.z * 200000														--point 200 km away
		_route[2].speed = speed
		for n = 3, #_route do																		--clear any additional waypoints
			_route[n] = nil
		end
	else																							--if there is no waypoint 2, create a new one
		_route[2] = {
			['alt'] = 0,
			['type'] = 'Turning Point',
			['ETA'] = 0,
			['alt_type'] = 'BARO',
			['formation_template'] = '',
			['y'] = pos.z + moveVec.z * 200000,
			['x'] = pos.x + moveVec.x * 200000,
			['name'] = '',
			['ETA_locked'] = false,
			['speed'] = speed,
			['action'] = 'Turning Point',
			['task'] = {
				['id'] = 'ComboTask',
				['params'] = {
					['tasks'] = {},
				},
			},
			['speed_locked'] = true,
		}
	end
	
	-- CIWS_Debug02	transforms an angle of more than 90° into 2 WPT of less than 90°
	local h1 = heading																-- cap actuel heading
	local h2 = GetHeading2(_route[1],_route[2] )										-- direction a prendre Heading
	local angle = GetDeltaHeadingIM(h1, h2)
	local bearing = 0
	txt = "Provisional BRC will be "..math.floor(h2)
	env.info(txt)
	trigger.action.outText(txt, 15)
	-- env.info( "TurnIntoWind SECOND h1: "..h1.." |h2: "..h2.." |angle: "..angle.." |bearing: "..bearing )
	
	if angle > 90 or angle < -90 then
		if angle > 90 then bearing = h1 + 90
		elseif angle < -90 then bearing = h1 - 90 end
		-- intercalWP = GetOffsetPointIM(point, bearing, distance)
		local intercalWP = GetOffsetPointIM(_route[1], bearing, 3500)
		
		local intercalRoute = {
			['alt'] = 0,
			['type'] = 'Turning Point',
			['ETA'] = 0,
			['alt_type'] = 'BARO',
			['formation_template'] = '',
			['y'] = intercalWP.y,
			['x'] = intercalWP.x,
			['name'] = '',
			['ETA_locked'] = false,
			['speed'] = Desc.speedMax - 1,
			['action'] = 'Turning Point',
			['task'] = {
				['id'] = 'ComboTask',
				['params'] = {
					['tasks'] = {},
				},
			},
			['speed_locked'] = true,
		}
		
		-- table.insert(maTable, 5, "très")
		table.insert(_route, 2, intercalRoute)
	end

	--define and set new mission for steaming into wind
	local Mission = {
		id = 'Mission',
		params = {
			route = {
				points = _route
			}
		}
	}
	
	local ctr = Group.getByName(GroupName):getController()
	Controller.setTask(ctr, Mission)
end

--function to resume ship group on original route
function ResumeRoute(arg)
	env.info( "TurnIntoWind ResumeRoute? passe00: ")
	if FlightOpsOngoing[arg[3]] ~= true then
		local GroupName = arg[1]
		-- local pos = arg[2]
		-- GroupName = GroupName[1]
		-- env.info( "TurnIntoWind ResumeRoute? passe01: ")
		local heading = nil

		local groupCarrier = Group.getByName(GroupName)
		local carrier = groupCarrier:getUnit(1)	
		local Desc = carrier:getDesc()
		local heading = getHeadingByPos(carrier)
		local pos = carrier:getPoint()

		heading = rad2Deg(heading)
		-- env.info( "ResumeRoute radToDegheading : "..tostring(heading) )
		
		--search original group _route
		local _route = {}																				--variable to store a copy of the group route
		for coalition_name,coal in pairs(env.mission.coalition) do
			for country_n,country in ipairs(coal.country) do
				if country.ship then
					for group_n,group in ipairs(country.ship.group) do
						-- if GroupName == env.getValueDictByKey(group.name) then
						if GroupName == group.name then
							_route = deepcopy(group.route.points)										--make a copy of the route
						end
					end
				end
			end
		end
		
		--remove first _route point
		table.remove(_route, 1)	
		
		--search close waypoint in _route to continue from current position (first waypoint that subsequent waypoint is further away)
		local dist_to_wp = 10000000
		for n = 1, #_route do																			--find closest waypoint from current position (stop searching when first distance increase is found, regardless if later waypoints are even closer)
			local dist = math.sqrt(math.pow(_route[n].x - _route[1].x, 2) + math.pow(_route[n].y - _route[1].y, 2))		--distance form current position to waypoint n
			if dist > dist_to_wp then																	--distance to waypoint n is bigger than to previous waypoint
				for w = n - 2, 1, -1 do																	--remove all waypoints before waypoint n - 1
					table.remove(_route, w)
				end
				break																					--stop searching when first distance increase is found
			else																						--distance to waypoint n is smaller then to previous waypoint
				if n == #_route then																		--n is the last waypoint
					for w = n - 1, 1, -1 do																--remove all waypoints before waypoint n
						table.remove(_route, w)
					end
				else
					dist_to_wp = dist
				end
			end
		end	
		
		-- CIWS_Debug02	transforms an angle of more than 90° into 2 WPT of less than 90°
		local h1 = heading																-- cap actuel heading
		local h2 = GetHeading2(_route[1],_route[2] )										-- direction a prendre Heading
		local angle = GetDeltaHeadingIM(h1, h2)
		local bearing = 0
		
		-- env.info( "ResumeRoute SECOND h1: "..h1.." |h2: "..h2.." |angle: "..angle.." |bearing: "..bearing )
		
		if angle > 90 or angle < -90 then
			if angle > 90 then bearing = h1 + 90
			elseif angle < -90 then bearing = h1 - 90 end
			-- intercalWP = GetOffsetPointIM(point, bearing, distance)
			local intercalWP = GetOffsetPointIM(_route[1], bearing, 3500)
			
			local intercalRoute = {
				['alt'] = 0,
				['type'] = 'Turning Point',
				['ETA'] = 0,
				['alt_type'] = 'BARO',
				['formation_template'] = '',
				['y'] = intercalWP.y,
				['x'] = intercalWP.x,
				['name'] = '',
				['ETA_locked'] = false,
				['speed'] = Desc.speedMax - 1,
				['action'] = 'Turning Point',
				['task'] = {
					['id'] = 'ComboTask',
					['params'] = {
						['tasks'] = {},
					},
				},
				['speed_locked'] = true,
			}
			
			-- table.insert(maTable, 5, "très")
			table.insert(_route, 2, intercalRoute)
		end
		
		local Mission = {
			id = 'Mission',
			params = {
				route = {
					points = _route
				}
			}
		}
		_affiche(_route, "APRESintercalRoute _route")
		local ctr = Group.getByName(GroupName):getController()
		Controller.setTask(ctr, Mission)
		env.info("CWS Controller.setTask ResumeRoute")
	end
end

--table to collect aircraft engine startup/shutdown status
local EngineOn = {}
CollectEngineStatus = {}																			--event handler
function CollectEngineStatus:onEvent(event)
	if event.id == world.event.S_EVENT_ENGINE_STARTUP then
		if event.initiator then
			EngineOn[event.initiator:getName()] = true
		end
	elseif event.id == world.event.S_EVENT_ENGINE_SHUTDOWN then
		if event.initiator then
			EngineOn[event.initiator:getName()] = nil
		end
	end
end														

--function to enable carriers to turn into wind during flight ops
function CarrierIntoWind(GroupName)
	world.addEventHandler(CollectEngineStatus)														--start collection of aircraft startup/shutdown status to detect start/end of flight ops
	
	--reccuring function to check if there are aircraft to launch or recover
	local function CheckFlightOps()
		
		local group = Group.getByName(GroupName)													--get carrier group
		if group then																				--group exists
			local carrier = group:getUnit(1)														--get group leader (assumed to be the carrier)
			local carrierName = carrier:getName()													--get carrier name
			local carrierPos = carrier:getPoint()													--get position of carrier
			local carrierHeading = getHeadingByPos(carrier)
			local carrierCoal = carrier:getCoalition()												--get coalition of carrier
			local FlightOps = false																		
			
			--search for aircraft around carrier
			local function Found(u)
				local coal = u:getCoalition()														--get coalition of units
				if coal == carrierCoal then															--unit has same coalition as carrier
					local desc = u:getDesc()														--get unit description
					if desc.category == 0 then														--unit is an aircraft (no helicopters)
						local acPos = u:getPoint()													--get position of aircraft
						if u:inAir() then															--unit is in air
							if acPos.y < 1600 then													--aircraft is below 6000ft
								FlightOps = true													--there are flight ops
								return false														--stop search for more aircraft
							end
						else																		--aircraft is on the ground
							local dist = math.sqrt(math.pow(acPos.x - carrierPos.x, 2) + math.pow(acPos.z - carrierPos.z, 2))	--distance between aircraft and carrier
							if dist < 250 then														--aircraft is on the carrier
								if EngineOn[u:getName()] then										--aicraft has engine running
									FlightOps = true												--there are flight ops
									return false													--stop search for more aircraft
								end
							end
						end
					end
				end
				return true																			--continue search
			end

			local SearchArea = {
				id = world.VolumeType.SPHERE,
				params = {
					point = carrierPos,
					radius = 20000
				}
			}
			world.searchObjects(Object.Category.UNIT, SearchArea, Found)
			
			if FlightOps then																		--there are flight ops
				if FlightOpsOngoing[carrierName] ~= true then										--carrier is not currently conducting flight ops
					-- trigger.action.outText("Turn Into Wind", 5)
					-- env.info("CWS Turn Into Wind Vmax: "..Vmax)
					TurnIntoWind(GroupName, carrierPos, carrierHeading)												--turn carrier into wind
					FlightOpsOngoing[carrierName] = true											--store carrier flight ops status
				else
					-- trigger.action.outText("Flight Ops Ongoing", 5)
					-- env.info("CWS Flight Ops Ongoing ")
				end
			else																					--there are no flight ops
				if FlightOpsOngoing[carrierName] == true then										--carrier is currently conduction flight ops
					-- trigger.action.outText("Resume Route", 5)
					-- env.info("CWS Resume Route ")
					timer.scheduleFunction(ResumeRoute, {GroupName, carrierPos, carrierName}, timer.getTime() + 150)	--schedule resume carrier on route
					FlightOpsOngoing[carrierName] = nil												--store carrier flight ops status
				else
					-- trigger.action.outText("No Flight Ops", 5)
					-- env.info("CWS o Flight Ops ")
				end
			end
			
			return timer.getTime() + 2																--repeat function every 30 seconds
		end
	end

	if camp.SC_CarrierIntoWind == "auto" then
		timer.scheduleFunction(CheckFlightOps, nil, timer.getTime() + 30)								--schedule function
		-- timer.scheduleFunction(CheckFlightOps, nil, timer.getTime() + 2)								--schedule function
	end
	
end
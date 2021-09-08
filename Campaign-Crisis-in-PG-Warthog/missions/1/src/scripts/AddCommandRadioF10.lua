-- Adds functions in radio menu F10
--Script attached to mission and executed via trigger
--Functions accessed via LUA Run Script
------------------------------------------------------------------------------------------------------- 
--player can request emergency resupply with S-3B's
-- It is possible to send the whole PACK in RTB to avoid unnecessary losses. 
------------------------------------------------------------------------------------------------------- 
-- Miguel Fichier Revision M29.g M36.e
------------------------------------------------------------------------------------------------------- 

if not versionDCE then versionDCE = {} end
versionDCE["AddCommandRadioF10.lua"] = "1.05.23"

-- add Function
-- Miguel21 modification M36.e	(e: 1 h) (d: add timer) MenuRadio request manual TurnIntoWind
-- debug_ADD_CRF10.c	n'affiche pas les messages d'error sauf à la fin de mission
-- Miguel21 modification M36.e	Help CAP (e: camp rouge et bleu)
-- Miguel21 modification M32.c	E-2C automatic retreat (c: debug)
-- Miguel21 modification M29.g	MenuRadio  (g:movePlane) (f: CallTankRefuel camp rouge et bleu)




-- --prepare campaign path
-- local path = string.gsub(camp.path, "/", "\\")																		--replace slashes in campaign path with double-backslashes
-- if  string.sub (camp.path, 2, 2) ~= ":" then																		--si le chemin est differen de C:\Users ou D:\Users
	-- path = os.getenv('USERPROFILE') .. "\\" .. path																	--get path of windows userprofile and add to campaign path	
-- else
	-- pathDD = string.sub (camp.path, 1, 2)

-- end
-- path = path .."Mods\\tech\\DCE\\Missions\\Campaigns\\"..camp.title.."\\"											-- Miguel21 modification M35.b version ScriptsMod
-- env.info( "AdCR10 pathDCE "..tostring(path) )

		
		
		
if not camp.debug then 
	env.setErrorMessageBoxEnabled(false)
end


local commandDB = {}

tabBingoPlane = {}
	
	
	
 function _affiche(_table, titre, prof)


	--export custom mission log
	local logExp = "logExp  " 
		
 if not prof or prof == nil then prof = 999 end 						-- prof = profondeur de niveau dans la hierarchie
  logExp = logExp.."\n"
  
    if titre == nil then logExp = logExp.. string.format(" _affiche() titre = nil ")
    elseif type( titre) == "string" then
		logExp = logExp.. string.format(" _affiche(titre) "..tostring(titre)).."\n"
	end
  
	if type( _table) == "table"  then --and  (table.getn(_table) ~= 0 or table.getn(_table) ~= nil
	
		for a, b in pairs(_table) do --for a, b in pairs(event.initiator) do --for a, b in pairs(_ammo) do
			-- logExp.. " _affiche( a  ) ".. tostring(a).."\n"  
		
			if  type(b) ~= "table" then
				logExp = logExp.." _affiche (a b)     "..tostring(a).." "..tostring(b).."\n"
			elseif type(b) == "table"   and prof >= 2 then
				for c, d in pairs(b) do
					logExp = logExp.. " _affiche(a c)           "..tostring(a).." "..tostring(c).."\n"
					
					
					if type(d)~= "table"  then
						logExp = logExp.. " _affiche(d)                "..tostring(d).."\n"
					elseif type(d) == "table"  and prof >= 3 then
						for e, f in pairs(d) do
							-- logExp = logExp.. " _affiche( e)                     "..tostring(e).."\n"
							
							
							if type( f ) ~= "table"  then
								logExp = logExp.. " _affiche(e f)                          "..tostring(e).." "..tostring(f).."\n"
							elseif type( f ) == "table"  and prof >= 4 then
								logExp = logExp.. " _affiche( e)                                "..tostring(e).."\n"
								for g, h in pairs(f) do
									logExp = logExp.. " _affiche(Ig)                                 "..tostring(g).."\n"
									
									
									if type( h ) ~= "table"  then
										logExp = logExp.. " _affiche(g h)                                    "..tostring(g).." "..tostring(h).."\n"	
									elseif type( h ) == "table"  and prof >= 5 then
										logExp = logExp.. " _affiche( g)                                         "..tostring(g).."\n"
										for i, j in pairs(h) do
											-- logExp = logExp.. " _affiche(i)                                         "..tostring(i).."\n"
										
										
											if type( j ) ~= "table"  then
												logExp = logExp.. " _affiche(i j)                                              "..tostring(i).." "..tostring(j).."\n"
											elseif type( j ) == "table" and prof >= 6 then									
												logExp = logExp.. " _affiche(i)                                                  "..tostring(i).."\n"
												for k, l in pairs(j) do
													-- logExp = logExp.. " _affiche(k)                                                   "..tostring(k).."\n"
													
													if type( l ) ~= "table"  then
														logExp = logExp.. " _affiche(k l)                                                   "..tostring(k).." "..tostring(l).."\n"
													elseif type( l ) == "table" and prof >= 7 then
														logExp = logExp.. " _affiche(k)                                                       "..tostring(k).."\n"
														for m, n in pairs(l) do
															logExp = logExp.. " _affiche(m)                                                        "..tostring(m).."\n"
														
														
															if type( n ) ~= "table"  then
																logExp = logExp.. " _affiche(m n)                                                   "..tostring(m).." "..tostring(n).."\n"
															elseif type( n ) == "table" and prof >= 7 then
																logExp = logExp.. " _affiche(m)                                                       "..tostring(m).."\n"
																for o, p in pairs(n) do
																	logExp = logExp.. " _affiche(o)                                                        "..tostring(o).."\n"
														
														
																	if type( p ) ~= "table"  then
																		logExp = logExp.. " _affiche(p)                                                             "..tostring(p).."\n"
																	elseif type( p ) == "table"  and prof >= 8 then
																		logExp = logExp.. " p est une table                                                              "..tostring(p).."---------------------------".."\n"
																			
																	end
																end
															end --if
														end --for l
													end --if
												end -- for j
											end --if
										end -- for h
									end --if
								end --for f
							end --elseif
						end -- for d
					end -- if d
				end -- for v
			end -- if v
		end  -- for _table
	
	else logExp = logExp.. "_affiche NoTable==> " ..tostring(_table).."\n"
	
	end -- if if type( _table) == "table"

	
	-- log.write('MIGUEL.EXPORT',log.INFO,logExp)
	
	env.info( logExp )
	
end -- function affiche

--function to return distance between two vector2 points
function GetDistance(p1, p2)
	local deltax = p2.x - p1.x
	local deltay = p2.y - p1.y
	return math.sqrt(math.pow(deltax, 2) + math.pow(deltay, 2))
end

function radToDeg(_rad)
	radToDeg = _rad * (180/math.pi)
	return radToDeg
end 

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

-- local degToRad = math.pi/180


--function to return a new point offset from an initial point
function GetOffsetPointIM(point, heading, distance)
	return {
		x = point.x + math.cos(math.rad(heading)) * distance,
		y = point.y + math.sin(math.rad(heading)) * distance
	}
end
--function to return heading between two vector2 points
function GetHeading2(p1, p2)
	local deltax = p2.x - p1.x
	local deltay = p2.y - p1.y	
	local heading = 0
	
	if (deltax > 0) and (deltay == 0) then
		heading = 0
	elseif (deltax > 0) and (deltay > 0) then
		heading = math.deg(math.atan(deltay / deltax))
	elseif (deltax == 0) and (deltay > 0) then
		heading = 90
	elseif (deltax < 0) and (deltay > 0) then
		heading = 90 - math.deg(math.atan(deltax / deltay))
	elseif (deltax < 0) and (deltay == 0) then
		heading = 180
	elseif (deltax < 0) and (deltay < 0) then
		heading = 180 + math.deg(math.atan(deltay / deltax))
	elseif (deltax == 0) and (deltay < 0) then
		heading = 270
	elseif (deltax > 0) and (deltay < 0) then
		heading = 270 - math.deg(math.atan(deltax / deltay))
	else
		heading = 0
	end

	return heading
end

--https://github.com/mrSkortch/MissionScriptingTools/releases
--- Returns heading of given unit.
-- @tparam Unit unit unit whose heading is returned.
-- @param rawHeading
-- @treturn number heading of the unit, in range
-- of 0 to 2*pi.
function getHeadingByPos(unit)
	local unitpos = unit:getPosition()
	local Heading = 0
	if unitpos then
		local Heading = math.atan2(unitpos.x.z, unitpos.x.x)
		if Heading < 0 then
			Heading = Heading + 2*math.pi	-- put heading in range of 0 to 2*pi
		end
		return Heading
	else
		return nil
	end
end

--function to return the angle between two headings
function GetDeltaHeadingIM(h1, h2)
	local delta = h2 - h1
	if delta > 180 then
		delta = delta - 360
	elseif delta <= -180 then
		delta = delta + 360
	end
	return delta
end

function FctRemovePlane(_unit)
	_unit:destroy()
end

function RemovePlane(PlayerGroup)

	local PlayerUnits = PlayerGroup:getUnits()
	local PlayerUnit = PlayerUnits[1]	
	local PlayerUnitPoint = PlayerUnit:getPoint()
	local Coalition = PlayerUnit:getCoalition()
	missionCommands.removeItem( {"nearby aircraft"})
	local requestM = missionCommands.addSubMenu('nearby aircraft'  )
	local RPlane = {}
	local groups = coalition.getGroups(Coalition, Group.Category.AIRPLANE)
	for i, gp in pairs(groups) do	
		local gpName = Group.getName(gp)
		local units = gp:getUnits()
		 
		for n=1, #units do
			local _unit = units[n]
			if  _unit:isActive() and not _unit:inAir() then
				
				local description = _unit:getDesc()	
				
				-- _affiche(description, "description")
				
				local unitPos = _unit:getPoint()
				local  gpGid = Group.getID(gp)
				local  UnitId = Unit.getID(_unit)
				local unitCallsign = _unit:getCallsign()
				local distance = math.floor(math.sqrt(math.pow(unitPos.x - PlayerUnitPoint.x, 2) + math.pow(unitPos.z - PlayerUnitPoint.z, 2)))
				if distance <= 900 then
					env.info(gpName.." "..unitCallsign.." "..distance.."m ")
					-- trigger.action.outText(gpName.." "..unitCallsign.." "..distance.."m ", 15)	--FOR DEBUG
					-- local subN1 = missionCommands.addSubMenu(gpName.." "..UnitId, requestM)
					RPlane[UnitId] = missionCommands.addCommand(gpName.." "..unitCallsign, requestM, FctRemovePlane, _unit)
				end
			end
		end
	end
end


-- Miguel21 modification M32	E-2C automatic retreat 
function AirRetreat()
	
	local current_time = timer.getTime()
	
	local groups = coalition.getGroups(coalition.side.BLUE, Group.Category.AIRPLANE)
	
	for i, gp in pairs(groups) do	
	
		local gpName = Group.getName(gp)
		
		if   string.find(gpName,"AWACS") then
			local units = gp:getUnits()
			local _unit = units[1]
	
			if _unit:getTypeName() == "E-2C" and _unit:isActive() and _unit:inAir() then
				local awacs_point = _unit:getPoint()
				local  gpGid = Group.getID(gp)
				local nameAwacs =  _unit:getName()
				if not RetreatTimeGp then RetreatTimeGp = {} end
				if not RetreatTimeGp[gpGid] then RetreatTimeGp[gpGid] = {} end
				if not RetreatTimeGp[gpGid].rTime then RetreatTimeGp[gpGid].rTime = 0  end
				
				if _unit and current_time >  RetreatTimeGp[gpGid].rTime then							--if _unit exists
					local ctr = _unit:getGroup():getController()										--get _unit controller
					local targets = ctr:getDetectedTargets()											--get detected targets of this EWR
					for t = 1, #targets do																--iterate through detected targets
						if targets[t].object and current_time >  RetreatTimeGp[gpGid].rTime then
							local objCat = targets[t].object:getCategory()								--get object category
							if objCat == 1 then															--object is a _unit
								local desc = targets[t].object:getDesc()								--get descriptor descriptor
								local descAwacs = _unit:getDesc()
								
								-- local logStr = "descAwacs = " .. TableSerialization(descAwacs, 0)
								-- local logFile = io.open(path.."_"..nameAwacs.."_".. "desc_AWACS.lua", "w")
								-- logFile:write(logStr)
								-- logFile:close()	
								
								if desc.category == 0  then												--descriptor category is airplane 
									local target_point = targets[t].object:getPoint()					--get target point					
									local distance = math.sqrt(math.pow(awacs_point.x - target_point.x, 2) + math.pow(awacs_point.z - target_point.z, 2))
									
									if distance < 100000 then
									-- if distance < 150000 then 
										
										local callsign = _unit:getCallsign()
										env.info("ACRF10 DCE AWACS |03b|: Order to Retire "..distance)
										env.info("ACRF10 DCE AWACS |03c|: Order to Retire "..callsign.." Retreat to the aircraft carrier")
										trigger.action.outText(callsign.." Retreat to the aircraft carrier",10)
										
										--active le waypoint du PA										
										RetreatTimeGp[gpGid].rTime = current_time + 300

										local carrierDistance = 99999999
										local xRetreat = 0
										local yRetreat = 0						
										for coalition_name,coal in pairs(env.mission.coalition) do
											if coalition_name == camp.player.side then
												for country_n,country in ipairs(coal.country) do
													if country.ship then
														for group_n,group in ipairs(country.ship.group) do			
															local groupCarrier = Group.getByName(group.name)													--get carrier group
															if groupCarrier then																				--group exists
																local carrier = groupCarrier:getUnit(1)															--get group leader (assumed to be the carrier)								
																local Desc = carrier:getDesc()					
																if Desc.attributes.AircraftCarrier or Desc.attributes["Aircraft Carriers"] then 
																	local carrierPos = carrier:getPoint()
																	local distance = math.sqrt(math.pow(carrierPos.x - awacs_point.x, 2) + math.pow(carrierPos.z - awacs_point.z, 2))
																	if distance < carrierDistance then																		
																		xRetreat = carrierPos.x
																		yRetreat = carrierPos.z																
																		carrierDistance =  distance
																	end
																end
															end
														end
													end
												end
											end
										end
										

										for _coalition, coalition in pairs(env.mission.coalition) do
											if _coalition == camp.player.side then
												for Ncountry, _country in pairs(coalition.country) do	
													if _country.plane then
														for Ngroup, _group in pairs(_country.plane.group) do
															if _group.groupId == gpGid then 
															
																-- si aucun CVN n'a été trouvé, on prend comme position de retraite l'ID "land"
																if xRetreat == 0 then
																	for key, value in ipairs(_group.route.points) do				-- recherche de la position safe du PA et une alti						
																		if value.type == 'Land' then
																			xRetreat = value.x
																			yRetreat = value.y
																		end
																	end
																end
																local retreatRoute = {}
																
																-- retreatRoute = _group.route.points										--copie de l'ancienne route
																retreatRoute = deepcopy(_group.route.points)
																
																-- ajoute comme premier wpt leur position initial pour garder la fonction AWACS
																local FirstWPT = {
																	['alt'] = awacs_point.y,
																	['type'] = 'Turning Point',
																	['action'] = 'Turning Point',
																	['alt_type'] = 'BARO',
																	['speed_locked'] = true,
																	['y'] = awacs_point.z,
																	['x'] = awacs_point.x,
																	['formation_template'] = '',
																	['speed'] = descAwacs.speedMax,
																	['ETA_locked'] = true,
																	['task'] = {
																		['id'] = 'ComboTask',
																		['params'] = {
																			['tasks'] = {
																				[1] = {
																					['enabled'] = true,
																					['auto'] = false,
																					['id'] = 'ControlledTask',
																					['number'] = 1,
																					['params'] = {
																						['task'] = {
																							['id'] = 'AWACS',
																							['params'] = {
																							},
																						},
																					},
																				},
																				[2] = {
																					['enabled'] = true,
																					['auto'] = false,
																					['id'] = 'WrappedAction',
																					['number'] = 2,
																					['params'] = {
																						['action'] = {
																							['id'] = 'Option',
																							['params'] = {
																								['variantIndex'] = 1,
																								['value'] = 458753,
																								['name'] = 5,
																								['formationIndex'] = 7,
																							},
																						},
																					},
																				},
																				[3] = {
																					['enabled'] = true,
																					['auto'] = true,
																					['id'] = 'WrappedAction',
																					['number'] = 3,
																					['params'] = {
																						['action'] = {
																							['id'] = 'EPLRS',
																							['params'] = {
																								['value'] = true,
																								['groupId'] = 1,
																							},
																						},
																					},
																				},
																				[4] = {
																					['enabled'] = true,
																					['auto'] = false,
																					['id'] = 'WrappedAction',
																					['number'] = 4,
																					['params'] = {
																						['action'] = {
																							['id'] = 'Option',
																							['params'] = {
																								['value'] = 2,
																								['name'] = 1,
																							},
																						},
																					},
																				},
																			},
																		},
																	},
																	['ETA'] = 0,
																}
																
																
																table.insert(retreatRoute, 1, FirstWPT)
																	
																--modifie les coordonées du premier wpt initial
																retreatRoute[2].x = xRetreat
																retreatRoute[2].y = yRetreat
																retreatRoute[2].alt = awacs_point.y
																retreatRoute[2].speed_locked = true
																retreatRoute[2].ETA_locked = false
																retreatRoute[2].speed = descAwacs.speedMax
																retreatRoute[2].ETA = RetreatTimeGp[gpGid].rTime
																
																local idTasks = #retreatRoute[2].task.params.tasks
																local orbitRetreat = {
																			
																			['enabled'] = true,
																			['auto'] = false,
																			['id'] = 'ControlledTask',
																			['number'] = idTasks+2,
																			['params'] = {
																				['task'] = {
																					['id'] = 'Orbit',
																					['params'] = {
																						['altitude'] = 7315.2,
																						['pattern'] = 'Circle',
																						['speed'] = 138.889,
																					},
																				},
																				['stopCondition'] = {
																					['time'] = RetreatTimeGp[gpGid].rTime,
																				},
																			},
																			
																		}
																
																retreatRoute[2].task.params.tasks[idTasks +1] =  orbitRetreat
																
																--ajoute la task awacs au premier wpt pour garder la fonction awacs operationnel
																local TaskAwacs = {
																		
																		['enabled'] = true,
																		['auto'] = false,
																		['id'] = 'ControlledTask',
																		['number'] = 1,
																		['params'] = {
																			['task'] = {
																				['id'] = 'AWACS',
																				['params'] = {
																				},
																			},
																		},
																		
																	}
																table.insert(retreatRoute[2].task.params.tasks, 1, TaskAwacs)																		
															
																--renumerote les number des task																	
																for i=1, #retreatRoute[1].task.params.tasks do															
																	retreatRoute[1].task.params.tasks[i].number = i																																		
																end

																local Mission = {														--define mission for retreat AWACS
																		id = 'Mission', 
																		params = {
																			route = {
																				points = retreatRoute
																			},
																		}
																	}	
																
																	
																-- local logStr = "Mission = " .. TableSerialization(Mission, 0)
																-- local logFile = io.open(path.."_"..nameAwacs.."_".. "Mission_AWACSretreatRoute.lua", "w")
																-- logFile:write(logStr)
																-- logFile:close()	

																Controller.setTask(ctr, Mission)										--activate task with mission for retreat AWACS
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
					end
				end
			end
		end
	end
	return timer.getTime() + 1
end

function bingo(gpGid, PlayerGroup)

	for index, data in pairs(PlayerGroup:getUnits()) do
		
		local callSign = Unit.getCallsign(data)
		
		if not tabBingoPlane[gpGid] then tabBingoPlane[gpGid] = {} end
		
		if tabBingoPlane[gpGid] and not tabBingoPlane[gpGid][callSign] then												-- si le callSign a deja dit qu'il etait Bingo, on l'oublie
		
			if Unit.getFuel(data) <  0.25 then																			-- Sur F14, 4000lbs/16000lbs = 0.25%

				trigger.action.outTextForGroup(gpGid, callSign .." Bingo Fuel", 15 , true)
				env.info( " Unit.getFuel(data)  "..callSign )
			
				tabBingoPlane[gpGid][callSign] = true																	-- la callSign � d�ja indiqu� qu'il �tait Bingo
			
			end 
		end
	end
end


LLtool = {}

LLtool.LLstrings = function(pos) -- pos is a Vec3

	local LLposN, LLposE = coord.LOtoLL(pos)
	local LLposfixN, LLposdegN = math.modf(LLposN)
	LLposdegN = LLposdegN * 60
	local LLposdegN2, LLposdegN3 = math.modf(LLposdegN)
	LLposdegN3 = LLposdegN3 * 1000

	local LLposfixE, LLposdegE = math.modf(LLposE)
	LLposdegE = LLposdegE * 60
	local LLposdegE2, LLposdegE3 = math.modf(LLposdegE)
	LLposdegE3 = LLposdegE3 * 1000

	local LLposNstring = string.format('%+.2i %.2i %.3d', LLposfixN, LLposdegN2, LLposdegN3)
	local LLposEstring = string.format('%+.3i %.2i %.3d', LLposfixE, LLposdegE2, LLposdegE3)
	
	return LLposNstring, LLposEstring
end


function BullsEye(PlayerGroup)

	-- ['coalition'] = {
			-- ['blue'] = {
				-- ['bullseye'] = {
					-- ['y'] = 635639.37385346,
					-- ['x'] = -317948.32727306,
				-- },
	local gpGid = PlayerGroup:getID()
	local PlayerUnits = PlayerGroup:getUnits()
	local PlayerUnit = PlayerUnits[1]
	
	local Coalition = PlayerUnit:getCoalition()
	
	sideT = {
		[0] = "neutral",
		[1] = "red",
		[2] = "blue"
		}
	
	local bullsEye_pos = {
			x = env.mission.coalition[sideT[Coalition]].bullseye.x,
			y = 0,
			z = env.mission.coalition[sideT[Coalition]].bullseye.y
		}

	LLposNstring, LLposEstring = LLtool.LLstrings(bullsEye_pos)    

	trigger.action.outTextForGroup(gpGid, "BullsEye: "..'N ' .. LLposNstring .. '   E ' .. LLposEstring, 45 , true)

end

function FctRtbGroup(rtbGroup)

	trigger.action.outText("RTB "..tostring(rtbGroup.name), 5)	--FOR DEBUG
	
	local gp = Group.getByName(rtbGroup.name) 

	local rtbCtr = Group.getController(gp)


	local switchtask = {
			id = "SwitchWaypoint", 
				params = {
					goToWaypointIndex = rtbGroup.to,
					fromWaypointIndex = rtbGroup.from
			}
		}

	rtbCtr:setCommand(switchtask)
	
end



function RtbPack(PlayerGroup)

	for _coalition, coalition in pairs(env.mission.coalition) do
		if _coalition == camp.player.side then
			for Ncountry, _country in pairs(coalition.country) do	
				if _country.plane then
					for Ngroup, _group in pairs(_country.plane.group) do
						if string.find(_group.name,"Pack "..camp.player.pack_n) then 				
							
							local rtbGroup = {
									name = "",
									from = 0,
									to = 0
								}
				
				
							rtbGroup.name = _group.name
							
							for key, value in ipairs(_group.route.points) do						
								if value.type == 'Land' then
									rtbGroup.to = key -1
									rtbGroup.from = key
								end

							end
						
							if rtbGroup.name and rtbGroup.to ~= 0 then
								FctRtbGroup(rtbGroup)
							end
							
						end
					end
				end
			end
		end
	end
end

function ReFueling(PlayerGroup)
	
	local player = {
		["point"] = {}
	}

	local tanker = {
		["point"] = {},
		["name"] = "",
		["distance"] = 0, 
		["gpName"] = ""
	}
	
	local PlayerUnits = PlayerGroup:getUnits()
	local PlayerUnit = PlayerUnits[1]	
	local uid = PlayerUnit:getID()
	
	-- fichier miz:
		-- plan haut, droite, alti : x/y/z
	-- vue F10 et vector3d:
		-- plan haut, droite, alti : x/z/y
		
	local PtempPoint = PlayerUnit:getPoint()											
			player.point.x = PtempPoint.x
			player.point.y = PtempPoint.z
			player.point.z = PtempPoint.y
	local Coalition = PlayerUnit:getCoalition()
	local groups = coalition.getGroups(Coalition, Group.Category.AIRPLANE)
	local speed = PlayerUnit:getVelocity()
	player.speed = math.sqrt(speed.x^2 + speed.y^2 + speed.z^2)
	-- local groups = coalition.getGroups(coalition.side.BLUE, Group.Category.AIRPLANE)
	local selected_distance = 99999999
	
	for i, gp in pairs(groups) do		
		local gpName = Group.getName(gp)		
		if   string.find(gpName,"Refueling") then 
			local units = gp:getUnits()
			local _unit = units[1]
			local fuel = _unit:getFuel()
			local callsign = _unit:getCallsign()
			local TankerTypeName = _unit:getTypeName()
			local t = {
						["point"] = {}
						}
						
			local TtempPoint = _unit:getPoint()
					t.point.x = TtempPoint.x
					t.point.y = TtempPoint.z
					t.point.z = TtempPoint.y
					
			local description = _unit:getDesc()	
	
			if (description.attributes.Refuelable or description.attributes.Tankers ) and _unit:isActive() then
			-- if _unit:getTypeName() == "S-3B Tanker" and _unit:isActive() then			
			-- if _unit:getTypeName() == "S-3B Tanker"  and t.point.z > 100 and _unit:isActive() then			
				
				local Tdistance = math.sqrt(math.pow(t.point.x - player.point.x, 2) + math.pow(t.point.y - player.point.y, 2))		--distance between tanker and player
				if Tdistance < selected_distance then
					tanker.point = t.point
					tanker.TypeName = TankerTypeName
					tanker.distance = Tdistance
					tanker.gpName = tostring(gpName)
					tanker.ctr = Group.getController(gp)
					tanker.callsign = callsign
					tanker._unit = _unit
					tanker.Desc = _unit:getDesc()
					selected_distance =  Tdistance					
				end
			end
		end
	end

	local heading  = GetHeading2(tanker.point, player.point)		--return heading between two vector2 points
	local dist = tanker.distance / 2
	local interception_pos = GetOffsetPointIM(tanker.point, heading, dist)		--function to return a new point offset from an initial point
	local interception_alt = player.point.z 
	local pattern_alt = player.point.z 	
	local pattern_speed = player.speed
	
	if interception_alt < 1000 and dist > 50000 then
		interception_alt = 3000
	elseif interception_alt > 6100  then										-- alti max:6100
		interception_alt = 6100
		pattern_alt = 6100
	end	
	
	if pattern_speed < 130  then
		pattern_speed = 130
	elseif pattern_speed > 200  then											-- vi max:6100
		pattern_speed = 200
	end	
	
	local infoSpeed = math.floor(pattern_speed / 0.51444444444)					-- m/s to Kts
	local infoAlti = math.floor((pattern_alt * 3.2808398950131 )/100)*100		-- m to ft	
	local intercept_pos = {
					x = interception_pos.x,
					y = pattern_alt,
					z = interception_pos.y
					}
					
	local intercept_LL =  coord.LOtoLL(intercept_pos)
	
	LLposNstring, LLposEstring = LLtool.LLstrings(intercept_pos)
	trigger.action.outText(tanker.callsign.." "..tanker.gpName.." Rdv: "..'N ' .. LLposNstring .. '   E ' .. LLposEstring.." Alt: "..infoAlti.." Speed "..infoSpeed, 20)	
	
		local Mission = {														--define mission for interceptor group
			id = 'Mission', 
			params = {
				route = {
					["points"] = {
						[1] = {
							["alt"] = interception_alt,
							["type"] = "Turning Point",
							["action"] = "Turning Point",
							["alt_type"] = "BARO",
							["formation_template"] = "",
							["y"] = interception_pos.y ,
							["x"] = interception_pos.x ,
							["speed"] = 200,
							["ETA_locked"] = false,
							["task"] = {
								["id"] = "ComboTask",
								["params"] = 
								{
									["tasks"] = 
									{
									
										[1] = 
										{
											["number"] = 1,
											["auto"] = false,
											["id"] = "Tanker",
											["enabled"] = true,
											["params"] = 
											{
											}, -- end of ["params"]
										}, -- end of [1]
										[2] = 
										{
											["number"] = 2,
											["auto"] = false,
											["id"] = "ControlledTask",
											["enabled"] = true,
											["params"] = 
											{
												["task"] = 
												{
													["id"] = "Orbit",
													["params"] = 
													{
														["altitude"] = pattern_alt,
														["pattern"] = "Circle",
														["speed"] = pattern_speed,
														["speedEdited"] = true,
													}, -- end of ["params"]
												}, -- end of ["task"]
												["stopCondition"] = 
												{
													["duration"] = 600,
												}, -- end of ["stopCondition"]
											}, -- end of ["params"]
										}, -- end of [2]
									}, -- end of ["tasks"]
								}, -- end of ["params"]
							},
							["speed_locked"] = true,
						},
						[2] = {
							["alt"] = tanker.point.z,
							["type"] = "Turning Point",
							["action"] = "Turning Point",
							["alt_type"] = "BARO",
							["formation_template"] = "",
							-- ["ETA"] = 0,
							["y"] = tanker.point.y,
							["x"] = tanker.point.x,
							["speed"] = 180,
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
	
		Controller.setTask(tanker.ctr, Mission)																			--activate task with mission for interceptor group							
end

function RequestCAP(PlayerGroup)
	-- Miguel21 modification M36	Help CAP 
	local player = {
		["point"] = {}
	}

	local CAP = {
		["point"] = {},
		["name"] = "",
		["distance"] = 0, 
		["gpName"] = ""
	}
	
	local PlayerUnits = PlayerGroup:getUnits()
	local PlayerUnit = PlayerUnits[1]	
	local uid = PlayerUnit:getID()
	
	-- fichier miz:
		-- plan haut, droite, alti : x/y/z
	-- vue F10 et vector3d:
		-- plan haut, droite, alti : x/z/y
		
	local PtempPoint = PlayerUnit:getPoint()											
			player.point.x = PtempPoint.x
			player.point.y = PtempPoint.z
			player.point.z = PtempPoint.y			
			
	local Coalition = PlayerUnit:getCoalition()
	local groups = coalition.getGroups(Coalition, Group.Category.AIRPLANE)
	local speed = PlayerUnit:getVelocity()
	player.speed = math.sqrt(speed.x^2 + speed.y^2 + speed.z^2)
	
	-- local groups = coalition.getGroups(coalition.side.BLUE, Group.Category.AIRPLANE)
	local selected_distance = 99999999
	
	for i, gp in pairs(groups) do
		
		local gpName = Group.getName(gp)
		
		if   string.find(gpName,"CAP") then 
			local units = gp:getUnits()
			local _unit = units[1]
			local fuel = _unit:getFuel()
			local callsign = _unit:getCallsign()
			local TankerTypeName = _unit:getTypeName()
			local t = {
						["point"] = {}
						}
						
			local TtempPoint = _unit:getPoint()
					t.point.x = TtempPoint.x
					t.point.y = TtempPoint.z
					t.point.z = TtempPoint.y
	
			if  _unit:isActive() then	
			-- if _unit:getTypeName() == "S-3B Tanker"  and t.point.z > 100 and _unit:isActive() then			
				
				local Tdistance = math.sqrt(math.pow(t.point.x - player.point.x, 2) + math.pow(t.point.y - player.point.y, 2))		--distance between tanker and player

				if Tdistance < selected_distance then

					CAP.point = t.point
					CAP.TypeName = TankerTypeName
					CAP.distance = Tdistance
					CAP.gpName = tostring(gpName)
					CAP.ctr = Group.getController(gp)
					CAP.callsign = callsign
					CAP._unit = _unit
					CAP.Desc = _unit:getDesc()
					selected_distance =  Tdistance
					
				end
			end
		end
	end
--[[	
	local  gpGid = Group.getID(gp)
	
	for _coalition, coalition in pairs(env.mission.coalition) do
		if _coalition == camp.player.side then
			for Ncountry, _country in pairs(coalition.country) do	
				if _country.plane then
					for Ngroup, _group in pairs(_country.plane.group) do
						if _group.groupId == gpGid then 				
							
							frequencyCAP = _group.frequency	
								
						end
					end
				end
			end
		end
	end
]]

--[[
export in low tick interval to Ikarus
Example from A-10C
Get Radio Frequencies
get data from device
local lUHFRadio = GetDevice(54)
ExportScript.Tools.SendData("ExportID", "Format")
ExportScript.Tools.SendData(2000, string.format("%7.3f", lUHFRadio:get frequency()/1000000)) <- special function for get frequency data
]]


	local heading  = GetHeading2(CAP.point, player.point)					--return heading between two vector2 points
	local dist = CAP.distance / 1.5											-- approche le CAP 
	
	CAP.velocity = CAP._unit:getVelocity() 
	CAP.speed = math.sqrt(CAP.velocity.x^2 + CAP.velocity.y^2 + CAP.velocity.z^2)
	
	local interception_pos = GetOffsetPointIM(CAP.point, heading, dist)		--function to return a new point offset from an initial point

	local interception_alt = player.point.z 
	local pattern_speed 													-- ex = player.speed
	
	if interception_alt < 3000 and dist > 50000 then
		interception_alt = 7600
	elseif interception_alt > 6100  then										-- alti max:6100
		interception_alt = 7600		
	end	

	trigger.action.outText(CAP.callsign.." "..CAP.gpName, 20)
	
	
		local Mission = {														--define mission for interceptor group
			id = 'Mission', 
			params = {
				route = {
					["points"] = {
						
						[1] = {
							['alt'] = interception_alt,
							['briefing_name'] = 'Station',
							['action'] = 'Turning Point',
							['alt_type'] = 'BARO',
							['properties'] = {
								['vnav'] = 1,
								['scale'] = 0,
								['angle'] = 0,
								['vangle'] = 0,
								['steer'] = 2,
							},
							['speed_locked'] = true,
							['speed'] = 290,									-- vitesse du son  295 a 20000m
							['ETA'] = 1,
							["y"] = interception_pos.y ,
							["x"] = interception_pos.x ,
							['formation_template'] = '',
							['name'] = 'Station',
							['ETA_locked'] = false,
							['task'] = {
								['id'] = 'ComboTask',
								['params'] = {
									['tasks'] = {
										[1] = {
											['enabled'] = true,
											['auto'] = false,
											['id'] = 'ControlledTask',
											['number'] = 1,
											['params'] = {
												['task'] = {
													['id'] = 'EngageTargetsInZone',
													['params'] = {
														['targetTypes'] = {
															[1] = 'Air',
															[2] = 'Cruise missiles',
														},
														['x'] = player.point.x,
														['value'] = 'Air;Cruise missiles;',
														['priority'] = 0,
														['y'] = player.point.y,
														['zoneRadius'] = 111000,
													},
												},
												['stopCondition'] = {
													['lastWaypoint'] = 3,
												},
											},
										},
										[2] = {
											['enabled'] = true,
											['auto'] = false,
											['id'] = 'ControlledTask',
											['number'] = 2,
											['params'] = {
												['task'] = {
													['id'] = 'Orbit',
													['params'] = {
														['altitude'] = CAP.point.z,
														['pattern'] = 'Race-Track',
														['speed'] = CAP.speed,
													},
												},
												['stopCondition'] = {
													['time'] = 1000,
												},
											},
										},
									},
								},
							},
							['type'] = 'Turning Point',
						},
					},
				}
			}
		}--local Mission = {	
	
	
		Controller.setTask(CAP.ctr, Mission)																			--activate task with mission for interceptor group
		
		trigger.action.outText("ADD_CR "..CAP.callsign.." "..CAP.gpName, 60)
end


function addFuncs(gid, Group)	
	if gid and Group then		
		-- supprime les anciens items de la commande F10
		missionCommands.removeItemForGroup(gid, {"Urgent_Refueling"})
		missionCommands.removeItemForGroup(gid, {"Urgent_RequestCAP"})
		missionCommands.removeItemForGroup(gid, {"BullsEye_LongLat"})	
		missionCommands.removeItemForGroup(gid, {"Package_RTB"})
		missionCommands.removeItemForGroup(gid, {"RemovePlane"})
		missionCommands.removeItemForGroup(gid, {"CarrierIntoWind"})		

		missionCommands.addCommandForGroup(gid, "Urgent_Refueling", nil, ReFueling, Group)
		missionCommands.addCommandForGroup(gid, "Urgent_RequestCAP", nil, RequestCAP, Group)
		missionCommands.addCommandForGroup(gid, "BullsEye_LongLat", nil, BullsEye, Group)
		missionCommands.addCommandForGroup(gid, "Package_RTB", nil, RtbPack, Group)
		missionCommands.addCommandForGroup(gid, "RemovePlane", nil, RemovePlane, Group)

		if camp.SC_CarrierIntoWind == "man" then																					
			missionCommands.removeItemForGroup(gid, {"CarrierIntoWind"})
			local subR = missionCommands.addSubMenuForGroup(gid, "CarrierIntoWind", nil)		
			for coalition_name,coal in pairs(env.mission.coalition) do
				for country_n,country in ipairs(coal.country) do
					if country.ship then
						for group_n,group in ipairs(country.ship.group) do			
							local groupCarrier = Group.getByName(group.name)													--get carrier group
							if groupCarrier then																				--group exists
								local carrier = groupCarrier:getUnit(1)															--get group leader (assumed to be the carrier)								
								local Desc = carrier:getDesc()					
								if Desc.attributes.AircraftCarrier or Desc.attributes["Aircraft Carriers"] then 
									local carrierPos = carrier:getPoint()														--get position of carrier
									local GroupName = group.name
									missionCommands.addCommandForGroup(gid, group.name.." Into Wind 30mn", subR, TurnIntoWind, {GroupName, nil, nil, 30} )	-- Miguel21 modification M36.d	(d: add timer) MenuRadio request manual TurnIntoWind
									missionCommands.addCommandForGroup(gid, group.name.." Into Wind 60mn", subR, TurnIntoWind, {GroupName, nil, nil, 60} )									
									missionCommands.addCommandForGroup(gid, group.name.." Resume Route", subR, ResumeRoute, {group.name, nil} )
								end	
							end
						end
					end
				end
			end
		end

		-- The solution is to use env.mission.coalition where you find all object informations even groupId
		-- https://forums.eagle.ru/showthread.php?t=147792&page=15
		
		 -- commandDB['RUR'] = missionCommands.addCommandForGroup(gid,"UrgentRefueling", nil, ReFueling, Group)
		 -- commandDB['speed'] = missionCommands.addCommandForGroup(gid,"Testing", nil, Test, Group)
		 -- commandDB['RTB'] = missionCommands.addCommandForGroup(gid,"Package_RTB", nil, RtbPack, Group)
	end
end

EventHandler2 = {}
function EventHandler2:onEvent(event)

	if event.id == world.event.S_EVENT_BIRTH then

		local Gname = event.initiator:getPlayerName()
		local Uid = event.initiator:getID()
		local Group = event.initiator:getGroup()
		local gpGid = event.initiator:getGroup():getID()

		if gpGid and Group and Gname  then 
			
			-- trigger.action.outText("RR Passe S_EVENT_BIRTH--"..tostring(Gname).." "..gpGid, 15)	--FOR DEBUG
			
			addFuncs(gpGid, Group)
		end
		
	elseif event.subPlace then 
		-- env.info("RR PasseEvent 003 subPlace")																								--debug ET01	
		
		local Gname = event.initiator:getPlayerName()
		local Uid = event.initiator:getID()
		local Group = event.initiator:getGroup()
		local gpGid = event.initiator:getGroup():getID()

		if gpGid  and Group and Gname then 			
			addFuncs(gpGid, Group)
		end
	end
	
end

world.addEventHandler(EventHandler2)



function LoopPilot()

	local groups = coalition.getGroups(coalition.side.BLUE, Group.Category.AIRPLANE)
	
	for i, gp in pairs(groups) do
		local  gpName = Group.getName(gp)
		local  gpGid = Group.getID(gp)
		
		if gpGid  and gp then 
			bingo(gpGid, gp)
		end		
	end

	groups = coalition.getGroups(coalition.side.RED, Group.Category.AIRPLANE)
	
	for i, gp in pairs(groups) do
		local  gpName = Group.getName(gp)
		local  gpGid = Group.getID(gp)
		
		if gpGid  and gp then 
			bingo(gpGid, gp)
		end		
	end
			
	return timer.getTime() + 15

end

timer.scheduleFunction(LoopPilot, nil, timer.getTime() + 15)	

timer.scheduleFunction(AirRetreat, nil, timer.getTime() + 5)



  
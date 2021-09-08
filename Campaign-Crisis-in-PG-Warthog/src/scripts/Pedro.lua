-- initie par MAIN_NextMission
-- auteur : Miguel21
-- Garde le Pedro (Helicoptere de sauvetage), proche du CVN, malgr� les changements de cap
-- Keeps the Pedro (Rescue Helicopter), close to the CVN, in spite of course changes.
------------------------------------------------------------------------------------------------------- 
-- Miguel Fichier Revision M40.b (dev 018)
-------------------------------------------------------------------------------------------------------

-- miguel21 modification M40.b : Pedro Helicopter (b: TakeOff)
do

	findPedro = false
	local TabPedro	
	function creatTabPedro()		
		for coalition_name,coal in pairs(env.mission.coalition) do
			for country_n,country in pairs(coal.country) do
				if country.helicopter then
					for group_n,group in pairs(country.helicopter.group) do
						for w = 1, #group.units do																		--iterate through all group waypoints							
							if string.find(env.getValueDictByKey(group.units[w].name), "Pedro_") then					--find egress waypoint								
								local PedroName = env.getValueDictByKey(group.units[w].name)
								if string.find(PedroName, "Pedro_") then
									findPedro = true
									-- env.info("Pedro PedroName "..PedroName)
									
									local ShipName = string.gsub(PedroName, "Pedro_", "")										
									local Ship_unit = Unit.getByName(ShipName)										
									local Ship_group = Unit.getGroup(Ship_unit)
									local Pedro_unit = Unit.getByName(PedroName)
									local Pedro_group = Pedro_unit:getGroup()
									
									if not TabPedro then TabPedro = {} end
									if not TabPedro[PedroName] then TabPedro[PedroName] = {} end
									TabPedro[PedroName] = {
											["ShipName"] = ShipName,
											["Ship_group"] = Ship_group,
											["Ship_unit"] = Ship_unit,
											["Pedro_unit"] = Pedro_unit,
											["Pedro_group"] = Pedro_group,
											-- ["AfterTO"] = 999999
										}								
									if camp and TabPedro[PedroName] then																									-- si ce script est utilisé dans une campagne Mbot
										TabPedro[PedroName]["distance_from_leader"] = camp["pedro"][ShipName].distance_from_leader
										TabPedro[PedroName]["bearing_from_leader_BaseMiss"] = camp["pedro"][ShipName].bearing_from_leader_BaseMiss									
									end									
									-- table.insert(tabBearingTime, m)																			
								else
									-- env.info("Pedro_ non trouve "..PedroName)
								end
								
							end
						end
					end
				end
			end
		end
		if findPedro then
			return true
		end
	end

takeoff = {}
EventPedro = {}
function EventPedro:onEvent(event)
	if event.id == world.event.S_EVENT_SHOT then								--store type of event
		eventType = "shot"
	elseif event.id == world.event.S_EVENT_HIT then
		eventType = "hit"
	elseif event.id == world.event.S_EVENT_TAKEOFF then
		eventType = "takeoff"
		-- env.info("PedroPasse01 event.id takeoff "..tostring(eventType))
	elseif event.id == world.event.S_EVENT_LAND then
		eventType = "land"
	elseif event.id == world.event.S_EVENT_CRASH then
		eventType = "crash"
	elseif event.id == world.event.S_EVENT_EJECTION then
		eventType = "eject"
	elseif event.id == world.event.S_EVENT_REFUELING then
		eventType = "refueling"
	elseif event.id == world.event.S_EVENT_DEAD then
		eventType = "dead"
	elseif event.id == world.event.S_EVENT_PILOT_DEAD then
		eventType = "pilot dead"
	end
	
	if eventType == "takeoff" and event.initiator and event.initiator:getName() then
		if not takeoff then takeoff = {} end
		takeoff[event.initiator:getName()] = true
		-- env.info("PedroPasse02 initiator getName "..tostring(event.initiator:getName()))
		-- trigger.action.outText("PedroPasse02 initiator getName"..tostring(event.initiator:getName()), 1)	--FOR DEBUG
	end
end

	local lockSpeed
	local pdvMEP
	tabBearingTime = {}
	function checkPos(tab)
		-- _affiche(tab, "checkPos tab")
		if tab then
			for PedroName, value in pairs(tab) do
				
				-- env.info("PedroPasse02b inAir? "..PedroName.." "..tostring(value.Pedro_unit:inAir()))
				if value.Pedro_unit:inAir() then
					local current_time = timer.getTime()
					
					local ship_Pos = value.Ship_unit:getPoint()
					local velocity = value.Ship_unit:getVelocity()
					local speed = math.sqrt(velocity.x^2 + velocity.y^2 + velocity.z^2)
					local speed_ini = speed
					
					local pedro_Pos = value.Pedro_unit:getPoint()
					
					local headingCVN = getHeadingByPos(value.Ship_unit)
					headingCVN = rad2Deg(headingCVN)
					
					local tableTemp = {
							["headingCVN"] = headingCVN,
							["current_time"] = current_time
						}
					if not tabBearingTime[value.ShipName] then tabBearingTime[value.ShipName] = {} end
					tabBearingTime[value.ShipName][#tabBearingTime+1] = tableTemp
					
					-- _affiche(takeoff, "Pedro takeoff")
					-- if tab[PedroName]["TakeOff"] or (takeoff[PedroName] and tab[PedroName]["AfterTO"] and timer.getTime() > tab[PedroName]["AfterTO"] ) then
					if tab[PedroName]["TakeOff"] or (takeoff[PedroName] and tab[PedroName]["AfterTO"] and timer.getTime() > tab[PedroName]["AfterTO"] ) then
						-- env.info("Pedro Passe 06 AfterTO "..PedroName.." "..timer.getTime())
						-- env.info("CVN Before speed_ini "..speed_ini)
						
						-- cherche le taux de virage
						if #tabBearingTime[value.ShipName] >= 2 then 
						
							local heading0 = tabBearingTime[value.ShipName][#tabBearingTime-1]["headingCVN"]
							local heading1 = tabBearingTime[value.ShipName][#tabBearingTime]["headingCVN"]
							local time0 = tabBearingTime[value.ShipName][#tabBearingTime-1]["current_time"]
							local time1 = tabBearingTime[value.ShipName][#tabBearingTime]["current_time"]					
							local TxHeading = (heading1 - heading0) / (time1 - time0)
							
							-- Si le Pedro est à l'exterieur du virage, il devra avancer plus vite
							-- le Ship effectue un virage, donc un arc de cercle de rayon R, que l'on cherche
							-- R trouvé, on y ajoute la distance ShipPedro pour calculer la nouvelle vitesse de reference
							--https://warmaths.fr/MATH/geometr/Angles/mesarcangll.htm
							if TxHeading > 0.1 or TxHeading < - 0.1 then
								local distanceSP = math.sqrt(math.pow(ship_Pos.x - pedro_Pos.x, 2) + math.pow(ship_Pos.z - pedro_Pos.z, 2))		--distance between pedro and CVN
								local tempsVi = (time1 - time0)
								if tempsVi == 0 then
									tempsVi = 0.1
								end  
								local rayonShip = (speed_ini * tempsVi * 360 ) / ( 2 * math.pi * TxHeading  )						
								speed_ini = (((2 * math.pi * rayonShip + distanceSP ) / 360) * TxHeading ) /tempsVi					
								speed = speed_ini						
							end
			
							--supprimes les anciennes valeur du tableau pour qu'il n'occupe pas de memoire
							if #tabBearingTime[value.ShipName] >= 20 then 
								for m = 1 , #tabBearingTime[value.ShipName] -4  do
									table.remove(tabBearingTime[value.ShipName], m)	
								end
							end				
						end

						-- calcul du centre du RangePosition de reference du pedro, par rapport au base_mission
						local dx = 0
						local dy = 0
						local bearing_from_leader = value.bearing_from_leader_BaseMiss				--unit bearing from leader (mig Base_mission)
						local heading_CVN = math.deg(getHeadingByPos(value.Ship_unit))


						bearing_from_leader = bearing_from_leader + heading_CVN
						if bearing_from_leader > 360 then 
							bearing_from_leader = bearing_from_leader - 360
						end

						dx = math.cos(math.rad(bearing_from_leader)) * value.distance_from_leader	--x component from leader
						dy = math.sin(math.rad(bearing_from_leader)) * value.distance_from_leader	--y component from leader

						local refCeclePedro = {
							["x"] = ship_Pos.x + dx,
							["y"] = ship_Pos.z + dy,
						}

						local distance = math.sqrt(math.pow(refCeclePedro.x - pedro_Pos.x, 2) + math.pow(refCeclePedro.y - pedro_Pos.z, 2))		--distance between pedro and Centre Cercle de reference position Pedro							
						
						-- trouve dans le cercle le bearing relatif de H par rapport au centre du cercle
						-- si bearing entre -270 et 90, H est en avant du cercle, il suffit de lui demander de ralentir
						
						local	pedro_PosXY = {
								x = pedro_Pos.x,
								y = pedro_Pos.z
							} 
						local HeadingCercleVsHeli = GetHeading2(refCeclePedro, pedro_PosXY)  -- en degre
						
						HeadingCercleVsHeli = math.abs(headingCVN - HeadingCercleVsHeli)				
						
						local speedForwardBack = 0
						if (HeadingCercleVsHeli > 315 and HeadingCercleVsHeli <=360) or (HeadingCercleVsHeli >= 0 and HeadingCercleVsHeli <= 45) then 					-- s'il est devant, on ralenti
							speedForwardBack = -1
						elseif HeadingCercleVsHeli >= 135 and HeadingCercleVsHeli <=225  then 
							speedForwardBack = 1
						else
							speedForwardBack = 0
						end
						
						Ship_vec = value.Ship_unit:getPosition()
						Pedro_vec = value.Pedro_unit:getPosition()
										
						local tolerance_distance_cercle = 10 																-- 10 m autour du point de reference de l'helico Base_Mission
						local resetPosition = false
		
						if  distance >= tolerance_distance_cercle + 2000 then 
							speed = speed * 3 
							resetPosition = true
						elseif  distance >= tolerance_distance_cercle + 1000 and distance < tolerance_distance_cercle + 2000 then 
							speed = speed * 2 
							resetPosition = true						
						elseif  distance >= tolerance_distance_cercle + 500 and distance < tolerance_distance_cercle + 1000 then 
							speed = speed + (20 * speedForwardBack)
							resetPosition = true
						elseif  distance >= tolerance_distance_cercle + 200 and distance < tolerance_distance_cercle + 500 then  
							speed = speed + (10 * speedForwardBack)
							resetPosition = true
						elseif distance >= tolerance_distance_cercle + 100 and distance < tolerance_distance_cercle + 200 then 
							speed = speed + (4 * speedForwardBack)
							resetPosition = true
						elseif distance >= tolerance_distance_cercle + 20 and distance < tolerance_distance_cercle + 100 then 
							speed = speed + (3.8 * speedForwardBack)
							resetPosition = true
						elseif distance >= tolerance_distance_cercle + 10 and distance < tolerance_distance_cercle + 20 then 
							speed = speed + (3.2 * speedForwardBack)
							resetPosition = true
						elseif distance >= tolerance_distance_cercle and distance < tolerance_distance_cercle + 10 then 
							speed = speed + (1.6 * speedForwardBack)
							resetPosition = true
						elseif distance >= tolerance_distance_cercle then
							speed = speed + (0.8 * speedForwardBack)
							resetPosition = true
						end
					
						
						if speed < 0 then speed = 0 end

						if resetPosition then					
							--par rapport au milieu du cercle de reference, on calcul un point en avant
							-- grace à sa vitesse, on le fera avancer plus vite ou pas
							
							local tempPoint2 = {x = ship_Pos.x + dx, y = ship_Pos.z + dy}
							local newWPT2 = GetOffsetPointIM(tempPoint2, headingCVN, 400)
							
							local tempPoint3 = {x = pedro_Pos.x, y = pedro_Pos.z}
							local newWPT3 = GetOffsetPointIM(tempPoint3, headingCVN, 200000)		
							
							local route = {}
							route = {
								[1] = {
									['alt'] = 40,
									['type'] = 'Turning Point',
									['ETA'] = 0,
									['alt_type'] = 'BARO',
									['formation_template'] = '',
									['y'] = pedro_Pos.z ,
									['x'] = pedro_Pos.x ,
									['name'] = '',
									['ETA_locked'] = true,
									['speed'] = speed,
									['action'] = 'Turning Point',
									['task'] = {
										['id'] = 'ComboTask',
										['params'] = {
											['tasks'] = {},
										},
									},
									['speed_locked'] = true,
								},
								[2] = {
									["type"] = "Turning Point",
									["alt"] = 40,
									["alt_type"] = "BARO",
									["formation_template"] = "",
									["y"] = newWPT2.y,
									["x"] = newWPT2.x,
									["name"] = "",
									["ETA_locked"] = false,
									["ETA"] = 0,
									["speed_locked"] = true,
									["speed"] = speed,
									["action"] = "Turning Point",
									["task"] = {
										["id"] = "ComboTask",
										["params"] = {
											["tasks"] = {},
										},
									},
								},
								[3] = {
									['alt'] = 40,
									['type'] = 'Turning Point',
									['ETA'] = 0,
									['alt_type'] = 'BARO',
									['formation_template'] = '',
									['y'] = newWPT3.y ,
									['x'] = newWPT3.x ,
									['name'] = '',
									['ETA_locked'] = false,
									['speed'] = speed_ini,
									['action'] = 'Turning Point',
									['task'] = {
										['id'] = 'ComboTask',
										['params'] = {
											['tasks'] = {},
										},
									},
									['speed_locked'] = true,
								}
							}
							
							local Mission = {
								id = 'Mission',
								params = {
									route = {
										points = route
									}
								}
							}
							
							local ctr = value.Pedro_group:getController()
							Controller.setTask(ctr, Mission)
							-- env.info("PedroPasse04 ZonePedro Controller.setTask "..PedroName)
							-- trigger.action.outText("PedroPasse04 ZonePedro Controller.setTask"..PedroName, 1)	--FOR DEBUG							
							-- _affiche(Mission, "Mission PedroPasse04")
						end
				
					elseif takeoff[PedroName] and not tab[PedroName]["AfterTO"] then
					
						-- etablit un PlanDeVol avec 3 wpt autour du CVN avant de prendre sa place de Pedro
						-- local tempPoint1 = {x = ship_Pos.x, y = ship_Pos.z}
						-- local newWPT1 = GetOffsetPointIM(tempPoint1, headingCVN, 500)
					
						local tempPoint2 = {x = ship_Pos.x , y = ship_Pos.z}
						local newWPT2 = GetOffsetPointIM(tempPoint2, headingCVN - 30, 400)
						
						local tempPoint3 = {x = ship_Pos.x , y = ship_Pos.z}
						local newWPT3 = GetOffsetPointIM(tempPoint3, headingCVN - 80 , 400)
						
						local speed = 40
						
						local route = {}
						route = {
							[1] = {
								['alt'] = 80,
								['type'] = 'Fly Over Point',
								['ETA'] = timer.getTime(),
								['alt_type'] = 'BARO',
								['formation_template'] = '',
								['y'] = pedro_Pos.z ,
								['x'] = pedro_Pos.x ,
								['name'] = '',
								['ETA_locked'] = true,
								['speed'] = speed,
								['action'] = 'Turning Point',
								['task'] = {
									['id'] = 'ComboTask',
									['params'] = {
										['tasks'] = {},
									},
								},
								['speed_locked'] = true,
							},
							[2] = {
								["type"] = "Fly Over Point",
								["alt"] = 60,
								["alt_type"] = "BARO",
								["formation_template"] = "",
								["y"] = newWPT2.y,
								["x"] = newWPT2.x,
								["name"] = "",
								["ETA_locked"] = false,
								["ETA"] = timer.getTime()+15,
								["speed_locked"] = true,
								["speed"] = speed,
								["action"] = "Turning Point",
								["task"] = {
									["id"] = "ComboTask",
									["params"] = {
										["tasks"] = {},
									},
								},
							},
							[3] = {
								['alt'] = 100,
								['type'] = 'Turning Point',
								['ETA'] =timer.getTime()+30,
								['alt_type'] = 'BARO',
								['formation_template'] = '',
								['y'] = newWPT3.y ,
								['x'] = newWPT3.x ,
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
							},
						}
						
						-- calcul la durée du tajet pour bloquer ce plan de vol durant ce vol
						-- ensuite, on pourra assigne un nouveau plan de vol pour allez au point Pedro
						-- MEP : Mise en place
						local timeMEP = 0
						for n = 2, #route do							
							local distanceMEP = math.sqrt(math.pow(route[n-1].x - route[n].x, 2) + math.pow(route[n-1].y - route[n].y, 2))
							timeMEP = timeMEP + (distanceMEP / route[n].speed)						
						end
						if not tab[PedroName]["AfterTO"] then tab[PedroName]["AfterTO"] = 999999 end 
						tab[PedroName]["AfterTO"] = timer.getTime() + timeMEP + 25
						-- env.info("PedroPasse05 timeMEP "..PedroName.." Time: "..timeMEP.." + "..timer.getTime() .." + ".." 25")	
						
						local Mission = {
							id = 'Mission',
							params = {
								route = {
									points = route
								}
							}
						}


						local ctr = value.Pedro_group:getController()
						Controller.setTask(ctr, Mission)
						-- env.info("PedroPasse06 MEP Controller.setTask "..PedroName)							
						-- _affiche(Mission, "Mission")
						-- trigger.action.outText("PedroPasse06 MEP Controller.setTask"..tostring(tab[PedroName]["AfterTO"]), 10)	--FOR DEBUG	
						
						-- takeoff[PedroName]  = nil

					end
				end
			end
		end
		return timer.getTime() + 0.5
	end

	local result = creatTabPedro()
-- env.info("ENV Passe97 "..timer.getTime())	

	for PedroName, value in pairs(TabPedro) do		
		if value.Pedro_unit:inAir() then 
			value["TakeOff"] = true
		end	
	end
	
	
	world.addEventHandler(EventPedro)
-- env.info("ENV Passe98 "..timer.getTime())	
	timer.scheduleFunction(checkPos, TabPedro, timer.getTime() + 1)
-- env.info("ENV Passe99 "..timer.getTime())	


end

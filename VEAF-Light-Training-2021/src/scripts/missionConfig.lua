-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mission configuration file for the VEAF framework
-- see https://github.com/VEAF/VEAF-Mission-Creation-Tools
-------------------------------------------------------------------------------------------------------------------------------------------------------------
veaf.config.MISSION_NAME = "Light-Training"
veaf.config.MISSION_EXPORT_PATH = nil -- use default folder

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- initialize all the scripts
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafRadio then
    -- the RADIO module is mandatory as it is used by many other modules
    veaf.loggers.get(veaf.Id):info("init - veafRadio")
    veafRadio.initialize(true)
end
if veafSpawn then
    -- the SPAWN module is mandatory as it is used by many other modules
    veaf.loggers.get(veaf.Id):info("init - veafSpawn")
    veafSpawn.initialize()
end
if veafGrass then
    veaf.loggers.get(veaf.Id):info("init - veafGrass")
    veafGrass.initialize()
end
if veafCasMission then
    veaf.loggers.get(veaf.Id):info("init - veafCasMission")
    veafCasMission.initialize()
end
if veafTransportMission then
    veaf.loggers.get(veaf.Id):info("init - veafTransportMission")
    veafTransportMission.initialize()
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- change some default parameters
-------------------------------------------------------------------------------------------------------------------------------------------------------------
veaf.DEFAULT_GROUND_SPEED_KPH = 25

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- initialize SHORTCUTS
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafShortcuts then
    -- the SHORTCUTS module is mandatory as it is used by many other modules
    veaf.loggers.get(veaf.Id):info("init - veafShortcuts")
    veafShortcuts.initialize()

    -- you can add all the shortcuts you want here. Shortcuts can be any VEAF command, as entered in a map marker.
    -- here are some examples :

    -- veafShortcuts.AddAlias(
    --     VeafAlias:new()
    --         :setName("-sa11")
    --         :setDescription("SA-11 Gadfly (9K37 Buk) battery")
    --         :setVeafCommand("_spawn group, name sa11")
    --         :setBypassSecurity(true)
    -- )
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure ASSETS
-------------------------------------------------------------------------------------------------------------------------------------------------------------

if veafAssets then
    -- uncomment (and adapt) the following lines to enable the ASSETS module, its commands and its radio menu
    --[[
    veaf.loggers.get(veaf.Id):info("Loading configuration")
    veafAssets.Assets = {
		-- list the assets in the mission below
		-- {sort=1, name="CSG-01 Tarawa", description="Tarawa (LHA)", information="Tacan 11X TAA\nU226 (11)"},  
		-- {sort=2, name="CSG-74 Stennis", description="Stennis (CVN)", information="Tacan 10X STS\nICLS 10\nU225 (10)"},  
		-- {sort=2, name="CSG-71 Roosevelt", description="Roosevelt (CVN)", information="Tacan 12X RHR\nICLS 11\nU227 (12)"},  
		-- {sort=3, name="T1-Arco-1", description="Arco-1 (KC-135)", information="Tacan 64Y\nU290.50 (20)\nZone OUEST", linked="T1-Arco-1 escort"}, 
		-- {sort=4, name="T2-Shell-1", description="Shell-1 (KC-135 MPRS)", information="Tacan 62Y\nU290.30 (18)\nZone EST", linked="T2-Shell-1 escort"},  
		-- {sort=5, name="T3-Texaco-1", description="Texaco-1 (KC-135 MPRS)", information="Tacan 60Y\nU290.10 (17)\nZone OUEST", linked="T3-Texaco-1 escort"},  
		-- {sort=6, name="T4-Shell-2", description="Shell-2 (KC-135)", information="Tacan 63Y\nU290.40 (19)\nZone EST", linked="T4-Shell-2 escort"},  
		-- {sort=6, name="T5-Petrolsky", description="900 (IL-78M, RED)", information="U267", linked="T5-Petrolsky escort"},  
		-- {sort=7, name="CVN-74 Stennis S3B-Tanker", description="Texaco-7 (S3-B)", information="Tacan 75X\nU290.90\nZone PA"},  
		-- {sort=7, name="CVN-71 Roosevelt S3B-Tanker", description="Texaco-8 (S3-B)", information="Tacan 76X\nU290.80\nZone PA"},  
		-- {sort=8, name="Bizmuth", description="Colt-1 AFAC Bizmuth (MQ-9)", information="L1688 V118.80 (18)", jtac=1688, freq=118.80, mod="am"},
		-- {sort=9, name="Agate", description="Dodge-1 AFAC Agate (MQ-9)", information="L1687 V118.90 (19)", jtac=1687, freq=118.90, mod="am"},  
		-- {sort=10, name="A1-Magic", description="Magic (E-2D)", information="Datalink 315.3 Mhz\nU282.20 (13)", linked="A1-Magic escort"},  
		-- {sort=11, name="A2-Overlordsky", description="Overlordsky (A-50, RED)", information="V112.12"},  
    }

    veaf.loggers.get(veaf.Id):info("init - veafAssets")
    veafAssets.initialize()
    ]]
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure MOVE
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafMove then
    veaf.loggers.get(veaf.Id):info("Setting move tanker radio menus")
    -- keeping the veafMove.Tankers table empty will force veafMove.initialize() to browse the units, and find the tankers automatically
    veaf.loggers.get(veaf.Id):info("init - veafMove")
    veafMove.initialize()
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure COMBAT MISSION
-------------------------------------------------------------------------------------------------------------------------------------------------------------

if veafCombatMission then 
    -- uncomment (and adapt) the following lines to enable the COMBAT MISSION module (air to air fights), its commands and its radio menu
    --[[
    veaf.loggers.get(veaf.Id):info("Loading configuration")

    veaf.loggers.get(veaf.Id):info("init - veafCombatMission")
    veafCombatMission.initialize()
    ]]
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure COMBAT ZONE
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafCombatZone then 
    veaf.loggers.get(veaf.Id):info("Loading configuration")

	veafCombatZone.AddZone(
		VeafCombatZone:new()
			:setMissionEditorZoneName("Training zone EASY-0")
			:setFriendlyName("Training zone EASY-0")
			:setBriefing("A defenseless transport company is ready to be destroyed !")
			:setTraining(true)
			
	)
	:activate()

    veafCombatZone.AddZone(
		VeafCombatZone:new()
			:setMissionEditorZoneName("Training zone EASY-1")
			:setFriendlyName("Training zone EASY-1")
			:setBriefing("Training zone EASY-1")
			:setTraining(true)
			
	)
	--:activate()

    veafCombatZone.AddZone(
		VeafCombatZone:new()
			:setMissionEditorZoneName("Training zone MEDIUM-2")
			:setFriendlyName("Training zone MEDIUM-2")
			:setBriefing("Training zone MEDIUM-2")
			:setTraining(true)
			
	)
	--:activate()

    veafCombatZone.AddZone(
		VeafCombatZone:new()
			:setMissionEditorZoneName("Training zone MEDIUM-3")
			:setFriendlyName("Training zone MEDIUM-3")
			:setBriefing("Training zone MEDIUM-3")
			:setTraining(true)
			
	)
	--:activate()

	veafCombatZone.AddZone(
		VeafCombatZone:new()
			:setMissionEditorZoneName("Training zone HARD-4")
			:setFriendlyName("Training zone HARD-4")
			:setBriefing("Training zone HARD-4")
			:setTraining(true)
			
	)
	--:activate()

	veafCombatZone.AddZone(
		VeafCombatZone:new()
			:setMissionEditorZoneName("Training zone HARD-5")
			:setFriendlyName("Training zone HARD-5")
			:setBriefing("Training zone HARD-5")
			:setTraining(true)
			
	)
	--:activate()

	veafCombatZone.AddZone(
		VeafCombatZone:new()
			:setMissionEditorZoneName("CombatZone_MountainHike")
			:setFriendlyName("Mountain hike")
            :setCompletable(false)
            :setTraining(true)
			:setBriefing("A friendly Mi-8MTV2 has crashed in the mountains, near the russian border, 45nm north-east of Sukhumi.\n" ..
                        "You can takeoff from the Kodori FARP or grass runway, follow the valley to the northeast until you pass the border and locate the crash site\n" ..
                        "There are beacons in the mountains to guide you : \n" ..
                        " - MH01 on 31.00 FM\n" ..
                        " - MH02 on 32.00 FM\n" ..
                        " - MH03 on 33.00 FM\n" ..
                        "The crashed helicopter's crew transmits on their pocket radio : SOS on 34.00 FM")
    )

    veaf.loggers.get(veaf.Id):info("init - veafCombatZone")
    veafCombatZone.initialize()

end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure WW2 settings based on loaded theatre
-------------------------------------------------------------------------------------------------------------------------------------------------------------
local theatre = string.lower(env.mission.theatre)
veaf.loggers.get(veaf.Id):info(string.format("theatre is %s", theatre))
veaf.config.ww2 = false
if theatre == "thechannel" then
    veaf.config.ww2 = true
elseif theatre == "normandy" then
    veaf.config.ww2 = true
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure NAMEDPOINTS
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafNamedPoints then
    -- the NAMED POINTS module is mandatory as it is used by many other modules

    veaf.loggers.get(veaf.Id):info("Loading configuration")

    
    -- here you can add points of interest, that will be added to the default points
    local customPoints = {
    --     {name="RANGE KhalKhalah",point=coord.LLtoLO("33.036180", "37.196608")},
    }
    veaf.loggers.get(veaf.Id):info("init - veafNamedPoints")
    veafNamedPoints.initialize(customPoints)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure SECURITY
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafSecurity then
    -- the SECURITY module is mandatory as it is used by many other modules

    --let's not set a password
    veaf.SecurityDisabled = true
    --veafSecurity.password_L9["SHA1 hash of the password"] = true -- set the L9 password (the lowest possible security)
    veaf.loggers.get(veaf.Id):info("Loading configuration")
    veaf.loggers.get(veaf.Id):info("init - veafSecurity")
    veafSecurity.initialize()

    -- force security in order to test it when dynamic loading is in place (change to TRUE)
    if (false) then
        veaf.SecurityDisabled = false
        veafSecurity.authenticated = false
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure CARRIER OPERATIONS
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafCarrierOperations then
    veaf.loggers.get(veaf.Id):info("init - veafCarrierOperations")
    veafCarrierOperations.initialize(true)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure CTLD
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if ctld then
    veaf.loggers.get(veaf.Id):info("init - ctld")
    function configurationCallback()
        veaf.loggers.get(veaf.Id):info("configuring CTLD for %s", veaf.config.MISSION_NAME)
      end
    ctld.initialize(configurationCallback)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure CSAR
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if csar then
    veaf.loggers.get(veaf.Id):info("init - csar")
    function configurationCallback()
        veaf.loggers.get(veaf.Id):info("configuring CSAR for %s", veaf.config.MISSION_NAME)
    end
    csar.initialize(configurationCallback)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- initialize the remote interface
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafRemote then
    veaf.loggers.get(veaf.Id):info("init - veafRemote")
    veafRemote.initialize()
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- initialize Skynet-IADS
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafSkynet then
    veaf.loggers.get(veaf.Id):info("init - veafSkynet")
    veafSkynet.initialize(
        false, --includeRedInRadio=true
        false, --debugRed
        false, --includeBlueInRadio
        false --debugBlue
    )
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- initialize the interpreter
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafInterpreter then
    -- the INTERPRETER module is mandatory as it is used by many other modules
    veaf.loggers.get(veaf.Id):info("init - veafInterpreter")
    veafInterpreter.initialize()
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- initialize veafSanctuary
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafSanctuary then
    -- uncomment (and adapt) the following lines to enable the SANCTUARY module, its commands and its radio menu
    --[[
    veaf.loggers.get(veaf.Id):info("init - veafSanctuary")
    veafSanctuary.initialize()
    ]]
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- initialize Hound Elint
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafHoundElint then
    -- uncomment (and adapt) the following lines to enable Hound Elint
    --[[
    veaf.loggers.get(veaf.Id):info("init - veafHoundElint")
    veafHoundElint.initialize(
        "ELINT", -- prefix
        { -- red
            --global parameters
            sectors = {},
            markers = true,
            disableBDA = false, --disables notifications that a radar has dropped off scope
            platformPositionErrors = true,
            NATOmessages = false, --provides positions relative to the bullseye
            NATO_SectorCallsigns = false, --uses a different pool for sector callsigns
            ATISinterval = 180,
            preBriefedContacts = {
                --"Stuff",
                --"Thing",
            }, --contains the name of units placed in the ME which will be designated as pre-briefed (exact location) and who's position will be indicated exactly by Hound until the unit moved 100m away
            debug = false, --set this to true to make sure your configuration is correct and working as intended
        },
        { -- blue
            sectors = {
                --Global sector, mandatory inclusion if you want a global ATIS/controller etc., encompasses the whole map so it'll be very crowded in terms of comms
                [veafHoundElint.globalSectorName] = {
                    callsign = "Global Sector", --defines a specific callsign for the sector which will be used by the ATIS etc., if absent or nil Hound will assign it a callsign automatically, NATO format of regular Hound format. If true, callsign will be equal to the sector name
                    atis = {
                        freq = 282.175,
                        speed = 1,
                        --additional params
                        reportEWR = false
                    },
                    controller = {
                        freq = 282.225,
                        --additional params
                        voiceEnabled = true
                    },
                    notifier = {
                        freq = 282.2,
                        --additional params
                    },
                    disableAlerts = false, --disables alerts on the ATIS/Controller when a new radar is detected or destroyed
                    transmitterUnit = nil, --use the Unit/Pilot name to set who the transmitter is for the ATIS etc. This can be a static, and aircraft or a vehicule/ship
                    disableTTS = false,
                },
                --sector named "Maykop", will be geofenced to the mission editor polygon drawing (free or rectangle) called "Maykop" (case sensitive)
                ["Maykop"] = {
                    callsign = true, --defines a specific callsign for the sector which will be used by the ATIS etc., if absent or nil Hound will assign it a callsign automatically, NATO format of regular Hound format. If true, callsign will be equal to the sector name
                    atis = {
                        freq = 281.075,
                        speed = 1,
                        --additional params
                        reportEWR = false
                    },
                    controller = {
                        freq = 281.125,
                        --additional params
                        voiceEnabled = true
                    },
                    notifier = {
                        freq = 281.1,
                        --additional params
                    },
                    disableAlerts = false, --disables alerts on the ATIS/Controller when a new radar is detected or destroyed
                    transmitterUnit = nil, --use the Unit/Pilot name to set who the transmitter is for the ATIS etc. This can be a static, and aircraft or a vehicule/ship
                    disableTTS = false,
                },
            },
            --global parameters
            markers = true,
            disableBDA = false, --disables notifications that a radar has dropped off scope
            platformPositionErrors = true,
            NATOmessages= true, --provides positions relative to the bullseye
            NATO_SectorCallsigns = true, --uses a different pool for sector callsigns
            ATISinterval = 180,
            preBriefedContacts = {
                --"Stuff",
                --"Thing",
            }, --contains the name of units or groups placed in the ME which will be designated as pre-briefed (exact location) and who's position will be indicated exactly by Hound until the unit moved 100m away. If multiple radars are within a specified group, they'll all be added as pre-briefed targets
            debug = false, --set this to true to make sure your configuration is correct and working as intended
        }
        -- args = {
        --     freq = 250.000,
        --     modulation = "AM",
        --     volume = "1.0",
        --     speed = <speed> -- number default is 0/1 for controller/atis. range is -10 to +10 on windows TTS. for google it's 0.25 to 4.0
        --     gender = "male"|"female",
        --     culture = "en-US"|"en-UK" -- (any installed on your system)
        --     isGoogle = true/false -- use google TTS (requires additional STTS config)
        --     voiceEnabled = true/false (for the controller only) -- to set if the controllers uses text or TTS
        --     reportEWR = true/false (for ATIS only) -- set to tell the ATIS to report EWRs as threats
        -- }
    )
    ]]
end

-- Silence ATC on all the airdromes
veaf.silenceAtcOnAllAirbases()

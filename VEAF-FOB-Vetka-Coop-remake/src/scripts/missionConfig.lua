-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mission configuration file for the VEAF framework
-- see https://github.com/VEAF/VEAF-Mission-Creation-Tools
-------------------------------------------------------------------------------------------------------------------------------------------------------------
veaf.config.MISSION_NAME = "FOB-Vetka-Coop-remake"
veaf.config.MISSION_EXPORT_PATH = nil -- use default folder

-- play the radio beacons (for the public OT mission)
veafBeacons = false


-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- initialize all the scripts
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafRadio then
    veaf.logInfo("init - veafRadio")
    veafRadio.initialize(true)
end
if veafSpawn then
    veaf.logInfo("init - veafSpawn")
    veafSpawn.initialize()
end
if veafGrass then
    veaf.logInfo("init - veafGrass")
    veafGrass.initialize()
end
if veafCasMission then
    veaf.logInfo("init - veafCasMission")
    veafCasMission.initialize()
end
if veafTransportMission then
    veaf.logInfo("init - veafTransportMission")
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
    veaf.logInfo("init - veafShortcuts")
    veafShortcuts.initialize()

    -- you can add all the shortcuts you want here. Shortcuts can be any VEAF command, as entered in a map marker.
    -- here are some examples :

    -- veafShortcuts.AddAlias(
    --     VeafAlias.new()
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
    veafAssets.logInfo("Loading configuration")
    veafAssets.Assets = {
		-- list the assets in the mission below
        --[[
		{sort=1, name="CSG-01 Tarawa", description="Tarawa (LHA)", information="Tacan 11X TAA\nU226 (11)"},  
		{sort=2, name="CSG-74 Stennis", description="Stennis (CVN)", information="Tacan 10X STS\nICLS 10\nU225 (10)"},  
		{sort=2, name="CSG-71 Roosevelt", description="Roosevelt (CVN)", information="Tacan 12X RHR\nICLS 11\nU227 (12)"},  
		{sort=3, name="T1-Arco-1", description="Arco-1 (KC-135)", information="Tacan 64Y\nU290.50 (20)\nZone OUEST", linked="T1-Arco-1 escort"}, 
		{sort=4, name="T2-Shell-1", description="Shell-1 (KC-135 MPRS)", information="Tacan 62Y\nU290.30 (18)\nZone EST", linked="T2-Shell-1 escort"},  
		{sort=5, name="T3-Texaco-1", description="Texaco-1 (KC-135 MPRS)", information="Tacan 60Y\nU290.10 (17)\nZone OUEST", linked="T3-Texaco-1 escort"},  
		{sort=6, name="T4-Shell-2", description="Shell-2 (KC-135)", information="Tacan 63Y\nU290.40 (19)\nZone EST", linked="T4-Shell-2 escort"},  
		{sort=6, name="T5-Petrolsky", description="900 (IL-78M, RED)", information="U267", linked="T5-Petrolsky escort"},  
		{sort=7, name="CVN-74 Stennis S3B-Tanker", description="Texaco-7 (S3-B)", information="Tacan 75X\nU290.90\nZone PA"},  
		{sort=7, name="CVN-71 Roosevelt S3B-Tanker", description="Texaco-8 (S3-B)", information="Tacan 76X\nU290.80\nZone PA"},  
		{sort=8, name="Bizmuth", description="Colt-1 AFAC Bizmuth (MQ-9)", information="L1688 V118.80 (18)", jtac=1688, freq=118.80, mod="am"},
		{sort=9, name="Agate", description="Dodge-1 AFAC Agate (MQ-9)", information="L1687 V118.90 (19)", jtac=1687, freq=118.90, mod="am"},  
		{sort=10, name="A1-Magic", description="Magic (E-2D)", information="Datalink 315.3 Mhz\nU282.20 (13)", linked="A1-Magic escort"},  
		{sort=11, name="A2-Overlordsky", description="Overlordsky (A-50, RED)", information="V112.12"},  
        ]]
    }

    veaf.logInfo("init - veafAssets")
    veafAssets.initialize()
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure MOVE
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafMove then
    veafMove.logInfo("Setting move tanker radio menus")
    -- keeping the veafMove.Tankers table empty will force veafMove.initialize() to browse the units, and find the tankers
    veaf.logInfo("init - veafMove")
    veafMove.initialize()
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure COMBAT MISSION
-------------------------------------------------------------------------------------------------------------------------------------------------------------

if veafCombatMission then 
	veafCombatMission.logInfo("Loading configuration")

	veaf.logInfo("init - veafCombatMission")
    veafCombatMission.initialize()
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure COMBAT ZONE
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafCombatZone then 
	veafCombatZone.logInfo("Loading configuration")

    veaf.logInfo("init - veafCombatZone")
    veafCombatZone.initialize()

end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure WW2 settings based on loaded theatre
-------------------------------------------------------------------------------------------------------------------------------------------------------------
local theatre = string.lower(env.mission.theatre)
veafNamedPoints.logInfo(string.format("theatre is %s", theatre))
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

	veafNamedPoints.Points = {
		-- airbases in Georgia
		{name="AIRBASE Batumi",  point={x=-356437,y=0,z=618211, atc=true, tower="V131, U260", tacan="16X BTM", runways={{name="13", hdg=125, ils="110.30"}, {name="31", hdg=305}}}},
		{name="AIRBASE Gudauta", point={x=-196850,y=0,z=516496, atc=true, tower="V130, U259", runways={ {name="15", hdg=150}, {name="33", hdg=330}}}},
		{name="AIRBASE Kobuleti",point={x=-318000,y=0,z=636620, atc=true, tower="V133, U262", tacan="67X KBL", runways={ {name="07", hdg=69, ils="111.50"}}}},
		{name="AIRBASE Kutaisi", point={x=-284860,y=0,z=683839, atc=true, tower="V134, U264", tacan="44X KTS", runways={ {name="08", hdg=74, ils="109.75"}, {name="26", hdg=254}}}},
		{name="AIRBASE Senaki",  point={x=-281903,y=0,z=648379, atc=true, tower="V132, U261", tacan="31X TSK", runways={ {name="09", hdg=94, ils="108.90"}, {name="27", hdg=274}}}},
		{name="AIRBASE Sukhumi", point={x=-221382,y=0,z=565909, atc=true, tower="V129, U258", runways={{name="12", hdg=116}, {name="30", hdg=296}}}},
		{name="AIRBASE Tbilisi", point={x=-314926,y=0,z=895724, atc=true, tower="V138, U267", tacan="25X GTB", runways={{name="13", hdg=127, ils="110.30"},{name="31", hdg=307, ils="108.90"}}}},
		{name="AIRBASE Vaziani", point={x=-319000,y=0,z=903271, atc=true, tower="V140, U269", tacan="22X VAS", runways={ {name="13", hdg=135, ils="108.75"}, {name="31", hdg=315, ils="108.75"}}}},
		-- airbases in Russia
		{name="AIRBASE Anapa - Vityazevo",   point={x=-004448,y=0,z=244022, atc=true, tower="V121, U250" , runways={ {name="22", hdg=220}, {name="04", hdg=40}}}},
		{name="AIRBASE Beslan",              point={x=-148472,y=0,z=842252, atc=true, tower="V141, U270", runways={ {name="10", hdg=93, ils="110.50"}, {name="28", hdg=273}}}},
		{name="AIRBASE Krymsk",              point={x=-007349,y=0,z=293712, atc=true, tower="V124, U253", runways={ {name="04", hdg=39}, {name="22", hdg=219}}}},
		{name="AIRBASE Krasnodar-Pashkovsky",point={x=-008707,y=0,z=388986, atc=true, tower="V128, U257", runways={ {name="23", hdg=227}, {name="05", hdg=47}}}},
		{name="AIRBASE Krasnodar-Center",    point={x=-011653,y=0,z=366766, atc=true, tower="V122, U251", runways={ {name="09", hdg=86}, {name="27", hdg=266}}}},
		{name="AIRBASE Gelendzhik",          point={x=-050996,y=0,z=297849, atc=true, tower="V126, U255", runways={ {hdg=40}, {hdg=220}}}},
		{name="AIRBASE Maykop",              point={x=-027626,y=0,z=457048, atc=true, tower="V125, U254", runways={ {name="04", hdg=40}, {name="22", hdg=220}}}},
		{name="AIRBASE Mineralnye Vody",     point={x=-052090,y=0,z=707418, atc=true, tower="V135, U264", runways={ {name="12", hdg=115, ils="111.70"}, {name="30", hdg=295, ils="109.30"}}}},
		{name="AIRBASE Mozdok",              point={x=-083330,y=0,z=835635, atc=true, tower="V137, U266", runways={ {name="08", hdg=82}, {name="26", hdg=262}}}},
		{name="AIRBASE Nalchik",             point={x=-125500,y=0,z=759543, atc=true, tower="V136, U265", runways={ {name="06", hdg=55}, {name="24", hdg=235, ils="110.50"}}}},
		{name="AIRBASE Novorossiysk",        point={x=-040299,y=0,z=279854, atc=true, tower="V123, U252", runways={ {name="04", hdg=40}, {name="22", hdg=220}}}},
		{name="AIRBASE Sochi",               point={x=-165163,y=0,z=460902, atc=true, tower="V127, U256", runways={ {name="06", hdg=62, ils="111.10"}, {name="24", hdg=242}}}},
	}

    veafNamedPoints.logInfo("Loading configuration")

    veafNamedPoints.logInfo("init - veafNamedPoints")
    veafNamedPoints.initialize()
    if theatre == "syria" then
        veafNamedPoints.addAllSyriaCities()
    elseif theatre == "caucasus" then
        veafNamedPoints.addAllCaucasusCities()
    elseif theatre == "persiangulf" then
        veafNamedPoints.addAllPersianGulfCities()
    elseif theatre == "thechannel" then
        veafNamedPoints.addAllTheChannelCities()
    else
        veafNamedPoints.logWarning(string.format("theatre %s is not yet supported by veafNamedPoints", theatre))
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure SECURITY
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafSecurity then
    --let's not set a password
    --veafSecurity.password_L9["6ade6629f9219d87a011e7b8fbf8ef9584f2786d"] = true -- set the L9 password (the lowest possible security)
    veafSecurity.logInfo("Loading configuration")
    veaf.logInfo("init - veafSecurity")
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
    veaf.logInfo("init - veafCarrierOperations")
    veafCarrierOperations.initialize(true)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure CTLD 
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if ctld then
    ctld.staticBugWorkaround = false --  DCS had a bug where destroying statics would cause a crash. If this happens again, set this to TRUE

    ctld.disableAllSmoke = false -- if true, all smoke is diabled at pickup and drop off zones regardless of settings below. Leave false to respect settings below

    ctld.hoverPickup = true --  if set to false you can load crates with the F10 menu instead of hovering... Only if not using real crates!

    ctld.enableCrates = true -- if false, Helis will not be able to spawn or unpack crates so will be normal CTTS
    ctld.slingLoad = false -- if false, crates can be used WITHOUT slingloading, by hovering above the crate, simulating slingloading but not the weight...
    -- There are some bug with Sling-loading that can cause crashes, if these occur set slingLoad to false
    -- to use the other method.
    -- Set staticBugFix  to FALSE if use set ctld.slingLoad to TRUE

    ctld.enableSmokeDrop = true -- if false, helis and c-130 will not be able to drop smoke

    ctld.maxExtractDistance = 125 -- max distance from vehicle to troops to allow a group extraction
    ctld.maximumDistanceLogistic = 500 -- max distance from vehicle to logistics to allow a loading or spawning operation
    ctld.maximumSearchDistance = 8000 -- max distance for troops to search for enemy
    ctld.maximumMoveDistance = 2000 -- max distance for troops to move from drop point if no enemy is nearby

    ctld.minimumDeployDistance = 1000 -- minimum distance from a friendly pickup zone where you can deploy a crate

    ctld.numberOfTroops = 10 -- default number of troops to load on a transport heli or C-130 
                                -- also works as maximum size of group that'll fit into a helicopter unless overridden
    ctld.enableFastRopeInsertion = true -- allows you to drop troops by fast rope
    ctld.fastRopeMaximumHeight = 18.28 -- in meters which is 60 ft max fast rope (not rappell) safe height

    ctld.vehiclesForTransportRED = { "BRDM-2", "BTR_D" } -- vehicles to load onto Il-76 - Alternatives {"Strela-1 9P31","BMP-1"}
    ctld.vehiclesForTransportBLUE = { "M1045 HMMWV TOW", "M1043 HMMWV Armament" } -- vehicles to load onto c130 - Alternatives {"M1128 Stryker MGS","M1097 Avenger"}

    ctld.aaLaunchers = 3 -- controls how many launchers to add to the kub/buk when its spawned.
    ctld.hawkLaunchers = 5 -- controls how many launchers to add to the hawk when its spawned.

    ctld.spawnRPGWithCoalition = true --spawns a friendly RPG unit with Coalition forces
    ctld.spawnStinger = false -- spawns a stinger / igla soldier with a group of 6 or more soldiers!

    ctld.enabledFOBBuilding = true -- if true, you can load a crate INTO a C-130 than when unpacked creates a Forward Operating Base (FOB) which is a new place to spawn (crates) and carry crates from
    -- In future i'd like it to be a FARP but so far that seems impossible...
    -- You can also enable troop Pickup at FOBS

    ctld.cratesRequiredForFOB = 1 -- The amount of crates required to build a FOB. Once built, helis can spawn crates at this outpost to be carried and deployed in another area.
    -- The large crates can only be loaded and dropped by large aircraft, like the C-130 and listed in ctld.vehicleTransportEnabled
    -- Small FOB crates can be moved by helicopter. The FOB will require ctld.cratesRequiredForFOB larges crates and small crates are 1/3 of a large fob crate
    -- To build the FOB entirely out of small crates you will need ctld.cratesRequiredForFOB * 3

    ctld.troopPickupAtFOB = true -- if true, troops can also be picked up at a created FOB

    ctld.buildTimeFOB = 120 --time in seconds for the FOB to be built

    ctld.crateWaitTime = 120 -- time in seconds to wait before you can spawn another crate

    ctld.forceCrateToBeMoved = true -- a crate must be picked up at least once and moved before it can be unpacked. Helps to reduce crate spam

    ctld.radioSound = "beacon.ogg" -- the name of the sound file to use for the FOB radio beacons. If this isnt added to the mission BEACONS WONT WORK!
    ctld.radioSoundFC3 = "beaconsilent.ogg" -- name of the second silent radio file, used so FC3 aircraft dont hear ALL the beacon noises... :)

    ctld.deployedBeaconBattery = 30 -- the battery on deployed beacons will last for this number minutes before needing to be re-deployed

    ctld.enabledRadioBeaconDrop = true -- if its set to false then beacons cannot be dropped by units

    ctld.allowRandomAiTeamPickups = false -- Allows the AI to randomize the loading of infantry teams (specified below) at pickup zones

    ctld.allowAiTeamPickups = false -- Allows the AI to automatically load infantry teams (specified below) at pickup zones

    -- Simulated Sling load configuration

    ctld.minimumHoverHeight = 7.5 -- Lowest allowable height for crate hover
    ctld.maximumHoverHeight = 12.0 -- Highest allowable height for crate hover
    ctld.maxDistanceFromCrate = 5.5 -- Maximum distance from from crate for hover
    ctld.hoverTime = 10 -- Time to hold hover above a crate for loading in seconds

    -- end of Simulated Sling load configuration

    -- AA SYSTEM CONFIG --
    -- Sets a limit on the number of active AA systems that can be built for RED.
    -- A system is counted as Active if its fully functional and has all parts
    -- If a system is partially destroyed, it no longer counts towards the total
    -- When this limit is hit, a player will still be able to get crates for an AA system, just unable
    -- to unpack them

    ctld.AASystemLimitRED = 20 -- Red side limit

    ctld.AASystemLimitBLUE = 20 -- Blue side limit

    --END AA SYSTEM CONFIG --

    -- ***************** JTAC CONFIGURATION *****************

    ctld.JTAC_LIMIT_RED = 10 -- max number of JTAC Crates for the RED Side
    ctld.JTAC_LIMIT_BLUE = 10 -- max number of JTAC Crates for the BLUE Side

    ctld.JTAC_dropEnabled = true -- allow JTAC Crate spawn from F10 menu

    ctld.JTAC_maxDistance = 10000 -- How far a JTAC can "see" in meters (with Line of Sight)

    ctld.JTAC_smokeOn_RED = true -- enables marking of target with smoke for RED forces
    ctld.JTAC_smokeOn_BLUE = true -- enables marking of target with smoke for BLUE forces

    ctld.JTAC_smokeColour_RED = 4 -- RED side smoke colour -- Green = 0 , Red = 1, White = 2, Orange = 3, Blue = 4
    ctld.JTAC_smokeColour_BLUE = 1 -- BLUE side smoke colour -- Green = 0 , Red = 1, White = 2, Orange = 3, Blue = 4

    ctld.JTAC_jtacStatusF10 = true -- enables F10 JTAC Status menu

    ctld.JTAC_location = true -- shows location of target in JTAC message

    ctld.JTAC_lock = "all" -- "vehicle" OR "troop" OR "all" forces JTAC to only lock vehicles or troops or all ground units

    -- ***************** Pickup, dropoff and waypoint zones *****************

    -- Available colors (anything else like "none" disables smoke): "green", "red", "white", "orange", "blue", "none",

    -- Use any of the predefined names or set your own ones

    -- You can add number as a third option to limit the number of soldier or vehicle groups that can be loaded from a zone.
    -- Dropping back a group at a limited zone will add one more to the limit

    -- If a zone isn't ACTIVE then you can't pickup from that zone until the zone is activated by ctld.activatePickupZone
    -- using the Mission editor

    -- You can pickup from a SHIP by adding the SHIP UNIT NAME instead of a zone name

    -- Side - Controls which side can load/unload troops at the zone

    -- Flag Number - Optional last field. If set the current number of groups remaining can be obtained from the flag value

    --pickupZones = { "Zone name or Ship Unit Name", "smoke color", "limit (-1 unlimited)", "ACTIVE (yes/no)", "side (0 = Both sides / 1 = Red / 2 = Blue )", flag number (optional) }
    ctld.pickupZones = {
        { "pickzone1", "none", -1, "yes", 0 },
        { "pickzone2", "none", -1, "yes", 0 },
        { "pickzone3", "none", -1, "yes", 0 },
        { "pickzone4", "none", -1, "yes", 0 },
        { "pickzone5", "none", -1, "yes", 0 },
        { "pickzone6", "none", -1, "yes", 0 },
        { "pickzone7", "none", -1, "yes", 0 },
        { "pickzone8", "none", -1, "yes", 0 },
        { "pickzone9", "none", -1, "yes", 0 }, 
        { "pickzone10", "none", -1, "yes", 0 },
        { "pickzone11", "none", -1, "yes", 0 }, 
        { "pickzone12", "none", -1, "yes", 0 }, 
        { "pickzone13", "none", -1, "yes", 0 }, 
        { "pickzone14", "none", -1, "yes", 0 },
        { "pickzone15", "none", -1, "yes", 0 },
        { "pickzone16", "none", -1, "yes", 0 },
        { "pickzone17", "none", -1, "yes", 0 },
        { "pickzone18", "none", -1, "yes", 0 },
        { "pickzone19", "none", 5, "yes", 0 },
        { "pickzone20", "none", 10, "yes", 0, 1000 }, -- optional extra flag number to store the current number of groups available in

        { "CVN-74 Stennis", "none", 10, "yes", 0, 1001 }, -- instead of a Zone Name you can also use the UNIT NAME of a ship
        { "LHA-1 Tarawa", "none", 10, "yes", 0, 1002 }, -- instead of a Zone Name you can also use the UNIT NAME of a ship
    }

    -- dropOffZones = {"name","smoke colour",0,side 1 = Red or 2 = Blue or 0 = Both sides}
    ctld.dropOffZones = {
        { "dropzone1", "green", 2 },
        { "dropzone2", "blue", 2 },
        { "dropzone3", "orange", 2 },
        { "dropzone4", "none", 2 },
        { "dropzone5", "none", 1 },
        { "dropzone6", "none", 1 },
        { "dropzone7", "none", 1 },
        { "dropzone8", "none", 1 },
        { "dropzone9", "none", 1 },
        { "dropzone10", "none", 1 },
    }


    --wpZones = { "Zone name", "smoke color",  "ACTIVE (yes/no)", "side (0 = Both sides / 1 = Red / 2 = Blue )", }
    ctld.wpZones = {
        { "wpzone1", "green","yes", 2 },
        { "wpzone2", "blue","yes", 2 },
        { "wpzone3", "orange","yes", 2 },
        { "wpzone4", "none","yes", 2 },
        { "wpzone5", "none","yes", 2 },
        { "wpzone6", "none","yes", 1 },
        { "wpzone7", "none","yes", 1 },
        { "wpzone8", "none","yes", 1 },
        { "wpzone9", "none","yes", 1 },
        { "wpzone10", "none","no", 0 }, -- Both sides as its set to 0
    }


    -- ******************** Transports names **********************

    -- Use any of the predefined names or set your own ones
    ctld.transportPilotNames = {

        "yak #001",
        "yak #002",
        "yak #003",
        "yak #004",
        "yak #005",
        "yak #006",
        "yak #007",
        "yak #008",
        "yak #009",
        "yak #010",
        "yak #011",
        "yak #012",
        "yak #013",
        "yak #014",
        "yak #015",
        "yak #016",
        "yak #017",
        "yak #018",
        "yak #019",
        "yak #020",
        "yak #021",
        "yak #022",
        "yak #023",
        "yak #024",
        "yak #025",
        "transport #001",
        "transport #002",
        "transport #003",
        "transport #004",
        "transport #005",
        "transport #006",
        "transport #007",
        "transport #008",
        "transport #009",
        "transport #010",
        "transport #011",
        "transport #012",
        "transport #013",
        "transport #014",
        "transport #015",
        "transport #016",
        "transport #017",
        "transport #018",
        "transport #019",
        "transport #020",
        "transport #021",
        "transport #022",
        "transport #023",
        "transport #024",
        "transport #025",
        "transport #026",
        "transport #027",
        "transport #028",
        "transport #029",
    }

    -- *************** Optional Extractable GROUPS *****************

    -- Use any of the predefined names or set your own ones

    ctld.extractableGroups = {
        "extract #001",
        "extract #002",
        "extract #003",
        "extract #004",
        "extract #005",
        "extract #006",
        "extract #007",
        "extract #008",
        "extract #009",
        "extract #010",
        "extract #011",
        "extract #012",
        "extract #013",
        "extract #014",
        "extract #015",
        "extract #016",
        "extract #017",
        "extract #018",
        "extract #019",
        "extract #020",
        "extract #021",
        "extract #022",
        "extract #023",
        "extract #024",
        "extract #025",
    }

    -- ************** Logistics UNITS FOR CRATE SPAWNING ******************

    -- Use any of the predefined names or set your own ones
    -- When a logistic unit is destroyed, you will no longer be able to spawn crates

    ctld.logisticUnits = {
        "logistic #001",
        "logistic #002",
        "logistic #003",
        "logistic #004",
        "logistic #005",
        "logistic #006",
        "logistic #007",
        "logistic #008",
        "logistic #009",
        "logistic #010",
        "logistic #011",
        "logistic #012",
        "logistic #013",
        "logistic #014",
        "logistic #015",
        "logistic #016",
        "logistic #017",
        "logistic #018",
        "logistic #019",
        "logistic #020",
    }

    -- ************** UNITS ABLE TO TRANSPORT VEHICLES ******************
    -- Add the model name of the unit that you want to be able to transport and deploy vehicles
    -- units db has all the names or you can extract a mission.miz file by making it a zip and looking
    -- in the contained mission file
    ctld.vehicleTransportEnabled = {
        "76MD", -- the il-76 mod doesnt use a normal - sign so il-76md wont match... !!!! GRR
        "C-130",
    }


    -- ************** Maximum Units SETUP for UNITS ******************

    -- Put the name of the Unit you want to limit group sizes too
    -- i.e
    -- ["UH-1H"] = 10,
    --
    -- Will limit UH1 to only transport groups with a size 10 or less
    -- Make sure the unit name is exactly right or it wont work

    ctld.unitLoadLimits = {
        ["Mi-8MT"] = 24

        -- Remove the -- below to turn on options
        -- ["SA342Mistral"] = 4,
        -- ["SA342L"] = 4,
        -- ["SA342M"] = 4,

    }


    -- ************** Allowable actions for UNIT TYPES ******************

    -- Put the name of the Unit you want to limit actions for
    -- NOTE - the unit must've been listed in the transportPilotNames list above
    -- This can be used in conjunction with the options above for group sizes
    -- By default you can load both crates and troops unless overriden below
    -- i.e
    -- ["UH-1H"] = {crates=true, troops=false},
    --
    -- Will limit UH1 to only transport CRATES but NOT TROOPS
    --
    -- ["SA342Mistral"] = {crates=fales, troops=true},
    -- Will allow Mistral Gazelle to only transport crates, not troops

    ctld.unitActions = {
        ["Yak-52"] = {crates=false, troops=true}

        -- Remove the -- below to turn on options
        -- ["SA342Mistral"] = {crates=true, troops=true},
        -- ["SA342L"] = {crates=false, troops=true},
        -- ["SA342M"] = {crates=false, troops=true},

    }

    -- ************** INFANTRY GROUPS FOR PICKUP ******************
    -- Unit Types
    -- inf is normal infantry
    -- mg is M249
    -- at is RPG-16
    -- aa is Stinger or Igla
    -- mortar is a 2B11 mortar unit
    -- You must add a name to the group for it to work
    -- You can also add an optional coalition side to limit the group to one side
    -- for the side - 2 is BLUE and 1 is RED
    ctld.loadableGroups = {
        {name = "Standard Group", inf = 6, mg = 2, at = 2 }, -- will make a loadable group with 5 infantry, 2 MGs and 2 anti-tank for both coalitions
        {name = "Anti Air", inf = 2, aa = 3  },
        {name = "Anti Tank", inf = 2, at = 6  },
        {name = "Mortar Squad", mortar = 6 },
        {name = "Mortar Squad x 4", mortar = 24},
        -- {name = "Mortar Squad Red", inf = 2, mortar = 5, side =1 }, --would make a group loadable by RED only
    }

    -- ************** SPAWNABLE CRATES ******************
    -- Weights must be unique as we use the weight to change the cargo to the correct unit
    -- when we unpack
    --
    ctld.spawnableCrates = {
        -- name of the sub menu on F10 for spawning crates
        ["Ground Forces"] = {
            --crates you can spawn
            -- weight in KG
            -- Desc is the description on the F10 MENU
            -- unit is the model name of the unit to spawn
            -- cratesRequired - if set requires that many crates of the same type within 100m of each other in order build the unit
            -- side is optional but 2 is BLUE and 1 is RED
            -- dont use that option with the HAWK Crates
            { weight = 500, desc = "HMMWV - TOW", unit = "M1045 HMMWV TOW", side = 2 },
            { weight = 505, desc = "HMMWV - MG", unit = "M1043 HMMWV Armament", side = 2 },

            { weight = 510, desc = "BTR-D", unit = "BTR_D", side = 1 },
            { weight = 515, desc = "BRDM-2", unit = "BRDM-2", side = 1 },

            { weight = 520, desc = "HMMWV - JTAC", unit = "Hummer", side = 2, }, -- used as jtac and unarmed, not on the crate list if JTAC is disabled
            { weight = 525, desc = "SKP-11 - JTAC", unit = "SKP-11", side = 1, }, -- used as jtac and unarmed, not on the crate list if JTAC is disabled

            { weight = 100, desc = "2B11 Mortar", unit = "2B11 mortar" },

            { weight = 250, desc = "SPH 2S19 Msta", unit = "SAU Msta", side = 1, cratesRequired = 3 },
            { weight = 255, desc = "M-109", unit = "M-109", side = 2, cratesRequired = 3 },

            { weight = 252, desc = "Ural-375 Ammo Truck", unit = "Ural-375", side = 1, cratesRequired = 2 },
            { weight = 253, desc = "M-818 Ammo Truck", unit = "M 818", side = 2, cratesRequired = 2 },

            { weight = 800, desc = "FOB Crate - Small", unit = "FOB-SMALL" }, -- Builds a FOB! - requires 3 * ctld.cratesRequiredForFOB
        },
        ["AA Crates"] = {
            { weight = 50, desc = "Stinger", unit = "Stinger manpad", side = 2 },
            { weight = 55, desc = "Igla", unit = "SA-18 Igla manpad", side = 1 },

            -- HAWK System
            { weight = 540, desc = "HAWK Launcher", unit = "Hawk ln", side = 2},
            { weight = 545, desc = "HAWK Search Radar", unit = "Hawk sr", side = 2 },
            { weight = 550, desc = "HAWK Track Radar", unit = "Hawk tr", side = 2 },
            { weight = 551, desc = "HAWK PCP", unit = "Hawk pcp" , side = 2 }, -- Remove this if on 1.2
            { weight = 552, desc = "HAWK Repair", unit = "HAWK Repair" , side = 2 },
            -- End of HAWK

            -- KUB SYSTEM
            { weight = 560, desc = "KUB Launcher", unit = "Kub 2P25 ln", side = 1},
            { weight = 565, desc = "KUB Radar", unit = "Kub 1S91 str", side = 1 },
            { weight = 570, desc = "KUB Repair", unit = "KUB Repair", side = 1},
            -- End of KUB

            -- BUK System
            --        { weight = 575, desc = "BUK Launcher", unit = "SA-11 Buk LN 9A310M1"},
            --        { weight = 580, desc = "BUK Search Radar", unit = "SA-11 Buk SR 9S18M1"},
            --        { weight = 585, desc = "BUK CC Radar", unit = "SA-11 Buk CC 9S470M1"},
            --        { weight = 590, desc = "BUK Repair", unit = "BUK Repair"},
            -- END of BUK

            { weight = 595, desc = "Early Warning Radar", unit = "1L13 EWR", side = 1 }, -- cant be used by BLUE coalition

            { weight = 405, desc = "Strela-1 9P31", unit = "Strela-1 9P31", side = 1, cratesRequired = 3 },
            { weight = 400, desc = "M1097 Avenger", unit = "M1097 Avenger", side = 2, cratesRequired = 3 },

        },
    }

    -- if the unit is on this list, it will be made into a JTAC when deployed
    ctld.jtacUnitTypes = {
        "SKP", "Hummer" -- there are some wierd encoding issues so if you write SKP-11 it wont match as the - sign is encoded differently...
    }

    -- automatically add all the human-manned transport helicopters to ctld.transportPilotNames
    veafTransportMission.initializeAllHelosInCTLD()

    -- automatically add all the carriers and FARPs to ctld.logisticUnits
    veafTransportMission.initializeAllLogisticInCTLD()
    
    veaf.logInfo("init - ctld")
    ctld.initialize()
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- initialize the remote interface
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafRemote then
    veaf.logInfo("init - veafRemote")
    veafRemote.initialize()
end


-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- initialize the interpreter
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafInterpreter then
    veaf.logInfo("init - veafInterpreter")
    veafInterpreter.initialize()
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- initialize Skynet-IADS
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafSkynet then
    veaf.logInfo("init - veafSkynet")
    veafSkynet.initialize(
        false, --includeRedInRadio=true
        false, --debugRed
        false, --includeBlueInRadio
        false  --debugBlue
    )
end


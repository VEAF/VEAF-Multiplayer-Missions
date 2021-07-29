-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mission configuration file for the VEAF framework
-- see https://github.com/VEAF/VEAF-Mission-Creation-Tools
-------------------------------------------------------------------------------------------------------------------------------------------------------------
veaf.config.MISSION_NAME = "Operation-Daguet"
veaf.config.MISSION_EXPORT_PATH = nil -- use default folder

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- initialize all the scripts
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafRadio then
    veaf.loggers.get(veaf.Id):info("init - veafRadio")
    veafRadio.initialize(true)
end
if veafSpawn then
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
    veaf.loggers.get(veaf.Id):info("init - veafShortcuts")
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
    veaf.loggers.get(veaf.Id):info("Loading configuration")
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

    veaf.loggers.get(veaf.Id):info("init - veafAssets")
    veafAssets.initialize()
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure MOVE
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafMove then
    veaf.loggers.get(veaf.Id):info("Setting move tanker radio menus")
    -- keeping the veafMove.Tankers table empty will force veafMove.initialize() to browse the units, and find the tankers
    veaf.loggers.get(veaf.Id):info("init - veafMove")
    veafMove.initialize()
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure COMBAT MISSION
-------------------------------------------------------------------------------------------------------------------------------------------------------------

if veafCombatMission then 
	veaf.loggers.get(veaf.Id):info("Loading configuration")

	veaf.loggers.get(veaf.Id):info("init - veafCombatMission")
    veafCombatMission.initialize()
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure COMBAT ZONE
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafCombatZone then 
	veaf.loggers.get(veaf.Id):info("Loading configuration")

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

    veaf.loggers.get(veaf.Id):info("Loading configuration")

    veaf.loggers.get(veaf.Id):info("init - veafNamedPoints")
    veafNamedPoints.initialize()
    if theatre == "syria" then
        veafNamedPoints.addAllSyriaCities()
    elseif theatre == "caucasus" then
        veafNamedPoints.addAllCaucasusCities()
    elseif theatre == "persiangulf" then
        veafNamedPoints.addAllPersianGulfCities()
    elseif theatre == "thechannel" then
        veafNamedPoints.addAllTheChannelCities()
    elseif theatre == "marianaislands" then
        veafNamedPoints.addAllMarianasIslandsCities()
    else
        veafNamedPoints.logWarning(string.format("theatre %s is not yet supported by veafNamedPoints", theatre))
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- configure SECURITY
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafSecurity then
    --let's not set a password
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

    -- ******************** Transports names **********************

    -- Use any of the predefined names or set your own ones
    ctld.transportPilotNames = {}

    for i = 1, 24 do
        table.insert(ctld.transportPilotNames, string.format("yak #%03d",i))
    end

    for i = 1, 10 do
        table.insert(ctld.transportPilotNames, string.format("transport #%03d",i))
    end

    for i = 1, 79 do
        table.insert(ctld.transportPilotNames, string.format("helicargo #%03d",i))
    end

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

    if veafTransportMission then

        -- automatically add all the human-manned transport helicopters to ctld.transportPilotNames
        veafTransportMission.initializeAllHelosInCTLD()

        -- automatically add all the carriers and FARPs to ctld.logisticUnits
        veafTransportMission.initializeAllLogisticInCTLD()
    end
    
    veaf.loggers.get(veaf.Id):info("init - ctld")
    ctld.initialize()
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- initialize the remote interface
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafRemote then
    veaf.loggers.get(veaf.Id):info("init - veafRemote")
    veafRemote.initialize()
end


-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- initialize the interpreter
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafInterpreter then
    veaf.loggers.get(veaf.Id):info("init - veafInterpreter")
    veafInterpreter.initialize()
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
        false  --debugBlue
    )
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- initialize veafSanctuary
-------------------------------------------------------------------------------------------------------------------------------------------------------------
if veafSanctuary then
    veafSanctuary.initialize()
end

-- THIS IS THE MAIN TABLE OF FLIGHT PLAN WAYPOINTS. 
-- DEFINE THE WAYPOINTS HERE AND REFER TO THEN LATER IN THE FILE
--
-- THIS SHOULD BE THE ONLY PART OF THIS FILE YOU'LL NEED TO CHANGE IF YOU ONLY CHANGE THE WAYPOINTS
-- TO ADD OR CHANGE AIRCRAFT AND COALITION TEMPLATES, SEE FURTHER BELOW
waypoints =
{
    ["BULLSEYE"] = {
        ["type"] = "Turning Point",
        ["action"] = "Turning Point",
        ["alt"] = 6096, -- 20000 ft
        ["alt_type"] = "BARO",
        ["ETA"] = 364.89432745775,
        ["ETA_locked"] = false,
        ["speed"] = 999,
        ["speed_locked"] = true,
        ["name"] = "BULLSEYE",
        ["x"] = 75869,
        ["y"] = 48674,
    }, -- end of [BULLSEYE]
    ["FARP-LONDON"] = 
    {
        ["type"] = "Turning Point",
        ["action"] = "Turning Point",
        ["alt"] = 0, -- 0 ft
        ["alt_type"] = "BARO",
        ["ETA"] = 364.89432745775,
        ["ETA_locked"] = false,
        ["speed"] = 999,
        ["speed_locked"] = true,
        ["y"] = 696866.43000721,
        ["x"] = -273259.22843865,
        ["name"] = "FARP-LONDON",
    }, -- end of [FARP-LONDON]
    ["SENAKI"] = 
    {
        ["type"] = "Turning Point",
        ["action"] = "Turning Point",
        ["alt"] = 0, -- 0 ft
        ["alt_type"] = "BARO",
        ["ETA"] = 364.89432745775,
        ["ETA_locked"] = false,
        ["speed"] = 999,
        ["speed_locked"] = true,
        ["y"] = 648062.625,
        ["x"] = -281724.8125,
        ["name"] = "SENAKI",
    }, -- end of [SENAKI]
    ["ZONE EASY-0"] = 
    {
        ["type"] = "Turning Point",
        ["action"] = "Turning Point",
        ["alt"] = 6096, -- 20000 ft
        ["alt_type"] = "BARO",
        ["ETA"] = 364.89432745775,
        ["ETA_locked"] = false,
        ["speed"] = 999,
        ["speed_locked"] = true,
        ["y"] = 690821.13466418,
        ["x"] = -272367.471275,
        ["name"] = "ZONE EASY-0",
    }, -- end of [EASY-0]
    ["ZONE EASY-1"] = 
    {
        ["type"] = "Turning Point",
        ["action"] = "Turning Point",
        ["alt"] = 6096, -- 20000 ft
        ["alt_type"] = "BARO",
        ["ETA"] = 364.89432745775,
        ["ETA_locked"] = false,
        ["speed"] = 999,
        ["speed_locked"] = true,
        ["y"] = 684109.36670653,
        ["x"] = -284442.17033794,
        ["name"] = "ZONE EASY-1",
    }, -- end of [EASY-1]
    ["ZONE MEDIUM-2"] = 
    {
        ["type"] = "Turning Point",
        ["action"] = "Turning Point",
        ["alt"] = 6096, -- 20000 ft
        ["alt_type"] = "BARO",
        ["ETA"] = 364.89432745775,
        ["ETA_locked"] = false,
        ["speed"] = 999,
        ["speed_locked"] = true,
        ["y"] = 713235.44422001,
        ["x"] = -253541.91551399,
        ["name"] = "ZONE MEDIUM-2",
    }, -- end of [MEDIUM-2]
    ["ZONE MEDIUM-3"] = 
    {
        ["type"] = "Turning Point",
        ["action"] = "Turning Point",
        ["alt"] = 6096, -- 20000 ft
        ["alt_type"] = "BARO",
        ["ETA"] = 364.89432745775,
        ["ETA_locked"] = false,
        ["speed"] = 999,
        ["speed_locked"] = true,
        ["y"] = 687583.79727285,
        ["x"] = -249476.09251083,
        ["name"] = "ZONE MEDIUM-3",
    }, -- end of [MEDIUM-3]
    ["ZONE HARD-4"] = 
    {
        ["type"] = "Turning Point",
        ["action"] = "Turning Point",
        ["alt"] = 6096, -- 20000 ft
        ["alt_type"] = "BARO",
        ["ETA"] = 364.89432745775,
        ["ETA_locked"] = false,
        ["speed"] = 999,
        ["speed_locked"] = true,
        ["y"] = 730385.82488785,
        ["x"] = -262634.57423012,
        ["name"] = "ZONE HARD-4",
    }, -- end of [HARD-4]
    ["ZONE HARD-5"] = 
    {
        ["type"] = "Turning Point",
        ["action"] = "Turning Point",
        ["alt"] = 6096, -- 20000 ft
        ["alt_type"] = "BARO",
        ["ETA"] = 364.89432745775,
        ["ETA_locked"] = false,
        ["speed"] = 999,
        ["speed_locked"] = true,
        ["y"] = 666589.36576567,
        ["x"] = -251398.11793051,
        ["name"] = "ZONE HARD-5",
    }, -- end of [HARD-5]
}

-- THIS IS THE TABLE OF flightPlan settings. 
-- MAKE USE OF THE WAYPOINTS  DEFINED EARLIER IF YOU WANT
-- BY SETTING THE VALUE OF THE type, coalition, AND country PARAMETERS, YOU CAN TARGET A TEMPLATE TO A SPECIFIC GROUP OF AIRCRAFTS
settings =
{
    ["all blue planes"] =
    {
        category = "plane",
        coalition = "blue",
        type = nil,
        country = nil,
        replaceAllButFirst = true,

        ["waypoints"] =
        {
            "FARP-LONDON",
            "ZONE EASY-0",
            "ZONE EASY-1",
            "ZONE MEDIUM-2",
            "ZONE MEDIUM-3",
            "ZONE HARD-4",
            "ZONE HARD-5",
            "BULLSEYE",
        }, -- end of ["waypoints"]
    },

    ["all blue helicopters"] =
    {
        category = "helicopter",
        coalition = "blue",
        type = nil,
        country = nil,
        replaceAllButFirst = true,

        ["waypoints"] =
        {
            "SENAKI",
            "ZONE EASY-0",
            "ZONE EASY-1",
            "ZONE MEDIUM-2",
            "ZONE MEDIUM-3",
            "ZONE HARD-4",
            "ZONE HARD-5",
            "BULLSEYE",
        }, -- end of ["waypoints"]
    },
}

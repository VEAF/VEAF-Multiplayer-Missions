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
        ["x"] = -00284798,
        ["y"] = 00683681,
    }, -- end of [BULLSEYE]

    ["TRAINING_SHORT"] = {
        ["type"] = "Turning Point",
        ["action"] = "Turning Point",
        ["alt"] = 6096, -- 20000 ft
        ["alt_type"] = "BARO",
        ["ETA"] = 364.89432745775,
        ["ETA_locked"] = false,
        ["speed"] = 999,
        ["speed_locked"] = true,
        ["name"] = "TRAINING_SHORT",
        ["x"] = -00328309,
        ["y"] = 00631219,
    }, -- end of [TRAINING_SHORT]

    ["TRAINING_MEDIUM"] = {
        ["type"] = "Turning Point",
        ["action"] = "Turning Point",
        ["alt"] = 6096, -- 20000 ft
        ["alt_type"] = "BARO",
        ["ETA"] = 364.89432745775,
        ["ETA_locked"] = false,
        ["speed"] = 999,
        ["speed_locked"] = true,
        ["name"] = "TRAINING_MEDIUM",
        ["x"] = -00281178,
        ["y"] = 00798446,
    }, -- end of [TRAINING_MEDIUM]

    ["TRAINING_LONG"] = {
        ["type"] = "Turning Point",
        ["action"] = "Turning Point",
        ["alt"] = 6096, -- 20000 ft
        ["alt_type"] = "BARO",
        ["ETA"] = 364.89432745775,
        ["ETA_locked"] = false,
        ["speed"] = 999,
        ["speed_locked"] = true,
        ["name"] = "TRAINING_LONG",
        ["x"] = -00051298,
        ["y"] = 00705827,
    }, -- end of [TRAINING_LONG]

    ["TRAINING_SA10"] = {
        ["type"] = "Turning Point",
        ["action"] = "Turning Point",
        ["alt"] = 6096, -- 20000 ft
        ["alt_type"] = "BARO",
        ["ETA"] = 364.89432745775,
        ["ETA_locked"] = false,
        ["speed"] = 999,
        ["speed_locked"] = true,
        ["name"] = "TRAINING_SA10",
        ["x"] = -00026420,
        ["y"] = 00458064,
    }, -- end of [TRAINING_SA10]
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

        ["waypoints"] =
        {
            [1] = "BULLSEYE",
            [2] = "TRAINING_SHORT",
            [3] = "TRAINING_MEDIUM",
            [4] = "TRAINING_LONG",
            [5] = "TRAINING_SA10",
        }, -- end of ["waypoints"]
    },

    ["all blue helicopters"] =
    {
        category = "helicopter",
        coalition = "blue",
        type = nil,
        country = nil,

        ["waypoints"] =
        {
            [1] = "BULLSEYE",
            [2] = "TRAINING_SHORT",
            [3] = "TRAINING_MEDIUM",
            [4] = "TRAINING_LONG",
            [5] = "TRAINING_SA10",
        }, -- end of ["waypoints"]
    },
}

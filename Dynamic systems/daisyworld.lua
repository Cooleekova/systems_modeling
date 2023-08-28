--[[
Gaia Theory (Gaia Hypothesis):
the world is a strongly interacting system
(James Lovelock and )

"Faint sun paradox"

--]]

import("sysdyn")
import("calibration")


local m = MultipleRuns{
    model = Daisyworld,
    parameters = {
        sunLuminosity = Choice{min = 0.4, max = 1.6, step = 0.01},
    }
}

chart = Chart{
    target = m.output,
    select = {"blackArea", "whiteArea", "emptyArea"},
    xAxis = "sunLuminosity"
}








--[[


simulation = Daisyworld{finalTime=50}

-- we make simulation for 50 years
simulation:run()

-- after 50 years we change luminosity and continue simulation fot more 100 years
simulation.sunLuminosity = 0.9
simulation.finalTime = 150

simulation:run()


-- after 150 years we change luminosity again and continue for more 100 years
simulation.sunLuminosity = 1.2  -- 1.8 all flowers died
simulation.finalTime = 250

simulation:run()

--]]


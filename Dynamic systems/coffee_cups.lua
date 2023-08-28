-- FEEDBACK OF THE DYNAMIC SYSTEM
-- TYPE 1 (NEGATIVE)
-- TYPE 2 (POSITIVE)
-- coffee cups cooling or warming
-- three simulations with different coffee temperature (80, 20, 5)

Coffee = Model{
    coffeeTemperature = 20, -- STOCK, celsius degrees, oC
    --Mandatory("number")
    roomTemperature = -10, -- celsius degrees, oC
    finalTime = 100, -- min
    init = function(model)
        --[[model.chart = Chart{
            target = model,
            select = "coffeeTemperature"
        }--]]
        model.Timer = Timer{
            --Event{action = model.chart},
            -- balancing (negative) feedback of the system, it tries to make coffee temperature more close to the ambient temperature
            Event{action = function()
                -- расхождение
                local discrepancy = model.coffeeTemperature - model.roomTemperature
                model.coffeeTemperature = model.coffeeTemperature - discrepancy * 0.1
            end}
        }
    end
}

-- Coffee:run()

env = Environment{
    simulation1 = Coffee{coffeeTemperature = 80},
    simulation2 = Coffee{coffeeTemperature = 20},
    simulation3 = Coffee{coffeeTemperature = 5}
}

chart = Chart{
    target = env,
    select = "coffeeTemperature"
}

-- add chart to environment
env:add(Event{action = chart})

-- run environment "env"
env:run()

--[[
simulation1 = Coffee{coffeeTemperature = 80}
simulation1:run()

simulation2 = Coffee{coffeeTemperature = 5}
simulation2:run()
--]]




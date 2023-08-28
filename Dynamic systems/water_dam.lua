--[[
In the year of 1950, a given city has 100,000 inhabitants. A dam with a capacity
of 5,000,000,000 m3 of water produces hydroelectric energy for the whole city. In
the region, two rainy seasons take place in each year. In the first season, the rains
add 2,000,000,000 m3 of water to the dam, while in the second they add
1,500,000,000 m3. In the beginning of 1950, the dam is full and each inhabitant
consumes on average 10kWh of energy per month. Each kWh of energy requires
100m3 (0.0000001 km3) of water to be produced. The consumption of energy increases an average
of 5% per inhabitant each year.
--]]

WaterDam = Model{
    population = 100000, -- inhabitants
    damCapacity = 5, --km3
    overallRainAmountPerYear = 3.5, --km3, first rainy season + second rainy season
    -- each inhabitant consumes on average 10kWh of energy per month
    consumePerYear = 120, -- kWh (formula: 10kWh per month per inhabitant * 12 month)
    -- Each kWh of energy requires 100m3 of water to be produced
    water2Energy = 0.0000001, -- 100 m3 (0.0000001 km3) of water is needed to produce 1 kWh
    consumptionGrowthPerYear = 1.05, -- increase 5% per inhabitant each year
    finalTime = 50, --years
    init = function(model)
        -- [[
            model.chart = Chart{
            target = model,
            select = {"damCapacity",
                "overallRainAmountPerYear"
                },
        }
        --]]
        model.Timer = Timer{
             Event{action = model.chart},
             Event{action = function()
                -- count how much water is needed to satisfy yearly energy demand of the city population
                local capacityDecreasePerYear = model.consumePerYear * model.population * model.water2Energy

                -- each year dam capacity increases by amount of rain and decreases by water consumption amount
                model.damCapacity = model.damCapacity + model.overallRainAmountPerYear - capacityDecreasePerYear
                -- the consumption of energy increases an average of 5% per inhabitant each year
                model.consumePerYear = model.consumePerYear * model.consumptionGrowthPerYear

                -- there can't be more than 5 km3 of water in the dam
                if model.damCapacity > 5 then
                   model.damCapacity = 5
                -- and there can't be less then 0 km3 of water in the dam
                elseif model.damCapacity < 0 then
                   model.damCapacity = 0
                end

            end}
        }
    end
}

WaterDam:run()

--[[
simulation = WaterDam{}
simulation:run()
simulation.chart:save("simulation_1.png")
--]]




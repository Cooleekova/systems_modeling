--[[
In the year of 1950, a given city has 100,000 inhabitants. A dam with a capacity
of 5,000,000,000m3 of water produces hydroelectric energy for the whole city. In
the region, two rainy seasons take place in each year. In the first season, the rains
add 2,000,000,000m3 of water to the dam, while in the second they add
1,500,000,000m3. In the beginning of 1950, the dam is full and each inhabitant
consumes on average 10kWh of energy per month. Each kWh of energy requires
100m3 (0.0000001 km3) of water to be produced. The consumption of energy increases an average
of 5% per inhabitant each year.
--]]

WaterDam = Model{
    population = 100000, -- inhabitants
    damCapacity = 5, --km3
    firstRainySeason = 2, --km3
    secondRainySeason = 1.5, --km3
    -- Each kWh of energy requires 100m3 of water to be produced
    -- each inhabitant consumes on average 10kWh of energy per month
    -- 10kWh * 100m3 = 1000 m3 per month, consume of dam capacity per each inhabitant
    -- 12000 m3 per year
    consumePerMonth = 10, -- 10kWh
    water2Energy = 0.0000001, -- 100 m3 of water to produce 1 kWh, 0.0000001 km3
    averageConsumePerMonth = 0.000001, -- m3 per month per inhabitant
    averageConsumePerYear = 0.000012, -- m3 per year per inhabitant
    increasePerYear = 1.05, -- per inhabitant each year
    finalTime = 35,
    init = function(model)
        model.chart = Chart{
            target = model,
            select = {"damCapacity"},
        }
        model.Timer = Timer{
             Event{action = model.chart},
             Event{action = function()

                local capacityDecreasePerYear = model.averageConsumePerYear * model.population
                local waterIncreasePerYear = model.firstRainySeason + model.secondRainySeason

                model.damCapacity = model.damCapacity + waterIncreasePerYear - capacityDecreasePerYear
                model.averageConsumePerYear = model.averageConsumePerYear * model.increasePerYear

                if model.damCapacity > 5 then
                   model.damCapacity = 5
                elseif model.damCapacity < 0 then
                   model.damCapacity = 0
                end

            end}
        }
    end
}


WaterDam:run()





--[[

Develop a model to investigate future scenarios for the dam. For each of the
scenarios below, how long will it take until the dam is not able to provide all the
energy required by the city?
1) If nothing else happens.
2) If the turbines would require only 80m3 of water to generate 1kWh.
3) If the consumption growth falls by half.
4) If the overall rain falls by half from 1970 onwards.
5) If the scenarios (2), (3), and (4) take place

--]]


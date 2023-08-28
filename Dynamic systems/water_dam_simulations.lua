dofile("water_dam.lua")

--[[
Develop a model to investigate future scenarios for the dam. For each of the
scenarios below, how long will it take until the dam is not able to provide all the
energy required by the city?
--]]


-- If the turbines would require only 80m3 of water to generate 1kWh.
simulation80m3For1kWh = WaterDam{water2Energy=0.00000008}
simulation80m3For1kWh:run()



-- If the consumption growth falls by half
simulationConsumptionGrowthFallsByHalf = WaterDam{finalTime=70, consumptionGrowthPerYear=1.025}
simulationConsumptionGrowthFallsByHalf:run()



-- If the overall rain falls by half from 1970 onwards.
simulationHalfRainfall = WaterDam{finalTime=20}

-- we make simulation for 20 years from 1950 until 1970
simulationHalfRainfall:run()

-- after 20 years we change amount of rain and continue simulation for more 40 years
simulationHalfRainfall.overallRainAmountPerYear = 1.75
simulationHalfRainfall.finalTime = 60

simulationHalfRainfall:run()


--[[
If the turbines would require only 80m3 of water to generate 1kWh
and the consumption growth falls by half
and the overall rain falls by half from 1970 onwards.
--]]

simulation5 = WaterDam{finalTime=20, water2Energy=0.00000008, consumptionGrowthPerYear=1.025}

-- we make simulation for 20 years from 1950 until 1970
simulation5:run()

-- after 20 years we change amount of rain and continue simulation for more 40 years
simulation5.overallRainAmountPerYear = 1.75
simulation5.finalTime = 60

simulation5:run()





Cycle = Model{
    oceanSurface = 700,
    fossilFuelBurning = 5,
    deforestation = 2,
    atmosphere = 700,
    deepOcean = 35000,
    terrestrialBiosphere = 550,
    soilCarbon = 1200,
    --season equation = 1+(COS(2*PI*(time+0.125)))
    --season = 1,
    finalTime = 50,
    init = function(model)
        model.atmCO2 = function()
            return model.atmosphere/2
        end

        model.chart = Chart{
            target = model,
            select = {"atmCO2"},
        }
        --[[
        model.chart2 = Chart{
            target = model,
            select = {"season"},
        }
        --]]

        model.timer = Timer{
            Event{period = 0.25, action = model.chart},
            --Event{period = 0.25, action = model.chart2},

            Event{period = 0.25, action = function()
            model.time = model.timer:getTime()

            print("time", model.time)
            print("season", model.season)
            model.season = 1 + (math.cos(2 * math.pi * (model.time + 0.125)))
            print("season", model.season)

            -- OCEAN PROCESSES
            local oceanUptake = model.atmosphere/20
            --print("oceanUptake", oceanUptake)
            local oceanDegassing = model.oceanSurface/20
            --print("oceanDegassing", oceanDegassing)
            --rise and fall of deep waters and biopump
            local upwelling = model.deepOcean * 0.002
            --print("upwelling", upwelling)
            local downwelling = model.oceanSurface * 0.002
            --print("downwelling", downwelling)
            local biopump = 6.76 + model.oceanSurface/700
            --print("biopump    ", biopump)


            -- BIOSPHERE AND SOIL PROCESSES
            local respiration = model.terrestrialBiosphere * 0.1 * model.season
            local photosynthesis = (model.terrestrialBiosphere * 0.1483 + model.atmosphere/700) * model.season
            local death = 0.05 * model.terrestrialBiosphere
            local decay = 0.021 * model.soilCarbon + model.atmosphere/750

            model.atmosphere = model.atmosphere + ((oceanDegassing + respiration + decay + model.fossilFuelBurning +                model.deforestation - oceanUptake - photosynthesis) * 0.25)

            --print("atmosphere: ", model.atmosphere)

            model.oceanSurface = model.oceanSurface + (oceanUptake + upwelling - oceanDegassing - downwelling - biopump)
            --print("oceanSurface", model.oceanSurface)

            model.deepOcean = model.deepOcean + (downwelling + biopump - upwelling)
            --print("deepOcean", model.deepOcean)

            model.terrestrialBiosphere = model.terrestrialBiosphere + (photosynthesis - respiration - death -                model.deforestation)

            model.soilCarbon = model.soilCarbon + (death - decay)

            end}

        }
    end
}


Cycle:run()
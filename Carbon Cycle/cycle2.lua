



Cycle = Model{
    oceanSurface = 700,
    fossilFuelBurning = 5,
    deforestation = 2,
    atmosphere = 700,
    deepOcean = 35000,
    terrestrialBiosphere = 550,
    respiration = 55, -- model.terrestrialBiosphere * 0.1
    photosynthesis = 81.565, --(model.terrestrialBiosphere * 0.1483 + model.atmosphere/700
    soilCarbon = 1200,

    --season equation = 1+(COS(2*PI*(time+0.125)))
    season = 1,
    finalTime = 50,
    init = function(model)
        model.atmCO2 = function()
            return model.atmosphere/2
        end

        model.oceanUptake = function()
            return model.atmosphere/20
        end

        model.oceanDegassing = function()
            return model.oceanSurface/20
        end

        model.upwelling = function()
            return model.deepOcean * 0.002
        end


        model.downwelling = function()
            return model.oceanSurface * 0.002
        end

        model.biopump = function()
            return 6.76 + model.oceanSurface/700
        end

        model.death = function()
            return 0.05 * model.terrestrialBiosphere
        end

        model.decay = function()
            return 0.021 * model.soilCarbon + model.atmosphere/750
        end


        model.chart = Chart{
            target = model,
            select = {"respiration", "photosynthesis"},
        }
        -- [[
        model.chart2 = Chart{
            target = model,
            select = {"season", },
        }
        --]]

        model.timer = Timer{
            Event{period = 1, action = model.chart},
            Event{period = 0.25, action = model.chart2},
            Event{period = 0.002739726, action = function()
            model.time = model.timer:getTime()
            model.season = model.season + (math.cos(2 * math.pi * (model.time + 0.125)))
            print(model.time)
            local respiration = model.respiration * model.season
            print("respiration", respiration)
            local photosynthesis = model.photosynthesis * model.season
            print("photosynthesis", photosynthesis)

            model.atmosphere = model.atmosphere + (model.oceanDegassing() + respiration + model.decay() + model.fossilFuelBurning +                model.deforestation - model.oceanUptake() - photosynthesis)

            model.oceanSurface = model.oceanSurface + (model.oceanUptake() + model.upwelling() - model.oceanDegassing() - model.downwelling() - model.biopump())

            model.deepOcean = model.deepOcean + (model.downwelling() + model.biopump() - model.upwelling())

            model.terrestrialBiosphere = model.terrestrialBiosphere + (photosynthesis - respiration - model.death() -                model.deforestation)

            model.soilCarbon = model.soilCarbon + (model.death() - model.decay())
            end},

            Event{action = function()



            end}

        }
    end
}


Cycle:run()
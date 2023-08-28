



energyBalance = Model{
    S = 1370,
    R = 6.4 * 10^6,
    a = 0.3,
    pi = 3.14,
    energyIn = 10^17,
    energyOut = 29169745.92,
    g = 0.8,
    temperature = 0, -- Kelvin
    finalTime = 300,
    init = function(model)
        model.chart = Chart{
            target = model,
            select = {"energyIn", "energyOut"},
            xAxis = "temperature",
            --yAxis = "energyIn"
        }
        model.timer = Timer{
            Event{action = model.chart},
            Event{action = function()

                --local en = 4 * model.pi * (model.R^2) * (5.67 * 10^-8) --* (model.temperature^4)
                --print("en", en)

                 model.temperature = model.temperature + 1
                 model.energyOut = 29169745.92 * (model.temperature^4)

                --[[
                if model.energyOut < model.energyIn then
                    model.temperature = model.temperature + 1
                    model.energyOut = 29169745.92 * (model.temperature^4)
                else
                    print(model.temperature)
                    model.timer:clear()
                    return false
                end



                --]]

                --model.energyOut = model.energyOut * (model.temperature^4)
                --local out = (1 - model.g) * 4 * 3.14 * (6.4 * 10e6)^2 * (5.67 * 10e8) * model.temperature^4
                --print(out)
                --model.energyOut = model.energyOut + out
                --print(model.energyOut)
        end}
        }
    end
}



energyBalance:run()

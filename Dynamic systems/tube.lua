-- my first model of dynamic system

Tube = Model{
    water = 40, -- galoes
    finalTime = 80, -- minutos
    outflow = 5,
    inflow = 40,
    init = function(model)
        model.chart = Chart{
            target = model,
            select = "water"
        }

        model.timer = Timer{
            Event{action = model.chart},
            Event{start = 10, period = 10, action = function()
                model.water = model.water + model.inflow
            end},
            Event{priority="high", action = function()
                model.water = model.water - model.outflow

                if model.water < 0 then
                   model.water = 0
                end

            end}
        }
    end
}
Tube:run()
-- FEEDBACK OF THE DYNAMIC SYSTEM
-- TYPE 1 (NEGATIVE)
-- TYPE 2 (POSITIVE)
-- negative feedback always compete with positive feedback
-- population growth model
-- two simulations with different starting population (60, 20)

Population = Model{
    population = 60, -- STOCK
    growth = 0.5,
    finalTime = 7, -- years
    init = function(model)
        model.Timer = Timer{
            Event{action = function()
                -- positive feedback of the system
                model.population = model.population + (model.population * model.growth) -- P * (1 * model.growth)
                -- negative feedback
                model.growth = model.growth * 0.8
            end}
        }
    end
}

env = Environment{
    simulation1 = Population{}, -- default values declared in the model
    simulation2 = Population{population=20, growth=0.9}
}

chart = Chart{
    target = env,
    select = "population"
}

-- add chart to environment
env:add(Event{action = chart})

-- run environment "env"
env:run()

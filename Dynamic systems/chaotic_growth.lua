-- CHAOTIC GROWTH
-- growth(t) = rate x growth(t-dt) x (1 - growth(t-dt))
-- Initial stock:
-- growth = 0.1
-- t = years
-- dt = 1 year
-- Run time = 300 years
-- rate = 1, 2, 3, 4


ChaoticGrowth = Model{
    growth = 0.1,
    finalTime = 30,
    rate = 4,
    init = function(model)
        --[[ model.chart = Chart{
            target = model,
            select = "growth"
        } --]]

        model.timer = Timer{
            -- Event{action = model.chart},
            Event{action = function()
               model.growth = model.rate * model.growth * (1 - model.growth)
            end}
        }
    end
}

ChaoticGrowth:run()


env = Environment{
    simulation1 = ChaoticGrowth{growth=0.1},
    simulation2 = ChaoticGrowth{growth=0.100001},
    -- simulation3 = ChaoticGrowth{growth=0.099999},
    --simulation4 = ChaoticGrowth{growth=0.1},
}

chart = Chart{
    target = env,
    select = "growth"
}

env:add(Event{action = chart})

env:run()
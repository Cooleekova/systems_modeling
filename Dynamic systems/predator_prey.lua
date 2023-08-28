-- one species uses another as a food resource
-- LOTKA-VOLTERRA MODEL

--r: prey growth rate (Malthus law)
-- m: predator mortality (natural mortality)
-- e: prey into predator biomass conversuin coefficent
-- a and b: predation coifficientes

-- dx/dt = rx - axy
-- dy/dt = -my + bxy

-- R = 0.08, M = 0.02, B = 0.00002, A = 0.001
-- T = YEARS
-- 40 wolfes, 1000 rabbits


PredatorPrey = Model{
    r = 0.08,
    m = 0.02,
    b = 0.00002,
    a = 0.001,
    finalTime = 4000,
    wolfes = 40,
    rabbits = 1000,
    init = function(model)
        model.chart1 = Chart{
            target = model,
            select = {"wolfes", "rabbits"},
        }
        model.chart2 = Chart{
            target = model,
            select = "wolfes",
            xAxis = "rabbits"
        }
        model.Timer = Timer{
            Event{action = model.chart1},
            Event{action = model.chart2},
            Event{period = 0.01, action = function()
                -- dx/dt = rx - axy
                local drabbits = model.r * model.rabbits - model.a * model.rabbits * model.wolfes

                -- dy/dt = -my + bxy
                local dwolfes = - model.m * model.wolfes + model.b * model.rabbits * model.wolfes

                model.rabbits = model.rabbits + drabbits * 0.01
                model.wolfes = model.wolfes + dwolfes * 0.01
        end}
        }
    end
    }



simulation = PredatorPrey{}

simulation:run()
simulation.chart1:save("predator_prey_result.png")
simulation.chart2:save("predator_prey_dependency.png")



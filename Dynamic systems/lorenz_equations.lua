-- x = y = z = 1
-- sigma = 10
-- rho = 28
-- beta = 8/3
-- dt = 0.01


-- create file to store results of simulation
myFile = File("resultLorenz.csv")

LorenzSystem = Model{
    x = 1,
    y = 1,
    z = 1,
    sigma = 10,
    rho = 28,
    beta = 8/3,
    dt = 0.01,
    finalTime = 4000,
    init = function(model)
        --[[model.chart1 = Chart{
            target = model,
            -- 1) select = {"x","y","z"}
            select = "x",
            xAxis = "y"
        }

        model.chart2 = Chart{
            target = model,
            select = "x",
            xAxis = "z"
        }

        model.chart3 = Chart{
            target = model,
            select = "z",
            xAxis = "x"
        } ]]--


        model.timer = Timer{
            -- Event{action = model.chart1},
            -- Event{action = model.chart2},
            -- Event{action = model.chart3},

            Event{action = function()
               local dx = model.sigma * (model.y - model.x)
               local dy = model.x * (model.rho - model.z) - model.x
               local dz = model.x * model.y - model.beta * model.z

               model.x = model.x + dx * model.dt
               model.y = model.y + dy * model.dt
               model.z = model.z + dz * model.dt

               -- to save results of simulation in file
               myFile:writeLine({model.x, model.y, model.z})

            end}
        }
    end
}

LorenzSystem:run()


-- [[
env = Environment{
    simulation1 = LorenzSystem{x=1},
    simulation2 = LorenzSystem{x=0.9999},
    simulation3 = LorenzSystem{x=1.0001}

}

chart = Chart{
    target = env,
    select = "x"
}

env:add(Event{action = chart})

env:run()
--]]
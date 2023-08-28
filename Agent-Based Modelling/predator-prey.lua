

PredatorPrey = Model{
    finalTime = 500,
    initialEnergy  = 40,
    dailyEnergyWolf = 4,
    dailyEnergyRabbit = 1,
    soilToGrow = 4,
    iniitialWolfes = 20,
    initialRabbits = 20,
    dim = 30,
    init = function(model)
        model.cell = Cell{
            state = "pasture",
            becomeSoil = function(cell)
               cell.state = "soil"
               cell.count = 0
            end,
            execute = function(cell)
                if cell.state == "soil" then
                   cell.count = cell.count + 1
                   if cell.count >= 4 then
                      cell.state = "pasture"
                   end
                end
            end
        }

        model.cs = CellularSpace{
            xdim = model.dim,
            instance = model.cell,
        }

        model.cs:createNeighborhood()

        model.prey = Agent{
            energy = model.initialEnergy,
            execute = function(agent)
                if agent:getCell().state == "pasture" then
                   agent:getCell():becomeSoil()
                   agent.energy = agent.energy + 7
                end

                agent:walk()

                agent.energy = agent.energy - model.dailyEnergyRabbit

                if agent.energy >= 80 then
                   agent:reproduce()
                   agent.energy = agent.energy - model.initialEnergy
                end

                if agent.energy <= 0 then
                    agent:die()
                end
            end
        }

        model.preys = Society{
            instance = model.prey,
            quantity = model.initialRabbits,
        }

        model.chart = Chart{
            target = model.preys,
        }

        model.env = Environment{
            model.cs,
            model.preys
        }

        model.env:createPlacement{}

        model.map1 = Map{
            target = model.cs,
            select = "state",
            grid = true,
            value = {"pasture", "soil"},
            color = {"green", "brown"},
        }

        model.map1 = Map{
            target = model.preys,
            background = model.map1,
            symbol = "rabbit"
        }

        model.timer = Timer{
            Event{action = model.chart},
            Event{action = model.map1},
            Event{action = model.preys},
            Event{priority = "high", action = model.cs},
        }
    end
}


PredatorPrey:run()
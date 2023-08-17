


RandomWalker = Model{
    finalTime = 3000,
    init = function(model)
        model.agent = Agent{
            execute = function(agent)
                agent:walk()
            end
        }

        model.cell = Cell{
            state = function(cell)
                if cell:isEmpty() then
                    return "empty"
                else
                    return "full"
                end
            end
        }

        model.cs = CellularSpace{
            xdim = 30,
            instance = model.cell
        }

        model.cs:createNeighborhood()


        model.env = Environment{
            model.agent,
            model.cs
        }

        model.env:createPlacement() -- default is "random"

          model.map = Map{
            target = model.cs,
            select = "state",
            grid = true,
            value = {"empty", "full"},
            color = {"white", "black"}
        }

        model.timer = Timer{
            Event{period = 10, action = model.agent},
            Event{action = model.map}
        }
    end
}


RandomWalker:run()
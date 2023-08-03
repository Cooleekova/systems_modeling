-- Random{seed = 1234567}


Fire = Model{
    dim = 50,
    finalTime = 99,
    empty = 0.5,
    init = function(model)
        model.cell = Cell{
            state = Random{forest = 1 - model.empty, empty = model.empty},
            --state = Random{forest = 0.70, empty = 0.30},
            execute = function(cell)
                if cell.state == "burning" then
                    cell.state = "burned"
                elseif cell.state == "forest" then
                    forEachNeighbor(cell, function(neighbor)
                        if neighbor.past.state == "burning" then
                            cell.state = "burning"
                            return false
                        end
                    end)
                end
            end
        }

        model.cs = CellularSpace{
            xdim = model.dim,
            instance = model.cell
        }

        -- select random cell to start fire
        model.cs:sample().state = "burning"

        -- select exact cell to start fire
        -- model.cs:get(0,0).state = "burning"

        model.cs:createNeighborhood{strategy = "vonneumann"}


        model.map = Map{
            target = model.cs,
            select = "state",
            grid = true,
            value = {"forest", "burning", "burned", "empty"},
            color = {"green", "red", "gray", "white"}
        }

        model.timer = Timer{
            Event{action = model.map},
            Event{action = model.cs},
        }
    end
}


Fire:run()
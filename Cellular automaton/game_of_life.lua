Random{seed = 1234567}

GameOfLife = Model{
    finalTime = 200,
    dim = 50,
    init = function(model)
        model.cell = Cell{
            state = Random{"dead", "alive"},
            execute = function(cell)
                local count = 0

                forEachNeighbor(cell, function(neighbor)
                    if neighbor.past.state == "alive" then
                        count = count + 1
                    end
                end)

                if count > 3 then
                    cell.state = "dead"
                elseif count == 3 then
                    cell.state = "alive"
                elseif count < 2 then
                    cell.state = "dead"
                end

            end
        }

        model.cs = CellularSpace{
            -- xdim is the obligatory parameter
            -- by default ydim is equal to xdim
            xdim = model.dim,
            instance = model.cell,
        }

        model.cs:createNeighborhood{wrap = true} -- attributes: strategy,self, wrap

        model.map = Map{
            target = model.cs,
            select = "state",
            value = {"dead", "alive"},
            color = {"white", "black"},
        }

        model.timer = Timer{
            Event{action = model.map},
            Event{action = model.cs},
        }

    end
}

GameOfLife:run()
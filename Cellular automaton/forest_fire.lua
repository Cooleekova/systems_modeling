--Random{seed = 1234567}

import("sysdyn")
import("calibration")


Fire = Model{
    dim = 50,
    finalTime = 200,
    empty = 0.5,
    init = function(model)
        model.cell = Cell{
            state = Random{forest = 1 - model.empty, empty = model.empty},
            --state = Random{forest = 0.70, empty = 0.30},
            execute = function(cell)
                if cell.state == "burning" then
                    cell.state = "burned"
                --[[
                if cell.state == "burning" and cell.past.state ~= "burning"  then
                    cell.state = "burning"
                elseif cell.past.state == "burning" and cell.state == "burning" then
                    cell.state = "burned"
                    --]]
                elseif cell.state == "forest" then
                    forEachNeighbor(cell, function(neighbor)
                        if neighbor.past.state == "burning" then
                            cell.state = "burning"
                            --[[
                            local burning_probability = Random{p = 0.9}
                            if burning_probability:sample() == true then
                                cell.state = "burning"
                            else
                                cell.state = "forest"
                            end
                            --]]
                            return false
                        end
                    end)
                end
            end}


        model.cs = CellularSpace{
            xdim = model.dim,
            instance = model.cell
        }

        model.chart = Chart{
            target = model.cs,
            select = {"state"},
            value = {"forest", "burning", "burned", "empty"},
            color = {"green", "red", "black", "gray"}
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
            endOfBurning = Event{start=50, period=10, action =function(endOfBurning)
                local burning = model.cs:split("state").burning

                if burning == nil then
                   print(endOfBurning:getTime())
                   model.timer:clear()
                   return false
                end
            end}
        }
    end
}


Fire:run()


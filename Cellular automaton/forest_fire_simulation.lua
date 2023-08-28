Random{seed = 1234567}

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
            --[[
            Event{start=100, period=10, action =function()
                local burning = model.cs:split("state").burning

                if burning == nil then
                   model.timer:clear()
                   return false
                end
            end} --]]
        }
    end
}


--Fire:run()


local m = MultipleRuns{
    model = Fire,
    showProgress = false,
    parameters = {
        empty = Choice{min = 0.0, max = 1, step = 0.1},
        --empty = Choice{min = 0.0, max = 0.99, step = 0.01},
    },
    forest = function(model)
		return model.cs:state().forest or 0
	end,
    burning = function(model)
		return model.cs:state().burning or 0
	end,
	burned = function(model)
		return model.cs:state().burned or 0
	end,
}

print(m.output)

-- [[
chart = Chart{
    target = m.output,
    select = {"forest", "burned"},
    --value = {"forest", "burning", "burned", "empty"},
    color = {"green", "black"},
    xAxis = "empty"

}
--]]


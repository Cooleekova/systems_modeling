--[[
Changing space to 100x100 cells.
Compare this result with the others
by assuming that four cells in this case occupy
the same space of one cell in the original model,
which means that the overall
area is the same in different resolutions.
--]]

Random{seed = 1234567}

import("sysdyn")
import("calibration")


Fire = Model{
    dim = 100,
    random = true,
    finalTime = 200,
    empty = 0.4,
    endOfBurning = 0,
    init = function(model)
        model.cell = Cell{
            state = Random{forest = 1 - model.empty, empty = model.empty},
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
            end}


        model.cs = CellularSpace{
            xdim = model.dim,
            instance = model.cell
        }

        -- select random cell to start fire
        model.cs:sample().state = "burning"

        model.cs:createNeighborhood{strategy = "vonneumann"}


        model.map = Map{
            target = model.cs,
            select = "state",
            grid = true,
            value = {"forest", "burning", "burned", "empty"},
            color = {"green", "red", "gray", "white"}
        }


        model.chart = Chart{
            target = model.cs,
            select = {"state"},
            value = {"forest", "burning", "burned", "empty"},
            color = {"green", "red", "black", "gray"}
        }

        model.timer = Timer{
            Event{action = model.map},
            Event{action = model.cs},
            endOfBurning = Event{action = function(endOfBurning)
                local burning = model.cs:split("state").burning

                if burning == nil then
                   model.endOfBurning = endOfBurning:getTime()
                   model.timer:clear()
                   return false
                end
            end}
        }
    end
}

local m = MultipleRuns{
    model = Fire,
    repetition = 10,
    parameters = {
        empty = Choice{min = 0.01, max = 0.99, step = 0.02}
    },
    forest = function(model)
		return model.cs:state().forest or 0
	end,
	burned = function(model)
		return model.cs:state().burned or 0
	end,
    fireDuration = function(model)
        return model.endOfBurning
    end,
    summary = function(result)
        local forest_sum = 0
        local time = 0
        local burned_sum = 0

        forEachElement(result.fireDuration, function(_, value)
            time = time + value
        end)

        forEachElement(result.forest, function(_, value)
            forest_sum = forest_sum + value
        end)

         forEachElement(result.burned, function(_, value)
            burned_sum = burned_sum + value
        end)

        return {averageForest = forest_sum / #result.forest,
                averageTime = time / #result.fireDuration,
                averageBurned = burned_sum / #result.burned
        }
    end
}


print("Quantity of simulations: "..#m.output.."")

chart1 = Chart{
    title = "Fire duration in time units",
    target = m.summary,
    select = {"averageTime"},
    color = {"gray"},
    xAxis = "empty"

}


chart2 = Chart{
    title = "The number of burned and survived cells",
    target = m.summary,
    select = {"averageBurned", "averageForest"},
    color = {"black", "green"},
    xAxis = "empty"

}

chart1:save("result_4_1.png")
chart2:save("result_4_2.png")


file = File("output_4.csv")
file:write(m.output, ";")

file = File("summary_4.csv")
file:write(m.summary, ";")
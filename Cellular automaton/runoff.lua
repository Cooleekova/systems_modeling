


Runoff = Model{
    finalTime = 100,
    rain = 1000, -- ml
    init = function(model)
        model.cell = Cell{
            water = 0,
            init = function(cell)
                if cell.height >= 200 then
                    cell.water = 1000
                end
            end,
            water5e3  = function(cell)
                if cell.water > 5e3 then
                    return 5e3
                else
                    return cell.water
                end
            end,
            on_synchronize = function(cell)
                cell.water = 0
            end,
            execute = function(cell)
                -- # An unary operator that return the length of the a string or a table.
                local count = #cell:getNeighborhood()
                local quantity = math.floor(cell.past.water / count)

                if count > 0 then
                    forEachNeighbor(cell, function(neighbor)
                        neighbor.water = neighbor.water + quantity
                    end)

                    cell.water = cell.water + cell.past.water - quantity * count
                end
            end
        }

        model.cs = CellularSpace{
            file = "cells200.shp",
            instance = model.cell,
            as = {height = "elevation"}
        }
        --[[
        model.chart = Chart{
            target = model.cs,
            select = "water"
        }
        --]]
        model.cs:createNeighborhood{
            strategy = "mxn",
            filter = function(cell, neigh)
                return cell.height >= neigh.height
            end
        }

        model.height_map = Map{
            target = model.cs,
            select = "height",
            color = "YlOrBr",
            slices = 8
        }

        model.rain_map = Map{
            target = model.cs,
            select = "water5e3",
            color = "Blues",
            min = 0,
            max = 5e3,
            slices = 10
        }

        model.timer = Timer{
            Event{action = model.height_map},
            Event{action = model.rain_map},
            Event{action = model.cs},
            --Event{action = model.chart}
        }

    end
}

Runoff:run()
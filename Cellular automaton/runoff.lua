


Runoff = Model{
    finalTime = 30,
    rain = 1000, -- ml
    init = function(model)
        model.cell = Cell{
            water = 0,
            init = function(cell)
                if cell.height >= 200 then
                    cell.water = 1000
                end
            end,
            execute = function(cell)
                -- # An unary operator that return the length of the a string or a table.
                local count = #cell:getNeighborhood()
                local quantity = math.floor(cell.water / count)

                forEachNeighbor(cell, function(neighbor)
                    neighbor.water = neighbor.water + quantity
                    cell.water = cell.water - quantity
                end)
            end
        }

        model.cs = CellularSpace{
            file = filePath("cabecadeboi.shp"),
            instance = model.cell
        }

        model.chart = Chart{
            target = model.cs,
            select = "water"
        }

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
            select = "water",
            color = "Blues",
            min = 0,
            max = 5e3,
            slices = 10
        }

        model.timer = Timer{
            Event{action = model.height_map},
            Event{action = model.rain_map},
            Event{action = model.cs},
            Event{action = model.chart}
        }

    end
}

Runoff:run()
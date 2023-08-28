

Deforestation = Model{
    demand = 10000, -- km2 per year
    finalTime = 2030,
    init = function(model)
        model.cell = Cell{
            potential = function(cell)
                local neigh_defor = 0

                -- count deforestation potential of each cell
                forEachNeighbor(cell, function(neigh)
                    neigh_defor = neigh_defor + neigh.deforestation
                end)

                neigh_defor = neigh_defor / #cell:getNeighborhood()
                cell.pot = neigh_defor - cell.deforestation
                if cell.pot < 0 then
                    cell.pot = 0
                end
            end
        }

        model.cs = CellularSpace{
            file = "C:\\Users\\user\\terrame-examples\\Tatiana\\Cellular automaton\\amazonia\\cell.shp",
            instance = model.cell,
            as = {deforestation = "prodes_10"},
            allocate = function()
                local trajectory = Trajectory{
                    target = model.cs,
                    select = function(cell)
                        return cell.pot > 0
                    end,
                    greater = function(cell1, cell2)
                        return cell1.pot > cell2.pot
                    end
                }

                local demand = model.demand

                while demand > 0 do
                    forEachCell(trajectory, function(cell)
                        cell.deforestation = cell.deforestation + cell.pot
                        demand = demand - cell.pot * cell:area() / 1e6 -- cell area is in meters

                        if demand <= 0 then return false end
                    end)
                    if demand > 0 then model.cs:potential() end
                end
            end
        }

        model.cs:createNeighborhood{}

        model.map = Map{
            target = model.cs,
            select = "deforestation",
            color = "RdYlGn",
            slices = 8,
            invert = true
        }

        model.timer = Timer{
            Event{start = 2010, action = model.map},
            Event{start = 2010, action = function()
                model.cs:potential()
                model.cs:allocate()
            end}
        }
    end
}


Deforestation:run()


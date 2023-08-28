--[[
Top-Down Model

Subcomponents:
1.Demand submodel
2.Transition potential submodel
3.Change allocation submodel (every year)


LookME
--]]


import("gis")

proj = Project{
    file = "C:\\Users\\user\\terrame-examples\\Tatiana\\Cellular automaton\\amazonia\\amazonia.qgs",
    clean = true,
    roads = filePath("amazonia-roads.shp", "gis"),
    ports = filePath("amazonia-ports.shp", "gis"),
    il = filePath("amazonia-indigenous.shp", "gis"),
    limit = filePath("amazonia-limit.shp", "gis"),
    prodes = filePath("amazonia-prodes.tif", "gis"),
}

cells = Layer{
    project = proj,
    file = "C:\\Users\\user\\terrame-examples\\Tatiana\\Cellular automaton\\amazonia\\cell.shp",
    resolution = 50000,
    clean = true,
    input = "limit",
    name = "cells"
}

cells:fill{
    attribute = "distRoads",
    operation = "distance",
    layer = "roads"
}

cells:fill{
    attribute = "il",
    operation = "area",
    layer = "il"
}

cells:fill{
    attribute = "distPorts",
    operation = "distance",
    layer = "ports"
}

cells:fill{
    attribute = "prodes",
    operation = "coverage",
    layer = "prodes"
}


cs = CellularSpace{
    file = "C:\\Users\\user\\terrame-examples\\Tatiana\\Cellular automaton\\amazonia\\cell.shp"
    }

Map{
    target = cs,
    select = "distRoads",
    color = "RdPu",
    slices = 8,
    invert = true
}


Map{
    target = cs,
    select = "il",
    color = "Purples",
    slices = 8
}


Map{
    target = cs,
    select = "distPorts",
    color = "Oranges",
    slices = 8,
    invert = true
}

Map{
    target = cs,
    select = "prodes_10",
    color = "RdYlGn",
    slices = 8,
    invert = true
}




import("gis")

project = Project{
    file = "runoff.qgs",
    clean = true
}

elevation = Layer{
    project = project,
    name = "elevation",
    epsg = 2311,
    file = filePath("cabecadeboi-elevation.tif", "gis")
}

box = Layer{
    project = project,
    name = "box",
    epsg = 2311,
    file = filePath("cabecadeboi-box.shp", "gis")
}


cells = Layer{
    project = project,
    name = "cells",
    input = "box",
    file = "cells.shp",
    resolution = 70,
    clean = true
}

cells:fill{
    layer = "elevation",
    attribute = "elevation",
    operation = "maximum",
    dummy = 256,
    pixel = "overlap"
}

dofile("epidemics.lua")

-- simulate the duration of desease 2, 4, 8 weeks

--[[
env1 = Environment{
    simulationTwoWeeks = SIR{duration=2},
    simulationFourWeeks = SIR{duration=4},
    simulationEightWeeks = SIR{duration=8}
}


chart = Chart{
    target = env1,
    select = "infected"
}
--]]

-- add chart to environment
-- env1:add(Event{action = chart})

-- env1:run()


-- simulate different levels of probability of being infected from high to low

--[[
env2 = Environment{
    simulationProbability50 = SIR{probability=0.5},
    simulationProbability40 = SIR{probability=0.4},
    simulationProbability30 = SIR{probability=0.3},
    simulationProbability12 = SIR{probability=0.125, finalTime=50}
}


chart = Chart{
    target = env2,
    select = "infected"
}

-- add chart to environment
env2:add(Event{action = chart})

env2:run()
--]]


-- simulate different numbers of treshold

env3 = Environment{
    simulationTreshhold1 = SIR{treshhold=1000},
    simulationTreshhold2 = SIR{treshhold=2000},
    simulationTreshhold5 = SIR{treshhold=5000}
}


chart1 = Chart{
    target = env3,
    select = "infected"
}

chart2 = Chart{
    target = env3,
    select = "susceptible"
}

-- add chart to environment
env3:add(Event{action = chart1})
env3:add(Event{action = chart2})

env3:run()
--]]
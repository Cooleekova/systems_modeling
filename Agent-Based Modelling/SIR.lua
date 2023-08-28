--[[
SIR: Susceptible, Infectious, Recovered
--]]

Random{seed = 742190}


ABMSIR = Model{
    population = 10000,
    infected = 2,
    finalTime = 30,  -- weeks
    duration = 2,
    probability = 0.25,
    contacts = 6,
    init = function(model)
        model.agent = Agent{
            state = "susceptible",
            getInfected = function(agent)
                agent.state = "infected"
                agent.sickness_duration = 0
            end,

            execute = function(agent)
                if agent.state == "susceptible" then
                    forEachConnection(agent, function(connection)
                        if connection.state == "infected" and Random{p = model.probability}:sample() then
                            agent:getInfected()
                            return false
                        end
                    end
                )

                elseif agent.state == "infected" then
                    agent.sickness_duration = agent.sickness_duration + 1

                    if agent.sickness_duration >= model.duration then
                        agent.state = "recovered"

                    end
                end
            end
        }


    model.society = Society{
        instance = model.agent,
        quantity = model.population
    }

    model.society:createSocialNetwork{
        --strategy="quantity",
        quantity = model.contacts,
        inmemory = false

    }

    model.society:sample():getInfected()
    model.society:sample():getInfected()


    model.chart = Chart{
        target = model.society,
        select = "state",
        value = {"susceptible", "infected", "recovered"},
        color = {"green", "red", "blue"}
    }

    model.timer = Timer{
        Event{action = model.chart},
        Event{action = model.society},
        Event{action = function()
            local split = model.society:split("state")

            local infected = 0
            if split.infected then
                infected = #split.infected end

            local recovered = 0
            if split.recovered then
                recovered = #split.recovered end

            local susceptible = 0
            if split.susceptible then
                susceptible = #split.susceptible end

            print(susceptible, infected, recovered)
            --forEachElement(split, function(name, group)
                --print(name, #group)
            --end)
            print("")


        end},

        }

    end
}


ABMSIR:run()





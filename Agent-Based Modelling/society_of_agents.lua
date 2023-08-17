Random{seed=497285}



WalkersSociety = Model{
    finalTime = 50,
    init = function(model)
        model.agent = Agent{
            -- agent is being born with age = 0
            age = 0,
            execute = function(agent)

                -- to simulate population growth:
                local oldcell = agent:getCell()
                agent:walkToEmpty()
                local newcell = agent:getCell()

                if oldcell ~= newcell then
                    local newagent = agent:reproduce()
                    newagent:move(oldcell)
                end

                agent.age = agent.age + 1

                if agent.age == 2 then
                    agent:die()
                end

                --to move agent we can use these options:
                --agent:walk()
                --agent:walkToEmpty()
            end
        }

        model.soc = Society{
            instance = model.agent,
            quantity = 10
        }

        model.chart = Chart{
            target = model.soc
        }

        model.cell = Cell{
            state = function(cell)
                if cell:isEmpty() then
                    return "empty"
                elseif #cell:getAgents() == 1 then
                    return "one"
                else
                    return "morethanone"
                end
            end
        }

        model.cs = CellularSpace{
            xdim = 60,
            instance = model.cell
        }

        model.cs:createNeighborhood()


        model.env = Environment{
            model.soc,
            model.cs
        }

        model.env:createPlacement{max=1} -- default is "random"

          model.map = Map{
            target = model.cs,
            select = "state",
            grid = true,
            value = {"empty", "one", "morethanone"},
            color = {"white", "black", "red"}
        }

        model.timer = Timer{
            Event{period = 1, action = model.soc},
            Event{action = model.map},
            Event{action = model.chart}
        }
    end
}


WalkersSociety:run()
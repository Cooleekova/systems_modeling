--[[
Stocks: susceptible, infected, recovered
Initial stocks: susceptible = 9998, infected = 2
dt = 1 week
Run time = 30 weeks
Duration of an infection = 2 weeks
Each infected comes into contact with 6 other people
25% of the contacts are enough to cause infection
--]]

SIR = Model{
    susceptible = 9998, -- STOCK
    infected = 2, -- STOCK
    recovered = 0, -- STOCK
    contacts = 6,
    probability = 0.25,
    duration = 2, -- weeks
    treshhold = 1000, -- number of people got affected as the reason to start quarantine
    finalTime  = 60, -- weeks
    init = function(model)
        --[[model.chart = Chart{
            target = model,
            select = {"susceptible", "infected", "recovered"},
            color = {"blue", "red", "green"}
        }--]]
        model.Timer = Timer{
            Event{action = function()
                 if model.infected >= model.treshhold then
                    model.contacts = model.contacts / 2
                    return false
                 end
            end},
            -- Event{action = model.chart},
            Event{action = function()
                -- positive feedback
                local newrecovered = model.infected / model.duration
                local propsusceptible = model.susceptible / 1e4
                -- negative feedback
                local newinfected = model.infected * model.contacts * model.probability * propsusceptible



                -- newrecovered = math.floor(newrecovered)
                -- newinfected = math.floor(newinfected)


                model.recovered = model.recovered + newrecovered
                model.infected = model.infected + newinfected- newrecovered
                model.susceptible = model.susceptible - newinfected
            end}
        }
    end
 }

SIR:run()


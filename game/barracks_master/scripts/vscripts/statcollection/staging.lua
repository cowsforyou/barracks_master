-- This exposes the stages and can be used to send custom requests to secondary locations
local bmPost = 'https://barracksmaster.herokuapp.com/'

function statCollection:Stage1(payload)

end

function statCollection:Stage2(payload)

end

function statCollection:Stage3(payload)

end

function statCollection:StageCustom(payload)

end

function statCollection:sendBMPost()
    local payload = {
        dotaMatchID = tostring(GameRules:GetMatchID()),
        duration = GameRules:GetDOTATime(false, false),
        winner = statCollection.winner,
        players = BuildPlayersArray(),
    }

    print("Sending BM Post Game stats")
    
    -- Send custom to bm
    self:sendStage('new_match', payload, function(err, res)
         -- Check if we got an error
        if self:ReturnedErrors(err, res) then
            statCollection:print("Error on sendBMPost " .. bmPost)
            return
        end

        -- Tell the user
        statCollection:print(prefix .. messageCustomComplete .. " [" .. bmPost .. ']')
    end, bmPost)
end
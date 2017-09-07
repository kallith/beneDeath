beneDeath = CreateFrame("Frame", nil,nil)
beneDeath:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
beneDeath:RegisterEvent("CHAT_MSG_MONSTER_YELL")
beneDeath:RegisterEvent("QUEST_LOG_UPDATE")

local number_dead = 0
local wave_number = 0
local wave_size = 12
local on_quest = false
local prev_num_quest = 99

beneDeath:SetScript("OnEvent", function()
    if event == "CHAT_MSG_COMBAT_HOSTILE_DEATH" and on_quest then
        -- arg1: "%s dies."
        if arg1 == string.format(UNITDIESOTHER,"Plagued Peasant") or arg1 == string.format(UNITDIESOTHER, "Injured Peasant")  then
            number_dead = number_dead + 1
            DEFAULT_CHAT_FRAME:AddMessage("You have failed " .. number_dead .. "/15 peasants.",1,0,0)
            if number_dead >= 13 and number_dead < 15 then
                SendChatMessage("RESET","YELL")
                SendChatMessage("RESET THERE HAVE " .. number_dead .. " PEASANTS DIED.","YELL")
            end
        end
    elseif event == "CHAT_MSG_MONSTER_YELL" and on_quest then
        --arg1: Message
        --arg2: NPC name
        if arg2 == "Plagued Peasant" then
            wave_size = 12
            wave_number = wave_number + 1
            if wave_number == 4 then
                wave_size = 13
            elseif wave_number == 5 then
                wave_size = 16
            end
            DEFAULT_CHAT_FRAME:AddMessage("Wave " .. wave_number .. "/5, containing " .. wave_size .. " peasants.",0,1,0)
        end
    elseif event == "QUEST_LOG_UPDATE" then
        local _,cur_num_quests = GetNumQuestLogEntries();
        number_dead = 0
        wave_number = 0
        on_quest = cur_num_quests > prev_num_quest
        prev_num_quest = cur_num_quests
        if on_quest then
            DEFAULT_CHAT_FRAME:AddMessage("Tracking deaths/waves");
        end
    end
end)

//
// lua\Survivor_Server.lua
//
//    Created by:   Lassi lassi@heisl.org
//

// RandomizeAliensServer.lua

Script.Load("lua/Server.lua")
Print "Server VM"
//load the shared script
Script.Load("lua/Survivor_Shared.lua")

Script.Load("lua/Survivor_Team.lua")
Script.Load("lua/Survivor_AlienTeam.lua")
Script.Load("lua/Survivor_MarineTeam.lua")
Script.Load("lua/Survivor_Skulk_Server.lua")


kHumanPointsPerSec = 1


    local totalserverupdatetime = 0.0  
 
    local function h_UpdateServer(deltaTime)
        totalserverupdatetime = totalserverupdatetime + deltaTime        
        if((totalserverupdatetime % 1) < deltaTime) then//1 sec passed in this delta   
        
            //Add Score for Humans (ISSUE #1)
            if GetGamerules():GetGameState() == kGameState.Started then
                local h_team = GetGamerules():GetTeam(kTeam1Index)             
                playerlist = h_team:GetPlayers()
                table.foreach(playerlist,
                    function(_index)
                        if(playerlist[_index]:GetIsAlive()) then 
                            playerlist[_index]:AddScore(kHumanPointsPerSec,0)                             
                        end
                    end
                )
            end            
            
        end //end sec.
        
    end
    Event.Hook("UpdateServer", h_UpdateServer)
    





local function postServerMsg(player, message)
    local locationId = -1
    
    Server.SendNetworkMessage(player, "Chat", BuildChatMessage(true, "Server", locationId, player:GetTeamNumber(), kNeutralTeamType, message), true)
end

local function OnClientConnect(client)
    local player = client:GetControllingPlayer()
    local welcomeMsg = "Hello %s welcome to Survivor!"
    welcomeMsg = string.format(welcomeMsg, player:GetName())
    
    postServerMsg(player, "#")
    postServerMsg(player, welcomeMsg)
end

Event.Hook("ClientConnect", OnClientConnect)
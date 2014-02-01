//
//      Survivor_Player_Server.lua
//
//      created by:  MetaMind09    (Simon Hiller_ andante09@gmx.de)
//



local function UpdateChangeToSpectator(self)

    if not self:GetIsAlive() and not self:isa("Spectator") then
    
        local time = Shared.GetTime()
        if self.timeOfDeath ~= nil and (time - self.timeOfDeath > kFadeToBlackTime) then
        
            // Destroy the existing player and create a spectator in their place (but only if it has an owner, ie not a body left behind by Phantom use)
            local owner = Server.GetOwner(self)
            if owner then
            
                // Queue up the spectator for respawn.

                //let a dead players spawn as alien
                    //local spectator = self:Replace(self:GetDeathMapName())                
                local spectator = self:Replace(self:GetDeathMapName(), kAlienTeamType)                 
                //Let Marine spawn without IP and Aliens without eggs (ISSUE #2)
                    //spectator:GetTeam():PutPlayerInRespawnQueue(spectator)
                spectator:GetTeam():ReplaceRespawnPlayer(spectator)  

            end
            
        end
        
    end
    
end


function Player:ReplaceRespawn()
    return self:GetTeam():ReplaceRespawnPlayer(self, nil, nil)
end


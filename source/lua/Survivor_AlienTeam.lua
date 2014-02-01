//
// lua\Survivor_AlienTeam.lua
//
//    Created by:   Lassi lassi@heisl.org
//

//don't spwan initail structures at game start
function AlienTeam:SpawnInitialStructures(techPoint) 
    return nil, nil 
end

function AlienTeam:GetHasAbilityToRespawn() 
    return true 
end

local function respawnNow(queuedPlayer)
    //local tps = Shared.GetEntitiesWithClassname("TechPoint")
    local rps = GetAvailableResourcePoints();
    
    if (table.count(rps) > 0) then
        local resourcePointRandomizer = Randomizer()
        resourcePointRandomizer:randomseed(Shared.GetSystemTime())
        local selectedSpawn = resourcePointRandomizer:random(1, #rps)
        
        local spawnOrigin = Vector(rps[selectedSpawn]:GetOrigin()) + Vector(0.01, 0.2, 0)
        local team = queuedPlayer:GetTeam()
        local success, player = team:ReplaceRespawnPlayer(queuedPlayer, spawnOrigin, queuedPlayer:GetAngles()) 
        //local success, player = team:ReplaceRespawnPlayer(queuedPlayer, nil, nil) 
        
        if (success) then 
            //give the newborn skulk it's upgrade
            player:GiveUpgrade(kTechId.Leap)
            DestroyEntity(queuedPlayer)
        end
    end
end

function AlienTeam:Update(timePassed)

    PROFILE("AlienTeam:Update")
    
    PlayingTeam.Update(self, timePassed)
    
    self:UpdateTeamAutoHeal(timePassed)
    //UpdateEggGeneration(self)
    //UpdateEggCount(self)
    //UpdateAlienSpectators(self)
    //self:UpdateBioMassLevel()
    //respawnAll(PlayingTeam)
    
    local shellLevel = GetShellLevel(self:GetTeamNumber())  
    for index, alien in ipairs(GetEntitiesForTeam("Alien", self:GetTeamNumber())) do
        alien:UpdateArmorAmount(shellLevel)
        alien:UpdateHealthAmount(math.min(12, self.bioMassLevel), self.maxBioMassLevel)
    end
    
    for index, queuedPlayer in ipairs(self:GetSortedRespawnQueue()) do
        self:RemovePlayerFromRespawnQueue(queuedPlayer)
        respawnNow(queuedPlayer)
    end
    
    //UpdateCystConstruction(self, timePassed)
    
end

local function UpdateAlienSpectators(self)

    if self.timeLastSpectatorUpdate == nil then
        self.timeLastSpectatorUpdate = Shared.GetTime() - 1
    end

    if self.timeLastSpectatorUpdate + 1 <= Shared.GetTime() then

        local alienSpectators = self:GetSortedRespawnQueue()
        local enemyTeamPosition = GetCriticalHivePosition(self)
        
        for i = 1, #alienSpectators do
        
            local alienSpectator = alienSpectators[i]
            // Do not spawn players waiting in the auto team balance queue.
            if alienSpectator:isa("AlienSpectator") and not alienSpectator:GetIsWaitingForTeamBalance() then
            
                // Consider min death time.
                if alienSpectator:GetRespawnQueueEntryTime() + kAlienSpawnTime < Shared.GetTime() then
                
                  //let aliens spawn without eggs (ISSUE #2)
                  GetGamerules():RespawnPlayer(alienSpectator)

                  /*
                    local egg = nil
                    if alienSpectator.GetHostEgg then
                        egg = alienSpectator:GetHostEgg()
                    end
                    
                    // Player has no egg assigned, check for free egg.
                    if egg == nil then
                    
                        local success = AssignPlayerToEgg(self, alienSpectator, enemyTeamPosition)
                        
                        // We have no eggs currently, makes no sense to check for every spectator now.
                        if not success then
                            break
                        end
                        
                    end */
                    
                end
                
            end
            
        end
    
        self.timeLastSpectatorUpdate = Shared.GetTime()

    end
    
end
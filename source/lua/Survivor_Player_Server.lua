function Player:OnUpdatePlayer(deltaTime)

    UpdateChangeToSpectator(self)
    
    local gamerules = GetGamerules()
    self.gameStarted = gamerules:GetGameStarted()
    if self:GetTeamNumber() == kTeam1Index or self:GetTeamNumber() == kTeam2Index then
        self.countingDown = gamerules:GetCountingDown()
    else
        self.countingDown = false
    end
    
//Set Marine Weapon OnFlames
    
    if self:GetIsAlive() and self:GetTeamNumber() == kTeam1Index then   
        if (self.Kills_in_row and self.Kills_in_row >= 3) then
            self:GetActiveWeapon():SetOnFire(3)
        elseif (self.Kills_in_row and self.Kills_in_row >= 2) then
            self:GetActiveWeapon():SetOnFire(2)
        elseif (self.Kills_in_row and self.Kills_in_row >= 1) then
            self:GetActiveWeapon():SetOnFire(1)
        else
            //self:GetActiveWeapon():SetOnFire(1)
        end        
    end
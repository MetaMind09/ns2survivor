//
//      Survivor_ScoringMixin.lua
//
//      created by:  MetaMind09    (Simon Hiller_ andante09@gmx.de)
//


function ScoringMixin:ResetScores()

    self.kills = 0
    self.assistkills = 0
    self.deaths = 0    
    self:SetScoreboardChanged(true)
    
    self.commanderTime = 0
    self.playTime = 0
    self.marineTime = 0
    self.alienTime = 0

end
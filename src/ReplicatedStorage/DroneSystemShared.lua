
local CollectionService = game:GetService('CollectionService')

-- // Module // --
local Module = {}

function Module:IsDroneBusy( DroneModel )
	return DroneModel:GetAttribute('IsBusy')
end

function Module:CanPlayerControlDrone( LocalPlayer, DroneModel )
	local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid')
	return Humanoid and Humanoid.Health > 0 and (not Module:IsDroneBusy( DroneModel ))
end

function Module:CanPlayerSpawnDrone( LocalPlayer )
	return #CollectionService:GetTagged('DroneModel') < 5
end

return Module

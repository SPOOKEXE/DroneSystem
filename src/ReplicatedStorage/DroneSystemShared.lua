
-- // Module // --
local Module = {}

function Module:IsDroneBusy( DroneModel )
	return DroneModel:GetAttribute('IsBusy')
end

function Module:CanPlayerControlDrone( LocalPlayer, DroneModel )
	local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid')
	return Humanoid and Humanoid.Health > 0 and (not Module:IsDroneBusy( DroneModel ))
end

return Module

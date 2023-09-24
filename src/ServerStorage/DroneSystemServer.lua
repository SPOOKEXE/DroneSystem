
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DroneSystemShared = require(ReplicatedStorage:WaitForChild("DroneSystemShared"))

local DroneEvent = Instance.new('RemoteEvent')
DroneEvent.Name = 'DroneEvent'
DroneEvent.Parent = ReplicatedStorage
local DroneFunction = Instance.new('RemoteFunction')
DroneFunction.Name = 'DroneFunction'
DroneFunction.Parent = ReplicatedStorage

-- // Module // --
local Module = {}

function Module:AttemptDroneAccess( LocalPlayer, DroneInstance )

end

function Module:Start()

	DroneEvent.OnServerEvent:Connect(function(LocalPlayer, Job, ...)
		local Args = {...}

	end)

	DroneFunction.OnServerInvoke = function(LocalPlayer, Job, ...)
		local Args = {...}

		return false, 'Invalid Job.'
	end

end

return Module


local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer

local PlayerModule = require(LocalPlayer:WaitForChild('PlayerScripts'):WaitForChild('PlayerModule'))
local Controls = PlayerModule:GetControls()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DroneSystemShared = require(ReplicatedStorage:WaitForChild("DroneSystemShared"))

local CurrentCamera = workspace.CurrentCamera

-- // Module // --
local Module = {}

function Module:EnableMovement()
	Controls:Enable()
end

function Module:DisableMovement()
	Controls:Disable()
end

function Module:Start()

end

return Module

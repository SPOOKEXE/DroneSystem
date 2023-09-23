
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DroneSystemShared = require(ReplicatedStorage:WaitForChild("DroneSystemShared"))

local DroneSystemClient = require( script.Parent:WaitForChild('DroneSystemClient') )
DroneSystemClient:Start()


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DroneSystemShared = require(ReplicatedStorage:WaitForChild("DroneSystemShared"))

local ServerStorage = game:GetService('ServerStorage')
local DroneSystemServer = require( ServerStorage:WaitForChild('DroneSystemServer') )
DroneSystemServer:Start()

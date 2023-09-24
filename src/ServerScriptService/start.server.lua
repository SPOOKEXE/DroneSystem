
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DroneSystemShared = require(ReplicatedStorage:WaitForChild("DroneSystemShared"))

local ServerStorage = game:GetService('ServerStorage')
local DroneSystemServer = require( ServerStorage:WaitForChild('DroneSystemServer') )
DroneSystemServer:Start()

--[[
	local CollectionService = game:GetService("CollectionService")
	local Drones = CollectionService:GetTagged('DroneModel')

	for i = 0, 5, 0.015 do
		for _, Drone in ipairs( Drones ) do
			Drone:SetAttribute('VerticalSpeed', i)
		end
		task.wait()
	end

	task.wait(3)

	for i = 5, 0, -0.015 do
		for _, Drone in ipairs( Drones ) do
			Drone:SetAttribute('VerticalSpeed', i)
		end
		task.wait()
	end
]]

--[[
	for i = 0, 5, 0.015 do
		workspace.Drone:SetAttribute('VerticalSpeed', i)
		task.wait()
	end

	task.wait(3)

	for i = 5, 0, -0.015 do
		workspace.Drone:SetAttribute('VerticalSpeed', i)
		task.wait()
	end
]]

local CollectionService = game:GetService('CollectionService')
local ContextActionService = game:GetService('ContextActionService')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')

local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer

local DroneUI = LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('DroneUI')
DroneUI.Enabled = false

local PlayerModule = require(LocalPlayer:WaitForChild('PlayerScripts'):WaitForChild('PlayerModule'))
local Controls = PlayerModule:GetControls()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DronesAssetFolder = ReplicatedStorage:WaitForChild('Drones')
local MaidClassModule = require(ReplicatedStorage:WaitForChild('Maid'))
local DroneSystemShared = require(ReplicatedStorage:WaitForChild("DroneSystemShared"))

local DroneEvent = ReplicatedStorage:WaitForChild('DroneEvent')
local DroneFunction = ReplicatedStorage:WaitForChild('DroneFunction')

local CurrentCamera = workspace.CurrentCamera

local ROTATIONS_PER_SECOND = (20 * 360)
local MAXIMUM_VERTICAL_SPEED = 5
local MAXIMUM_HORIZONTAL_SPEED = 12
local HOVER_VERTICAL_SPEED = 3

local ACTIVE_DRONE_MODEL = false
local ACTIVE_DRONE_MAID = MaidClassModule.New()
local ACTIVE_VERTICAL_SPEED = 0
local ACTIVE_HORIZONTAL_SPEED = 0
local ACTIVE_ROTATION = 0

local DroneMaidCache = { }

local DroneKeyCodes = {
	Enum.KeyCode.A, Enum.KeyCode.W, Enum.KeyCode.D, Enum.KeyCode.S,
	Enum.KeyCode.Q, Enum.KeyCode.E,
	Enum.KeyCode.F
}

-- // Module // --
local Module = {}

function Module:EnableMovement()
	Controls:Enable()
end

function Module:DisableMovement()
	Controls:Disable()
end

function Module:RegisterKeybinds()

	ContextActionService:BindAction('DroneKeybinds', function(actionName, inputState, inputObject)
		if actionName == 'DroneKeybinds' then

			return Enum.ContextActionResult.Sink
		end
		return Enum.ContextActionResult.Pass
	end, false, unpack(DroneKeyCodes))

end

function Module:ReleaseKeybinds()

end

function Module:OpenDroneController( DroneInstance )

	print( 'Enable Drone Controller: ', DroneInstance:GetFullName() )

	Module:DisableMovement()
	Module:RegisterKeybinds()

	DroneUI.Enabled = true

	ACTIVE_VERTICAL_SPEED = 0
	ACTIVE_HORIZONTAL_SPEED = 0
	ACTIVE_ROTATION = 0

	CurrentCamera.CameraSubject = DroneInstance.Span

	--CurrentCamera.CameraType = Enum.CameraType.Scriptable
	ACTIVE_DRONE_MODEL = DroneInstance

	--[[
		local AlignAttachment = Instance.new('Attachment')
		AlignAttachment.Visible = true
		AlignAttachment.Parent = DroneInstance.Span
		local Att2 = Instance.new('Attachment')
		Att2.Visible = true
		Att2.Position = Vector3.new(0, 0.01, 0)
		Att2.Parent = DroneInstance.Span

		local AntiGravity = Instance.new('VectorForce')
		AntiGravity.Name = 'AntiGrav'
		AntiGravity.Force = Vector3.new(0, 3560, 0)
		AntiGravity.Attachment0 = AlignAttachment
		AntiGravity.Enabled = true
		AntiGravity.Parent = AlignAttachment

		local YForce = Instance.new('VectorForce')
		YForce.Enabled = true
		YForce.Attachment0 = AlignAttachment
		YForce.RelativeTo = Enum.ActuatorRelativeTo.World
		YForce.Parent = AlignAttachment
	]]

	--[[
		local AlignPosition = Instance.new('AlignPosition')
		AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
		AlignPosition.MaxVelocity = 50
		AlignPosition.Visible = true
		AlignPosition.MaxForce = 9999999
		AlignPosition.Attachment0 = AlignAttachment
		AlignPosition.Parent = AlignAttachment
		local AlignOrientation = Instance.new('AlignOrientation')
		AlignOrientation.CFrame = DroneInstance.Span.CFrame
		AlignOrientation.Attachment0 = AlignAttachment
		AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
		AlignOrientation.MaxTorque = 9999
		AlignOrientation.MaxAngularVelocity = 2
		AlignOrientation.Parent = AlignAttachment
	]]

	ACTIVE_DRONE_MAID:Give(RunService.RenderStepped:Connect(function(deltaTime)
		if UserInputService:IsKeyDown( Enum.KeyCode.Q ) then
			ACTIVE_VERTICAL_SPEED += 1 * deltaTime
		elseif UserInputService:IsKeyDown( Enum.KeyCode.E ) then
			ACTIVE_VERTICAL_SPEED -= 2 * deltaTime
		end

		if ACTIVE_VERTICAL_SPEED >= HOVER_VERTICAL_SPEED then
			if not UserInputService:IsKeyDown( Enum.KeyCode.Q ) then
				ACTIVE_VERTICAL_SPEED *= 0.995
			end
			ACTIVE_VERTICAL_SPEED = math.clamp( ACTIVE_VERTICAL_SPEED, HOVER_VERTICAL_SPEED, MAXIMUM_VERTICAL_SPEED )
		end

		-- horizontal
		local ForwardMultiply = UserInputService:IsKeyDown( Enum.KeyCode.W ) and -1 or UserInputService:IsKeyDown( Enum.KeyCode.S ) and 1 or 0
		ACTIVE_HORIZONTAL_SPEED += ForwardMultiply
		if ForwardMultiply == 0 then
			ACTIVE_HORIZONTAL_SPEED *= 0.99
		end
		ACTIVE_HORIZONTAL_SPEED = math.min( ACTIVE_HORIZONTAL_SPEED, MAXIMUM_HORIZONTAL_SPEED ) * math.sign( ACTIVE_HORIZONTAL_SPEED )
 
		--[[
			local DestinationPosition = DroneInstance.Span.Position

			local XZLookVector = DroneInstance.Span.CFrame.LookVector * Vector3.new(1, 0, 1)
			DestinationPosition += ( XZLookVector * ACTIVE_HORIZONTAL_SPEED )

			-- vertical
			local YDelta = (ACTIVE_VERTICAL_SPEED - HOVER_VERTICAL_SPEED) * 2
			DestinationPosition += Vector3.new(0, YDelta , 0)

			local Direction = DestinationPosition.Y > DroneInstance.Span.Position.Y and 1 or 1
			YForce.Force = Vector3.new(0, ACTIVE_VERTICAL_SPEED * Direction, 0)
		]]

		-- rotation
		local Rotation = UserInputService:IsKeyDown( Enum.KeyCode.A ) and 1 or UserInputService:IsKeyDown( Enum.KeyCode.D ) and -1 or 0
		ACTIVE_ROTATION += Rotation
		ACTIVE_ROTATION %= 360
		-- AlignOrientation.CFrame = CFrame.Angles(0, math.rad(ACTIVE_ROTATION), 0)

		-- position
		-- AlignPosition.Position = DestinationPosition

		DroneInstance:SetAttribute('VerticalSpeed', ACTIVE_VERTICAL_SPEED)
		--CurrentCamera.CFrame = DroneInstance.Camera.CFrame
	end))

end

function Module:CloseDroneController()

	local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid')
	CurrentCamera.CameraType = Enum.CameraType.Custom
	CurrentCamera.CameraSubject = Humanoid or LocalPlayer.Character

	DroneUI.Enabled = false
	ACTIVE_DRONE_MAID:Cleanup()

end

function Module:RegisterDroneInstance( DroneModel )
	DroneModel:SetAttribute('VerticalSpeed', 0)

	local DroneBlades = {
		[DroneModel.Span.FL_Blade] = DronesAssetFolder.Parts.Blade:Clone(),
		[DroneModel.Span.FR_Blade] = DronesAssetFolder.Parts.Blade:Clone(),
		[DroneModel.Span.BL_Blade] = DronesAssetFolder.Parts.Blade:Clone(),
		[DroneModel.Span.BR_Blade] = DronesAssetFolder.Parts.Blade:Clone(),
	}

	for Attachment, BladeMesh in pairs( DroneBlades ) do
		DroneModel.Span.BladeSpin.Volume = 0
		DroneModel.Span.BladeSpin.PlaybackSpeed = 0.1
		DroneModel.Span.BladeSpin.Playing = true
		BladeMesh.Position = Attachment.WorldPosition
		BladeMesh.Parent = DroneModel
	end

	local Maid = MaidClassModule.New()

	Maid:Give(RunService.RenderStepped:Connect(function(deltaTime)
		local VerticalSpeed = DroneModel:GetAttribute('VerticalSpeed') or 0
		local RotationDelta = math.clamp(VerticalSpeed / MAXIMUM_VERTICAL_SPEED, 0.1, 5)
		local RotationStep = RotationDelta * ROTATIONS_PER_SECOND * deltaTime

		DroneModel.Span.BladeSpin.PlaybackSpeed = 1.5 + (5 * (VerticalSpeed / MAXIMUM_VERTICAL_SPEED))
		DroneModel.Span.BladeSpin.Volume = 0.001 + (0.1 * (VerticalSpeed / MAXIMUM_VERTICAL_SPEED))
		for Attachment, BladeMesh in pairs( DroneBlades ) do
			local Direction = string.sub(Attachment.Name, 2, 2) == 'L' and 1 or -1
			BladeMesh.CFrame *= CFrame.Angles( 0, math.rad(RotationStep * Direction), 0 )
			BladeMesh.Position = Attachment.WorldPosition
		end
	end))

	Maid:Give(function()
		DroneModel.Span.BladeSpin.Playing = false
		for Attachment, BladeMesh in pairs( DroneBlades ) do
			BladeMesh:Destroy()
			DroneBlades[Attachment] = nil
		end
	end)

	DroneMaidCache[ DroneModel ] = Maid
end

function Module:UnregisterDroneInstance( DroneModel )

	if DroneMaidCache[ DroneModel ] then
		DroneMaidCache[ DroneModel ]:Cleanup()
	end
	DroneMaidCache[ DroneModel ] = nil

end

function Module:Start()

	for _, Model in ipairs( CollectionService:GetTagged('DroneModel') ) do
		task.spawn(function()
			Module:RegisterDroneInstance( Model )
		end)
	end

	CollectionService:GetInstanceAddedSignal('DroneModel'):Connect(function(Model)
		Module:RegisterDroneInstance( Model )
	end)

	CollectionService:GetInstanceRemovedSignal('DroneModel'):Connect(function(Model)
		Module:UnregisterDroneInstance( Model )
	end)

	-- test setup
	UserInputService.InputBegan:Connect(function(inputObject, wasProcessed)
		if inputObject.KeyCode == Enum.KeyCode.K and not wasProcessed then
			if ACTIVE_DRONE_MODEL then
				Module:CloseDroneController( )
			else
				Module:OpenDroneController( workspace.Drone )
			end
		end
	end)
end

return Module

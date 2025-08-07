local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local flying = false
local baseSpeed = 50
local speedMultiplier = 1
local bv, bg

local control = {
    F = 0,
    B = 0,
    L = 0,
    R = 0,
    Up = 0,
    Down = 0
}

local function startFly()
    bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.zero
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.P = 1250
    bv.Parent = hrp

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    bg.P = 10000
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp

    flying = true
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)

    RunService.RenderStepped:Connect(function()
        if flying then
            local cam = workspace.CurrentCamera
            local moveVec =
                (control.F - control.B) * cam.CFrame.LookVector +
                (control.R - control.L) * cam.CFrame.RightVector +
                (control.Up - control.Down) * Vector3.new(0, 1, 0)

            if moveVec.Magnitude > 0 then
                bv.Velocity = moveVec.Unit * baseSpeed * speedMultiplier
            else
                bv.Velocity = Vector3.zero
            end

            bg.CFrame = cam.CFrame
        end
    end)
end

local function stopFly()
    flying = false
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end

    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    
  
    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    task.wait(0.1)
    humanoid:ChangeState(Enum.HumanoidStateType.Running)
end

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    local key = input.KeyCode

    if key == Enum.KeyCode.F then
        if flying then stopFly() else startFly() end
        flyToggle.Text = flying and "날기 끄기 (F)" or "날기 켜기 (F)"
    elseif key == Enum.KeyCode.W then
        control.F = 1
    elseif key == Enum.KeyCode.S then
        control.B = 1
    elseif key == Enum.KeyCode.A then
        control.L = 1
    elseif key == Enum.KeyCode.D then
        control.R = 1
    elseif key == Enum.KeyCode.E then
        control.Up = 1
    elseif key == Enum.KeyCode.Q then
        control.Down = 1
    elseif key == Enum.KeyCode.LeftShift then
        speedMultiplier = 2
    end
end)

UIS.InputEnded:Connect(function(input, gpe)
    if gpe then return end

    local key = input.KeyCode

    if key == Enum.KeyCode.W then
        control.F = 0
    elseif key == Enum.KeyCode.S then
        control.B = 0
    elseif key == Enum.KeyCode.A then
        control.L = 0
    elseif key == Enum.KeyCode.D then
        control.R = 0
    elseif key == Enum.KeyCode.E then
        control.Up = 0
    elseif key == Enum.KeyCode.Q then
        control.Down = 0
    elseif key == Enum.KeyCode.LeftShift then
        speedMultiplier = 1
    end
end)

local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyToggleGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local flyToggle = Instance.new("TextButton")
flyToggle.Name = "FlyToggleButton"
flyToggle.Size = UDim2.new(0, 120, 0, 30)
flyToggle.Position = UDim2.new(0, 10, 0, 10)
flyToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyToggle.TextColor3 = Color3.new(1, 1, 1)
flyToggle.Text = "날기 켜기 (F)"
flyToggle.Font = Enum.Font.SourceSans
flyToggle.TextSize = 18
flyToggle.AutoButtonColor = true
flyToggle.Parent = screenGui

flyToggle.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
        flyToggle.Text = "날기 켜기 (F)"
    else
        startFly()
        flyToggle.Text = "날기 끄기 (F)"
    end
end)

-- [[ Nexus AI - Race Horses Automation & Helper System ]] --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- UI & Flags
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RaceHorsesHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 310)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "🏇 Race Horses - Nexus AI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local AutoTrain = false
local AutoRace = false
local AutoHatch = false
local AutoFeed = false

local function createToggle(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.Text = name .. ": [OFF]"
    btn.Parent = MainFrame
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. ": [" .. (state and "ON" or "OFF") .. "]"
        btn.BackgroundColor3 = state and Color3.fromRGB(46, 139, 87) or Color3.fromRGB(50, 50, 60)
        btn.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        callback(state)
    end)
    return btn
end

-- Toggle Buttons Layout
createToggle("⚡ Auto Train / Click", 40, function(v)
    AutoTrain = v
end)

createToggle("🏆 Auto Join Race", 78, function(v)
    AutoRace = v
end)

createToggle("🥚 Auto Hatch Egg", 116, function(v)
    AutoHatch = v
end)

createToggle("🍎 Auto Use / Feed Items", 154, function(v)
    AutoFeed = v
end)

createToggle("💨 Boost Speed (+50)", 192, function(v)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = v and 66 or 16
    end
end)

-- Background Loops
task.spawn(function()
    while task.wait(0.1) do
        local remotes = ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage
        
        -- 1. Auto Training Loop
        if AutoTrain then
            pcall(function()
                local trainRemote = remotes:FindFirstChild("Train") or remotes:FindFirstChild("Click") or remotes:FindFirstChild("AddSpeed")
                if trainRemote and trainRemote:IsA("RemoteEvent") then
                    trainRemote:FireServer()
                end
            end)
        end
        
        -- 2. Auto Race Loop
        if AutoRace then
            pcall(function()
                local raceRemote = remotes:FindFirstChild("JoinRace") or remotes:FindFirstChild("Race") or remotes:FindFirstChild("StartRace")
                if raceRemote and raceRemote:IsA("RemoteEvent") then
                    raceRemote:FireServer()
                end
            end)
        end
        
        -- 3. Auto Egg Hatch Loop
        if AutoHatch then
            pcall(function()
                local eggRemote = remotes:FindFirstChild("OpenEgg") or remotes:FindFirstChild("BuyEgg") or remotes:FindFirstChild("Hatch")
                if eggRemote and eggRemote:IsA("RemoteEvent") then
                    eggRemote:FireServer("Egg1", 1)
                end
            end)
            task.wait(0.4)
        end

        -- 4. Auto Feed / Use Items (ป้องกันกระเป๋าเต็ม 10 ผล)
        if AutoFeed then
            pcall(function()
                local useRemote = remotes:FindFirstChild("Feed") or remotes:FindFirstChild("UseItem") or remotes:FindFirstChild("Consume")
                if useRemote and useRemote:IsA("RemoteEvent") then
                    useRemote:FireServer("Beetroot")
                    task.wait(0.1)
                    useRemote:FireServer("Carrot")
                    task.wait(0.1)
                    useRemote:FireServer("Apple")
                end
            end)
            task.wait(1)
        end
    end
end)

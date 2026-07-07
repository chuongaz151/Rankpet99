local Rayfield = loadstring(game:HttpGet('https://githubusercontent.com'))()

local Window = Rayfield:CreateWindow({
   Name = "My Custom Script 🚀 (Pet Sim 99)",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "Custom Script",
   ConfigurationSaving = { Enabled = false }
 })

local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0,0))
end)

local FarmTab = Window:CreateTab("Auto Farm & Rank", 4483362458)

_G.AutoFarm = false
_G.AutoRank = false

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = ReplicatedStorage:WaitForChild("Network")
local ClaimRemote = Network:WaitForChild("Rank_ClaimReward")
local ClickRemote = Network:WaitForChild("Coin_Click")

task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoFarm then
            pcall(function()
                local Things = workspace:WaitForChild("__THINGS")
                local Coins = Things:WaitForChild("Coins")
                for _, coin in pairs(Coins:GetChildren()) do
                    if not _G.AutoFarm then break end
                    if coin:IsA("Part") or coin:IsA("MeshPart") then
                        ClickRemote:FireServer(coin.Name)
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(2)
        if _G.AutoRank then
            pcall(function()
                for slot = 1, 5 do
                    if not _G.AutoRank then break end
                    ClaimRemote:FireServer(slot)
                end
            end)
        end
    end
end)

FarmTab:CreateToggle({
   Name = "Auto Claim Rank",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoRank = Value
   end,
})

FarmTab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
   end,
})

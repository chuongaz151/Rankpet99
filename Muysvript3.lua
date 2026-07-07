local Fluent = loadstring(game:HttpGet("https://github.com"))()

local Window = Fluent:CreateWindow({
    Title = "My Custom Script 🚀 (Pet Sim 99)",
    SubTitle = "Special for Delta X",
    TabWidth = 160,
    Size = Vector2.new(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0,0))
end)

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Farm & Rank", Icon = "home" })
}

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

local Toggle1 = Tabs.Main:AddToggle("AutoRank", {Title = "Auto Claim Rank", Default = false})
Toggle1:OnChanged(function(Value)
    _G.AutoRank = Value
end)

local Toggle2 = Tabs.Main:AddToggle("AutoFarm", {Title = "Auto Farm", Default = false})
Toggle2:OnChanged(function(Value)
    _G.AutoFarm = Value
end)

Window:SelectTab(1)

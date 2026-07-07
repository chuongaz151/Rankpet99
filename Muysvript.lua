-- Tải thư viện giao diện Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://githubusercontent.com'))()

local Window = Rayfield:CreateWindow({
   Name = "My Custom Script 🚀 (Pet Sim 99)",
   LoadingTitle = "Đang khởi tạo hệ thống...",
   LoadingSubtitle = "Bản Script Cá Nhân",
   ConfigurationSaving = { Enabled = false }
 })

-- TỰ ĐỘNG KÍCH HOẠT ANTI-AFK NGẦM (CHỐNG BỊ VĂNG GAME)
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0,0))
end)
Rayfield:Notify({Title = "Hệ thống", Content = "Đã kích hoạt Anti-AFK ngầm thành công!", Duration = 5})

-- Tạo các Tab chức năng trên menu
local FarmTab = Window:CreateTab("Auto Farm & Rank", 4483362458)

-- Cấu hình các biến trạng thái bật/tắt ban đầu
_G.AutoFarm = false
_G.AutoRank = false

-- KÍCH HOẠT HỆ THỐNG GIAO TIẾP VỚI GAME (REMOTES)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = ReplicatedStorage:WaitForChild("Network")
local ClaimRemote = Network:WaitForChild("Rank_ClaimReward")
local ClickRemote = Network:WaitForChild("Coin_Click")

-- 1. TÍNH NĂNG TỰ ĐỘNG TẤN CÔNG (AUTO FARM)
task.spawn(function()
    while true do
        task.wait(0.1) -- Giới hạn tốc độ quét để tránh bị văng game
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

-- 2. TÍNH NĂNG TỰ ĐỘNG NHẬN THƯỞNG RANK (AUTO CLAIM)
task.spawn(function()
    while true do
        task.wait(2) -- Kiểm tra nhiệm vụ mỗi 2 giây để tránh spam hệ thống
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

-- TẠO CÁC NÚT BẬT/TẮT TRÊN GIAO DIỆN MENU
FarmTab:CreateToggle({
   Name = "Tự Động Nhận Thưởng Rank (Auto Claim)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoRank = Value
      if Value then
         Rayfield:Notify({Title = "Thông báo", Content = "Đã bật Tự động nhận thưởng Rank!", Duration = 3})
      end
   end,
})

FarmTab:CreateToggle({
   Name = "Tự Động Tấn Công Mục Tiêu (Auto Farm)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then
         Rayfield:Notify({Title = "Thông báo", Content = "Thú cưng đang tự động farm xung quanh!", Duration = 3})
      end
   end,
})

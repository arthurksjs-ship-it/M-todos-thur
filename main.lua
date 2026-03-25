local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local localPlayer = Players.LocalPlayer

-- estados
local antiAfk = nil
local bypassAtivo = false
local modoAnonimo = false
local autoReward = false

-- =========================
-- BYPASS PRO (HUMANO)
-- =========================
local function smartWait()
    if bypassAtivo then
        return math.random(20,50) / 100 -- 0.2 a 0.5
    else
        return 0.8
    end
end

local function cycleWait()
    if bypassAtivo then
        return math.random(2,5)
    else
        return 6
    end
end

-- =========================
-- UI
-- =========================
local Window = Rayfield:CreateWindow({
   Name = "⚡ Thur System PRO",
   LoadingTitle = "Carregando...",
   LoadingSubtitle = "Bypass PRO Ativo",
   Theme = "DarkBlue",
   ToggleUIKeybind = "F8",
   ConfigurationSaving = { Enabled = false }
})

local tabMain = Window:CreateTab("⚡ Thur", 4483362458)
local tabReward = Window:CreateTab("🎁 Auto Reward", 4483362458)

-- =========================
-- MÉTODOS DO THUR
-- =========================
tabMain:CreateSection("Funções")

tabMain:CreateToggle({
   Name = "Bypass PRO (Anti-Detecção)",
   CurrentValue = false,
   Callback = function(state)
      bypassAtivo = state
   end
})

tabMain:CreateToggle({
   Name = "Modo Anônimo",
   CurrentValue = false,
   Callback = function(state)
      modoAnonimo = state

      if state then
         pcall(function()
            localPlayer.Character.Head.Name = "???"
         end)
      else
         pcall(function()
            localPlayer.Character.Head.Name = "Head"
         end)
      end
   end
})

tabMain:CreateToggle({
   Name = "Anti-AFK",
   CurrentValue = false,
   Callback = function(enabled)
      if enabled then
         if antiAfk then antiAfk:Disconnect() end
         antiAfk = localPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
         end)
      else
         if antiAfk then
            antiAfk:Disconnect()
            antiAfk = nil
         end
      end
   end
})

tabMain:CreateButton({
   Name = "Resetar Personagem",
   Callback = function()
      localPlayer.Character:BreakJoints()
   end
})

-- =========================
-- AUTO REWARD
-- =========================
tabReward:CreateSection("Sistema Automático")

tabReward:CreateToggle({
   Name = "Auto Reward (Bypass PRO)",
   CurrentValue = false,
   Callback = function(state)
      autoReward = state

      if autoReward then
         task.spawn(function()

            local function getRemote()
               for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                  if v.Name == "ClaimReward" and v:IsA("RemoteFunction") then
                     return v
                  end
               end
            end

            local claimRemote = getRemote()

            if not claimRemote then
               Rayfield:Notify({
                  Title = "Erro",
                  Content = "Remote não encontrado!",
                  Duration = 3
               })
               return
            end

            while autoReward do
               for i = 1, 20 do
                  if not autoReward then break end

                  pcall(function()
                     claimRemote:InvokeServer(i)
                  end)

                  -- delay inteligente
                  task.wait(smartWait())

                  -- pausa aleatória humana
                  if bypassAtivo and math.random(1,10) == 5 then
                     task.wait(math.random(1,3))
                  end
               end

               Rayfield:Notify({
                  Title = "Auto Reward",
                  Content = "Recompensas coletadas!",
                  Duration = 2
               })

               task.wait(cycleWait())
            end
         end)
      end
   end
})

-- =========================
-- NOTIFICAÇÃO
-- =========================
Rayfield:Notify({
   Title = "Sistema PRO",
   Content = "Thur + Auto Reward + Bypass carregado!",
   Duration = 5
})

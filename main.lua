local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local localPlayer = Players.LocalPlayer

-- 🔑 CONFIG KEY (CORRIGIDO)
local keyURL = "https://raw.githubusercontent.com/arthurksjs-ship-it/M-todos-thur/main/keys.txt"
local keyFile = "thur_key.txt"

local keyDigitada = ""
local acessoLiberado = false

-- 💾 carregar key salva
if isfile and isfile(keyFile) then
    keyDigitada = readfile(keyFile)
end

-- 🔍 verificar key
local function verificarKey(key)
    local success, response = pcall(function()
        return game:HttpGet(keyURL)
    end)

    if success and response then
        return string.find(response, key) ~= nil
    end

    return false
end

-- ⚡ AUTO LOGIN
if keyDigitada ~= "" then
    if verificarKey(keyDigitada) then
        acessoLiberado = true
    end
end

-- =========================
-- 🌟 UI
-- =========================
local Window = Rayfield:CreateWindow({
   Name = "🔥 Métodos do Thur | Premium",
   LoadingTitle = "Métodos do Thur",
   LoadingSubtitle = "Sistema carregando...",
   Theme = "DarkBlue",
   ToggleUIKeybind = "F8",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ThurHub",
      FileName = "Config"
   }
})

-- 🔑 ABA KEY
local tabKey = Window:CreateTab("🔑 Key", 4483362458)

tabKey:CreateInput({
   Name = "Digite sua Key",
   PlaceholderText = "Cole aqui...",
   Callback = function(text)
      keyDigitada = text
   end,
})

tabKey:CreateButton({
   Name = "Verificar Key",
   Callback = function()
      if verificarKey(keyDigitada) then
         
         if writefile then
            writefile(keyFile, keyDigitada)
         end

         acessoLiberado = true
         
         Rayfield:Notify({
            Title = "Acesso Liberado",
            Content = "Key correta e salva!",
            Duration = 3
         })
      else
         Rayfield:Notify({
            Title = "Erro",
            Content = "Key inválida!",
            Duration = 3
         })
      end
   end,
})

-- =========================
-- 🏠 PRINCIPAL
-- =========================
local tabMain = Window:CreateTab("🏠 Principal", 4483362458)
local tabPlayer = Window:CreateTab("👤 Jogador", 4483362458)

tabMain:CreateSection("🎯 Automação")

local running = false

tabMain:CreateToggle({
   Name = "🍀 Auto Coletar Recompensas",
   CurrentValue = false,
   Flag = "AutoRewards",
   Callback = function(state)

      if not acessoLiberado then
         Rayfield:Notify({
            Title = "Bloqueado",
            Content = "Digite a key primeiro!",
            Duration = 3
         })
         return
      end

      running = state

      if running then
         Rayfield:Notify({
            Title = "Auto Reward",
            Content = "Ativado!",
            Duration = 2
         })

         task.spawn(function()
            local claimRemote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index")
               :WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit")
               :WaitForChild("Services"):WaitForChild("ChallengeService")
               :WaitForChild("RF"):WaitForChild("ClaimReward")

            while running do
               for i = 1, 12 do
                  if not running then break end
                  pcall(function()
                     claimRemote:InvokeServer(i)
                  end)
                  task.wait(1)
               end

               task.wait(10)
            end
         end)
      end
   end
})

-- =========================
-- 👤 PLAYER
-- =========================
local antiAfk = nil

tabPlayer:CreateSection("⚙️ Utilidades")

tabPlayer:CreateToggle({
   Name = "🛡️ Anti-AFK",
   CurrentValue = false,
   Flag = "AntiAfk",
   Callback = function(enabled)
      if enabled then
         if antiAfk then antiAfk:Disconnect() end
         antiAfk = localPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
         end)

         Rayfield:Notify({
            Title = "Anti-AFK",
            Content = "Ativado",
            Duration = 2
         })
      else
         if antiAfk then
            antiAfk:Disconnect()
            antiAfk = nil
         end
      end
   end
})

-- =========================
-- 🚀 START
-- =========================
Rayfield:Notify({
   Title = "🔥 Métodos do Thur",
   Content = acessoLiberado and "Login automático realizado!" or "Digite sua key!",
   Duration = 5
})

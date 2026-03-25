-- 🔑 KEY SYSTEM
local keyURL = "https://raw.githubusercontent.com/arthurksjs-ship-it/M-todos-thur/main/keys.txt"
local keyFile = "thur_key.txt"

local keyDigitada = ""
local acessoLiberado = false

if isfile and isfile(keyFile) then
    keyDigitada = readfile(keyFile)
end

local function verificarKey(key)
    local success, response = pcall(function()
        return game:HttpGet(keyURL)
    end)

    if success and response then
        return string.find(response, key) ~= nil
    end
    return false
end

-- 🔐 SE NÃO TEM KEY VÁLIDA → PARA AQUI
if keyDigitada ~= "" and verificarKey(keyDigitada) then
    acessoLiberado = true
end

if not acessoLiberado then
    local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

    local Window = Rayfield:CreateWindow({
       Name = "🔑 Métodos do Thur",
       LoadingTitle = "Sistema de Key",
       LoadingSubtitle = "Digite a key",
       Theme = "DarkBlue"
    })

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

             Rayfield:Notify({
                Title = "Acesso Liberado",
                Content = "Reexecute o script!",
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

    return -- 🔥 BLOQUEIA O RESTO DO SCRIPT
end

-- =========================
-- 🔥 SEU SCRIPT ORIGINAL (NÃO ALTERADO)
-- =========================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local localPlayer = Players.LocalPlayer

local running = false
local antiAfk = nil

-- Janela Principal
local Window = Rayfield:CreateWindow({
   Name = "🔥 Métodos do Thur",
   LoadingTitle = "Métodos do Thur",
   LoadingSubtitle = "Carregado",
   Theme = "DarkBlue",
   ToggleUIKeybind = "F8",
   ConfigurationSaving = { Enabled = false }
})

local tabAutomation = Window:CreateTab("🍀 LuckySpin", 4483362458)
local tabPlayer = Window:CreateTab("👤 Jogador", 4483362458)

tabAutomation:CreateSection("Recompensas Automáticas")

tabAutomation:CreateToggle({
   Name = "Auto Coletar (Loop Infinito)",
   CurrentValue = false,
   Flag = "AutoRewards",
   Callback = function(state)
      running = state
      if running then
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
                  task.wait(1.0) 
               end
               
               Rayfield:Notify({
                  Title = "Ciclo Completo",
                  Content = "Tentando coletar todas as recompensas novamente...",
                  Duration = 2
               })
               
               task.wait(10)
            end
         end)
      end
   end
})

tabPlayer:CreateSection("Utilitários")

tabPlayer:CreateToggle({
   Name = "Anti-AFK",
   CurrentValue = false,
   Flag = "AntiAfk",
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

Rayfield:Notify({
   Title = "Sistema Ativo",
   Content = "O loop de spins foi corrigido para não parar no segundo giro.",
   Duration = 5
})

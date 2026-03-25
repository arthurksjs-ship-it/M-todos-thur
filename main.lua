local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local localPlayer = Players.LocalPlayer

-- CONFIG KEYAUTH (SUA)
local appName = "metodosthur"
local ownerid = "XVzZAGvC1x"
local version = "1.0"

local function verificarKey(key)
    local url = "https://keyauth.win/api/1.2/?type=license&key="..key.."&name="..appName.."&ownerid="..ownerid.."&version="..version
    
    local response = game:HttpGet(url)
    local data = HttpService:JSONDecode(response)

    return data.success
end

-- VARIÁVEIS
local running = false
local antiAfk = nil
local acessoLiberado = false
local keyDigitada = ""

-- JANELA
local Window = Rayfield:CreateWindow({
   Name = "🔐 Métodos do Thur",
   LoadingTitle = "Sistema de Key",
   LoadingSubtitle = "Aguardando verificação...",
   Theme = "DarkBlue",
   ToggleUIKeybind = "F8",
   ConfigurationSaving = { Enabled = false }
})

-- ABA KEY
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
         acessoLiberado = true
         
         Rayfield:Notify({
            Title = "Acesso Liberado",
            Content = "Key válida!",
            Duration = 4
         })
      else
         game.Players.LocalPlayer:Kick("Key inválida!")
      end
   end,
})

-- ABAS PRINCIPAIS
local tabAutomation = Window:CreateTab("🍀 LuckySpin", 4483362458)
local tabPlayer = Window:CreateTab("👤 Jogador", 4483362458)

tabAutomation:CreateSection("Recompensas Automáticas")

tabAutomation:CreateToggle({
   Name = "Auto Coletar (Loop Infinito)",
   CurrentValue = false,
   Flag = "AutoRewards",
   Callback = function(state)
      if not acessoLiberado then
         Rayfield:Notify({
            Title = "Bloqueado",
            Content = "Verifique a key primeiro!",
            Duration = 3
         })
         return
      end

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
                  task.wait(1)
               end
               
               Rayfield:Notify({
                  Title = "Ciclo Completo",
                  Content = "Coletando novamente...",
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
   Title = "Métodos do Thur",
   Content = "Sistema carregado com sucesso!",
   Duration = 5
})

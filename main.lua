local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local localPlayer = Players.LocalPlayer

local antiAfk = nil
local bypassAtivo = false
local modoAnonimo = false

-- Janela
local Window = Rayfield:CreateWindow({
   Name = "⚡ Métodos do Thur",
   LoadingTitle = "Carregando...",
   LoadingSubtitle = "Thur System",
   Theme = "DarkBlue",
   ToggleUIKeybind = "F8",
   ConfigurationSaving = { Enabled = false }
})

local tabThur = Window:CreateTab("⚡ Thur", 4483362458)

-- =========================
-- SEÇÃO PRINCIPAL
-- =========================
tabThur:CreateSection("Funções")

tabThur:CreateToggle({
   Name = "Bypass (Delay Rápido)",
   CurrentValue = false,
   Callback = function(state)
      bypassAtivo = state
      
      Rayfield:Notify({
         Title = "Bypass",
         Content = state and "Ativado ⚡" or "Desativado ❌",
         Duration = 2
      })
   end
})

tabThur:CreateToggle({
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

      Rayfield:Notify({
         Title = "Modo Anônimo",
         Content = state and "Ativado 🕶️" or "Desativado",
         Duration = 2
      })
   end
})

tabThur:CreateToggle({
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

tabThur:CreateButton({
   Name = "Resetar Personagem",
   Callback = function()
      localPlayer.Character:BreakJoints()
   end
})

-- =========================
-- EXTRA (LOOP TESTE BYPASS)
-- =========================
tabThur:CreateButton({
   Name = "Testar Bypass (Spam)",
   Callback = function()
      task.spawn(function()
         while bypassAtivo do
            print("Bypass ativo...")
            task.wait(0.2)
         end
      end)
   end
})

-- =========================
-- NOTIFICAÇÃO
-- =========================
Rayfield:Notify({
   Title = "Thur System",
   Content = "Carregado com sucesso!",
   Duration = 5
})

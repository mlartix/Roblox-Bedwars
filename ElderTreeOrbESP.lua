_G.toggle = true

local RefreshRate = 14

function WTS(part)
    local screen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
    return Vector2.new(screen.x, screen.y), bool, screen.Z
end
    
function ESP(part, text)
    local LastRefresh = 0

    if not part then return end;

    local name = Drawing.new("Text")
    name.Text = text
    name.Color = Color3.fromHSV(tick() * 24 % 255/255, 1, 1)
    name.Position = WTS(part)
    name.Size = 18
    name.Outline = true
    name.Center = true
    name.Visible = true
    local Bottom = Drawing.new("Text")
    Bottom.Color = Color3.fromHSV(tick() * 24 % 255/255, 1, 1)
    Bottom.Position = WTS(part) + Vector2.new(0, 15);
    Bottom.Size = 18
    Bottom.Outline = true
    Bottom.Center = true
    Bottom.Visible = true
    
    local connection;
    
    connection = game:GetService("RunService").Stepped:connect(function()
        if (tick() - LastRefresh) > (RefreshRate / 1000) then
            LastRefresh = tick();
            pcall(function()
                local destroyed = not part:IsDescendantOf(workspace)
                
                if destroyed and name ~= nil and Bottom ~= nil then
                    name:Remove()
                    Bottom:Remove()
                end
                
                
                
                if part ~= nil then
                    local Pos,Bool,Distance = WTS(part);
                    name.Position = WTS(part)
                    Bottom.Position = WTS(part) + Vector2.new(0,15)
                    Bottom.Text = tostring(math.floor(Distance + .05))
                    name.Color = Color3.fromHSV(tick() * 24 % 255/255, 1, 1)
                    Bottom.Color = Color3.fromHSV(tick() * 24 % 255/255, 1, 1)
                end
                
                local _, screen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
                
                if screen and _G.toggle then
                    name.Visible = true
                    Bottom.Visible = true
                else
                    name.Visible = false
                    Bottom.Visible = false
                end
                
            end)
        end
    end)
end


for _,v in pairs(workspace:GetChildren()) do 
    if v:IsA("Model") and string.find(v.Name:lower(), "treeorb") then
        ESP(v.PrimaryPart, tostring(v.Name))
    end
end


workspace.ChildAdded:Connect(function(child)
    if child:IsA("Model") and string.find(child.Name:lower(), "treeorb") then
        if not child.PrimaryPart then
            child:GetPropertyChangedSignal("PrimaryPart"):Wait()
        end
        
        ESP(child.PrimaryPart, tostring(child.Name))
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    --if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode[string.upper(tostring(_G.Keybind))] then
        if _G.toggle then
           _G.toggle = false
        else
            _G.toggle = true
        end
    end
end)

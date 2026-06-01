local Whitelist = {}

function Whitelist:Add(input, liquid)
    local target = liquid.Utility:GetPlayer(input)
    if target then
        if not liquid.Protection:IsWhitelisted(target.UserId, liquid.Vars.Whitelist) then
            table.insert(liquid.Vars.Whitelist, target.UserId)
            liquid:CreateNotification("Liquid", "Added " .. target.Name .. " to whitelist", 3)
            liquid:Save()
        else
            liquid:CreateNotification("Liquid", target.Name .. " is already whitelisted", 3, "alert")
        end
    else
        liquid:CreateNotification("Liquid", "Player not found: " .. input, 3, "alert")
    end
end

function Whitelist:Remove(input, liquid)
    local target = liquid.Utility:GetPlayer(input)
    if target then
        for i, id in pairs(liquid.Vars.Whitelist) do
            if id == target.UserId then
                table.remove(liquid.Vars.Whitelist, i)
                liquid:CreateNotification("Liquid", "Removed " .. target.Name .. " from whitelist", 3)
                liquid:Save()
                return
            end
        end
        liquid:CreateNotification("Liquid", target.Name .. " is not in whitelist", 3, "alert")
    else
        liquid:CreateNotification("Liquid", "Player not found: " .. input, 3, "alert")
    end
end

function Whitelist:List(liquid)
    local count = #liquid.Vars.Whitelist
    liquid:CreateNotification("Liquid", "Whitelist: " .. count .. " user(s)", 3)
    print("\n-- Whitelist --")
    for i, id in pairs(liquid.Vars.Whitelist) do
        print("  " .. i .. ". " .. id)
    end
end

function Whitelist:IsWhitelisted(id, whitelist)
    for _, v in pairs(whitelist) do if v == id then return true end end
    return false
end

function Whitelist:Count(liquid)
    return #liquid.Vars.Whitelist
end

return Whitelist
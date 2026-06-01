local Blacklist = {}

function Blacklist:Add(input, liquid)
    local target = liquid.Utility:GetPlayer(input)
    if target then
        if not liquid.Protection:IsBlacklisted(target.UserId, liquid.Vars.Blacklist) then
            table.insert(liquid.Vars.Blacklist, target.UserId)
            liquid:CreateNotification("Liquid", "Added " .. target.Name .. " to blacklist", 3)
            liquid:Save()
        else
            liquid:CreateNotification("Liquid", target.Name .. " is already blacklisted", 3, "alert")
        end
    else
        liquid:CreateNotification("Liquid", "Player not found: " .. input, 3, "alert")
    end
end

function Blacklist:Remove(input, liquid)
    local target = liquid.Utility:GetPlayer(input)
    if target then
        for i, id in pairs(liquid.Vars.Blacklist) do
            if id == target.UserId then
                table.remove(liquid.Vars.Blacklist, i)
                liquid:CreateNotification("Liquid", "Removed " .. target.Name .. " from blacklist", 3)
                liquid:Save()
                return
            end
        end
        liquid:CreateNotification("Liquid", target.Name .. " is not in blacklist", 3, "alert")
    else
        liquid:CreateNotification("Liquid", "Player not found: " .. input, 3, "alert")
    end
end

function Blacklist:List(liquid)
    local count = #liquid.Vars.Blacklist
    liquid:CreateNotification("Liquid", "Blacklist: " .. count .. " user(s)", 3)
    print("\n-- Blacklist --")
    for i, id in pairs(liquid.Vars.Blacklist) do
        print("  " .. i .. ". " .. id)
    end
end

function Blacklist:IsBlacklisted(id, blacklist)
    for _, v in pairs(blacklist) do if v == id then return true end end
    return false
end

function Blacklist:Count(liquid)
    return #liquid.Vars.Blacklist
end

return Blacklist
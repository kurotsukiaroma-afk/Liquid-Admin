local Protection = {}

function Protection:IsWhitelisted(id, whitelist)
    for _, v in pairs(whitelist) do if v == id then return true end end
    return false
end

function Protection:IsBlacklisted(id, blacklist)
    for _, v in pairs(blacklist) do if v == id then return true end end
    return false
end

return Protection
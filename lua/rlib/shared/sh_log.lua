function RLib:Log(tag, tagColor, msgColor, ...)
    local str = ""
    for k, v in pairs(...) do
        str = str .. tostring(v) .. " "
    end

    MsgC(tagColor, tag, msgColor, str .. "\n")
end
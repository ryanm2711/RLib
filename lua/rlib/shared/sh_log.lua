function RLib:Log(tag, tagColor, ...)
    local str = ""
    for k, v in pairs(...) do
        str = str .. tostring(v) .. " "
    end

    MsgC(tagColor, tag, color_white, str .. "\n")
end
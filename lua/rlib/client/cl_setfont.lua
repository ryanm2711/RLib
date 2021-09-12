RLib.CreatedFonts = RLib.CreatedFonts or {}

function RLib:SetFont(font, size, weight)
    -- Set default values if nil
    font = font || "Arial";
    size = size || 16;
    weight = weight || 500;

    local fonts = self.CreatedFonts;

    -- The font data we will store in our fonts table
    local fontData = {
        font,
        size,
        weight
    };

    local canCreate = true;

    -- This is the ID for the font we want that already exists (this will be changed if we find it does exist)
    local matchingFontID = nil;

    -- Loop inside font data to see if the values do not exist for that font
    if fonts[font] then
        for id, fontTbl in pairs(fonts[font]) do
            -- If all the values match up with max, then we do not create the font
            local count = 0;
            local max = #fontTbl;
            
            for i = 1, #fontTbl do
                if fontTbl[i] == fontData[i] then
                    count = count + 1;
                end 
            end

            -- Every value matches, we have found a font that exists. We cannot create an instance of same font to avoid clutter
            if count == max then
                canCreate = false;
                matchingFontID = id;
                break;
            end
        end
    else
        -- If the font category does not exist, create it
        fonts[font] = {};
    end


    -- ID of font we will return
    local fontToReturn = nil;

    if canCreate then
        local fontID = RLib:GenerateID(20, true);
        local fontIDS = table.GetKeys(fonts[font]);

        -- FontID exists, create another
        if fontIDS[fontID] then
            fontID = RLib:GenerateID(20, true);
        end

        -- Create font because it does not exist
        surface.CreateFont(fontID, {
            font = font,
            size = size,
            weight = weight
        });
        
        -- Add font to table
        fonts[font][fontID] = fontData;


        -- Assign ID to the font we will return
        fontToReturn = fontID;
    else
        -- Get the ID of the font that we want that already exists
        fontToReturn = matchingFontID;
    end

    return fontToReturn;
end

concommand.Add("clear_all_font_data", function()
    -- Resets/empties table
    RLib.CreatedFonts = {};
end)
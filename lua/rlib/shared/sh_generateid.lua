function RLib:GenerateID(length, includeCharacters)
    -- Sets a default value if not specified
    includeCharacters = includeCharacters or false;

    local ID = "";

    for i = 1, length do 
        local generatedValue = '';
        
        if includeCharacters then
            local shouldGenerateCharacter = false;

            -- Randomly choose if should use character
            if math.random(0, 100) < 50 then
                shouldGenerateCharacter = true;
            end      
            
            if shouldGenerateCharacter then
                -- Convert the generated number to character (ASCII) 65-90 = A-Z
                generatedValue = string.char(math.random(65, 90));
            else
                -- Generate a number
                generatedValue = math.random(0, 9);
            end
        else
            -- Generate a number
            generatedValue = math.random(0, 9);
        end

        -- Concat the generated value to ID
        ID = ID .. generatedValue;
    end

    return ID;
end
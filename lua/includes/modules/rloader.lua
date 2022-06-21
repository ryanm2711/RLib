AddCSLuaFile()
module("RLoader", package.seeall)

REGISTRY = debug.getregistry()
PLAYER = REGISTRY.Player
ENTITY = REGISTRY.Entity

local function log(...)
    local str = ""
    for k, v in pairs({...}) do
        str = str .. tostring(v) .. " "
    end

    MsgC(Color(0, 0, 255), "[RLoader]", color_white, str .. "\n")
end

local function logGreen(...)
    local str = ""
    for k, v in pairs({...}) do
        str = str .. tostring(v) .. " "
    end

    MsgC(Color(0, 0, 255), "[RLoader]", Color(91, 214, 91), str .. "\n")
end

local function logRed(...)
    local str = ""
    for k, v in pairs({...}) do
        str = str .. tostring(v) .. " "
    end

    MsgC(Color(0, 0, 255), "[RLoader]", Color(167, 94, 94), str .. "\n")
end

local files = {}
local function resetLoadTable()
    files.cl = {}
    files.sh = {}
    files.sv = {}
    files.resources = {}
end

local allowedExtensions = {
    -- LUA
    [".lua"] = function(f, realm) 
        if realm == "sh" then
            table.insert(files.sh, f)
        elseif realm == "sv" then
            table.insert(files.sv, f)
        elseif realm == "cl" then
            table.insert(files.cl, f)
        end
    end,
    -- Models
    [".mdl"] = function(f) table.insert(files.resources, f) end,
    [".vvd"] = function(f) table.insert(files.resources. f) end,
    [".ani"] = function(f) table.insert(files.resources, f) end,
    [".dx80.vtx"] = function(f) table.insert(files.resources, f) end,
    [".dx90.vtx"] = function(f) table.insert(files.resources, f) end,
    [".sw.vtx"] = function(f) table.insert(files.resources, f) end,
    [".phy"] = function(f) table.insert(files.resources, f) end,
    -- Materials
    [".png"] = function(f) table.insert(files.resources, f) end,
    [".jpg"] = function(f) table.insert(files.resources, f) end,
    [".vtf"] = function(f) table.insert(files.resources, f) end,
    [".vmt"] = function(f) table.insert(files.resources, f) end,
    -- Sound
    [".wav"] = function(f) table.insert(files.resources, f) end,
    [".mp3"] = function(f) table.insert(files.resources, f) end,
    [".ogg"] = function(f) table.insert(files.resources, f) end
}

local function ProcessFile(dir, File, extension)
    local fileDir = dir .. "/" .. File -- Actual directory of file
    
    if extension == ".lua" then
        local realm = File:sub(1, 2)
        allowedExtensions[extension](fileDir, realm)
    else
        allowedExtensions[extension](fileDir)
    end

    logRed("Processing", fileDir)
end

local function SearchDir(dir, basePath)
    local files, dirs = file.Find(dir .. "/*", basePath)
    //log("Processing", dir)

    for _, File in ipairs(files) do
        for extension, _ in pairs(allowedExtensions) do
            if not File:match(".*%" .. extension) then continue end

            ProcessFile(dir, File, extension)
            break
        end
    end

    for _, directory in ipairs(dirs) do
        SearchDir(dir .. "/" .. directory, basePath)
    end
end

function RLoader:Load(dir, basePath, _include)
    local startingTimestamp = os.time()
    log("Loading directory", "from the", basePath, "base path:", dir)
    
    resetLoadTable()
    SearchDir(dir, basePath)

    for k, v in ipairs(files.sh) do
        AddCSLuaFile(v)
        _include(v)
    end

    if SERVER then
        for k, v in ipairs(files.sv) do
            _include(v)
        end

        for k, v in ipairs(files.resources) do
            _include(v)
        end
    end

    for k, v in pairs(files.cl) do
        if CLIENT then
            _include(v)
        else
            AddCSLuaFile(v)
        end
    end

    local finishedTimestamp = os.time()
    local loadFilesTime = finishedTimestamp - startingTimestamp

    logGreen("Finished loading files in " .. loadFilesTime .. " seconds")

    print("\n")
end
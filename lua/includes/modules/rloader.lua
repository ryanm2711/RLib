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

    MsgC(Color(108, 51, 240), "[RLoader]", color_white, str .. "\n")
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

local function processFile(dir, f, extension)
    --log(extension)

    if extension == ".lua" then -- Need to do this so we can actually load to the seperate realms
        local realm = f:sub(1, 2)
        f = dir .. "/" .. f
        allowedExtensions[extension](f, realm)
    else
        f = dir .. "/" .. f
        allowedExtensions[extension](f)
    end
end

local function searchDir(dir, basePath)
    local files, dirs = file.Find(dir .. "/*", basePath)
    log("Processing", dir)

    for _, f in ipairs(files) do
        for extension, _ in pairs(allowedExtensions) do
            if f:match(".*%" .. extension) then
                processFile(dir, f, extension)
                break
            end
        end
    end

    for _, d in ipairs(dirs) do -- Process sub folders
        searchDir(dir .. "/" .. d, basePath) 
    end
end

function RLoader:Load(dir, basePath, _include)
    log("Loading directory", dir)
    resetLoadTable()
    searchDir(dir, basePath)

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

    print("\n")
end
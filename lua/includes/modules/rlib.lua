AddCSLuaFile()
require("RLoader")
module("RLib", package.seeall)

RLib.Addons = RLib.Addons or {}

function RLib:RegisterAddon(name, path)
    self.Addons[name] = path

    RLoader:Load(path .. "/config", "LUA", function(f) include(f) end, {"config"})
    RLoader:Load(path, "LUA", function(f) include(f) end)

    hook.Run("RLib.OnAddonRegistered", name, path)
end

RLoader:Load("rlib", "LUA", function(f) include(f) end)
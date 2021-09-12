AddCSLuaFile()
require("RLoader")
module("RLib", package.seeall)

RLoader:Load("rlib", "LUA", function(f) include(f) end)
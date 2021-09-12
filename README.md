# RLib
Lua library to assist in Garry's Mod development.

NOTE: If using the library for an addon make sure to require the necessary modules inside lua/autorun

RLoader - Dynamic Loader
Usage: Can be used to load lua files or resources. Automatically loads sub-folders

To load a folder call this function - RLoader:Load("example_folder", "LUA", function(f) include(f) end

API:

All functions are located inside lua/rlib/

A documented API is currently not planned.

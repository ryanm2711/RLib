RLib.Settings = RLib.Settings or {}

function RLib:RegisterSetting(addon, id, type, callback)
    if not self.Settings[addon] then self.Settings[addon] = {} end -- Create a new settings table for addon
    self.Settings[addon][id] = {id=id, type=type, callback=callback}
end
local PANEL = {}

function PANEL:Init()
    self.pages = {}

    self.sidebar = self:Add("RLib.Navbar")
    self.sidebar:Dock(LEFT)

    self.body = self:Add("Panel")
    self.body:Dock(FILL)
    self.body:DockMargin(0, 0, 0, 0)

    self.sidebar:SetBody(self.body)

    self.sidebar:AddTab("Test", "DPanel")
end

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, Color(33, 39, 61))
end
derma.DefineControl("RLib.SettingsFrame", "", PANEL, "DPanel")

concommand.Add("rlib_settings", function()
    --RLib_SettingsMenu:Remove()
    if RLib_SettingsMenu ~= nil then RLib_SettingsMenu:Remove() RLib_SettingsMenu = nil return end
    RLib_SettingsMenu = vgui.Create("RLib.SettingsFrame")
    RLib_SettingsMenu:SetSize(ScrW() * 0.4, ScrH() * 0.7)
    RLib_SettingsMenu:Center()
    RLib_SettingsMenu:MakePopup()
end)
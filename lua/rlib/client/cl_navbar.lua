local PANEL = {}
AccessorFunc(PANEL, "m_Body", "Body")
AccessorFunc(PANEL, "m_Horizontal", "Horizontal", FORCE_BOOL)

function PANEL:Init()
    self.buttons = {}
    self.panels = {}
    self.font = RLib:SetFont("Roboto", ScreenScale(7), 600)
end

function PANEL:AddTab(name, panel)
    local i = #self.buttons + 1
    self.buttons[i] = self:Add("DButton")
    local btn = self.buttons[i]
    if self:GetHorizontal() then
        btn:Dock(LEFT)
        btn:DockMargin(4, 4, 0, 4)
    else
        btn:Dock(TOP)
        btn:DockMargin(0, 20, 0, 0)
    end
    btn.id = i
    btn:SetText(name)
    btn:SetFont(self.font)
    btn:SizeToContentsX(32)
    btn:SetTextColor(Color(160, 160, 160))
    btn.Paint = function(me, w, h)
    end

    if not self:GetHorizontal() then
        btn:SetContentAlignment(4)
        btn:SetTextInset(16, 0)
    end

    btn.DoClick = function(me)
        self:SetActive(me.id)
    end

    self.panels[i] = self:GetBody():Add(panel or "DPanel")
    panel = self.panels[i]
    panel:Dock(FILL)
    panel:SetVisible(false)

    if self.active == nil then -- Set default selection
        self:SetActive(i)
    end

    return panel
end

function PANEL:SetActive(id)
    local btn = self.buttons[id]
    if not IsValid(btn) then return end

    local activeBtn = self.buttons[self.active]
    if IsValid(activeBtn) then
        activeBtn:SetTextColor(Color(160, 160, 160))

        local activePnl = self.panels[self.active]
        if IsValid(activePnl) then
            activePnl:SetVisible(false)
        end
    end

    self.active = id
    btn:SetTextColor(color_white)
    self.panels[id]:SetVisible(true)
end

function PANEL:PerformLayout(w, h)
    -- Size sidebar accordingly
    if not self:GetHorizontal() then
        surface.SetFont(self.font)
        local w = 0

        for i, v in pairs(self.buttons) do
            local tW, tH = surface.GetTextSize(v:GetText())
            tW = tW + 32

            if tW > w then
                w = tW
            end
        end

        self:SetWide(w)
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(color_white)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(Color(41, 49, 77))
    surface.DrawRect(4, 4, w - 8, h - 8)
end
vgui.Register("RLib.Navbar", PANEL, "DPanel")
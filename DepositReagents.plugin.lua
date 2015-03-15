local addon, ns = ...
local Implementation = ns.cargBags

local function Button_OnClick(self)
    DepositReagentBank()
	-- We need this to find the right container later
	-- currentButton = self
end

Implementation:Register("plugin", "DepositReagents", function(self)
	local button = CreateFrame("Button", nil, self)
	button.container = self

	button:SetBackdrop{
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	}
	button:SetBackdropColor(0, 0, 0, 0.8)
	button:SetBackdropBorderColor(0, 0, 0, 0.5)
	button:SetNormalFontObject(GameFontHighlightSmall)
	button:SetHighlightFontObject(GameFontNormalSmall)
	button:SetText("Deposit Reagents")
	button:SetHeight(28)
	button:SetWidth(120)
	button:SetAlpha(0.8)
	button:SetScript("OnClick", Button_OnClick)

	button.SetMode = Button_SetMode

	return button
end)

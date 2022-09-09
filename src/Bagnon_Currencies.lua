-- Bagnon Currencies 2.0

local strjoin = _G.strjoin;
local tinsert = _G.tinsert;
local unpack = _G.unpack;

local GetNumWatchedTokens = _G.GetNumWatchedTokens;
local GetBackpackCurrencyInfo = _G.C_CurrencyInfo.GetBackpackCurrencyInfo;
local GetCurrencyInfo = _G.C_CurrencyInfo.GetCurrencyInfo;




local ldb = _G.LibStub:GetLibrary("LibDataBroker-1.1");

local function ToggleCurrencyTab()
	_G.ToggleCharacter("TokenFrame")
end

-- The object used to show the currencies in the bag
local dataObject = ldb:NewDataObject("Bagnon-Currencies", {
	text = "Loading currencies...",
	OnClick = function() ToggleCurrencyTab() end
});

local function whitenText (text)
	return strjoin("", "|cffffffff", text, "|r");
end

-- Tooltip
local ToolTip = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
ToolTip:SetPoint("CENTER",0,0)
ToolTip:SetWidth(200)
ToolTip:SetHeight(200)
-- Set Backdrop
local borderThickness = 4
ToolTip:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	edgeSize = 16,
	insets = { left = borderThickness, right = borderThickness, top = borderThickness, bottom = borderThickness },
})
ToolTip:SetBackdropColor(0, 0, 0, 1)

local cursorY = -borderThickness
local cursorX = borderThickness

ToolTip.text = ToolTip:CreateFontString(nil,"ARTWORK")
ToolTip.text:SetFont("Fonts\\ARIALN.ttf", 13, "OUTLINE")
ToolTip.text:SetText("Testing")
ToolTip.text:SetPoint("TOPLEFT",cursorX, cursorY)
cursorY = cursorY - 13

ToolTip.text2 = ToolTip:CreateFontString(nil,"ARTWORK")
ToolTip.text2:SetFont("Fonts\\ARIALN.ttf", 13, "OUTLINE")
ToolTip.text2:SetText("Testing2")
ToolTip.text2:SetPoint("TOPLEFT",cursorX,cursorY)
ToolTip:Show()

-- TODO: Get a list of all currencies
-- TODO: List headers and currencies in tooltip.
-- TODO: Sort Tracked currencies at top

-- TODO: Add settings pane

-- Events
function dataObject:OnEnter ()
	ToolTip:SetParent(self)
	ToolTip:SetPoint("BOTTOMLEFT",0,20)
	ToolTip:SetFrameStrata("TOOLTIP")
	ToolTip:Show()
end

function dataObject:OnLeave ()
	ToolTip:Hide()
end





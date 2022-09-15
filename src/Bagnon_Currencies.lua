-- Bagnon Currencies 2.0

local strjoin = _G.strjoin;
local tinsert = _G.tinsert;
local unpack = _G.unpack;

local GetNumWatchedTokens = _G.GetNumWatchedTokens;
local GetBackpackCurrencyInfo = _G.C_CurrencyInfo.GetBackpackCurrencyInfo;
local GetCurrencyInfo = _G.C_CurrencyInfo.GetCurrencyInfo;


local CurrencyListSize = GetCurrencyListSize();

print("Addon loaded")

local ToolTipSize = {width = 200, height = 200}


local ToolTipCursorPosition = {x = 5, y = -5}

local function AddText(targetFrame, message, font, size, style)
	targetFrame.newText = targetFrame:CreateFontString(nil,"ARTWORK")

	-- Set the font
	if font == "ARIAL" then targetFrame.newText:SetFont("Fonts\\ARIALN.ttf", size, style)
	elseif font == "FRIZQT" then targetFrame.newText:SetFont("Fonts\\FRIZQT__.TTF", size, style)
	else error("Font not set")
	end

	targetFrame.newText:SetText(message)
	targetFrame.newText:SetPoint("TOPLEFT", ToolTipCursorPosition.x, ToolTipCursorPosition.y)

	-- Move the cursor "down"
	ToolTipCursorPosition.y = ToolTipCursorPosition.y - size

	return targetFrame.newText
end

local function AddIconToText (iconPath)
	return strjoin("", "|T", iconPath, ":15:15:0:0|t");
end

function AddCurrencyText(targetFrame, message, font, size, style, icon, amount)
	-- TODO: I want to make a function that makes a row in a "table" where i can have Name of the
	-- TODO: Currency on the left, and the amount and icon on the right.
	textLine = AddText(targetFrame, message, font, size, style)
	TT_width, TT_height = targetFrame:GetSize()
	line_width, line_height = textLine:GetSize()
	textLine.amount = AddText(targetFrame, "TTTTTTT", font, size, style)
	textLine.amount:SetPoint("TOPRIGHT", TT_width, 30)
	textLine.amount:SetWidth(100)
	-- Lets move the cursor back up.
	ToolTipCursorPosition.y = ToolTipCursorPosition.y + size

	-- Enlarge the width of the tooltip-frame if we are going above the preset.
	if TT_width < (line_width + 100) then
		print("Frame to little. expanding...")
		ToolTipSize.width = line_width + 100
		targetFrame.SetWidth = line_width + 100
	end

end


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
ToolTip:SetHeight(ToolTipSize.height)
ToolTip:SetWidth(ToolTipSize.width)
-- Set Backdrop
local borderThickness = 4
ToolTip:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	edgeSize = 16,
	insets = { left = borderThickness, right = borderThickness, top = borderThickness, bottom = borderThickness },
})
ToolTip:SetBackdropColor(0, 0, 0, 1)


for i = 1, CurrencyListSize do
	name, isHeader, isExpanded, isUnused, isWatched, count, extraCurrencyType, icon, itemID = GetCurrencyListInfo(i)

	style = "";
	size = 13;

	-- check if its a header
	if isHeader then
		style = "THICKOUTLINE"
		size = 16
	end

	AddCurrencyText(ToolTip, name, "FRIZQT", size, style)

end


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





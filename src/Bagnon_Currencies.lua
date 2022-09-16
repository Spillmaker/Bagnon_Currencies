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


local ToolTipCursorPosition = {x = 10, y = -4}

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

local function CreateToolTip(width, height)
	newTooltip = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	newTooltip:SetPoint("CENTER", UIParent, "CENTER", 0,0)
	newTooltip:SetHeight(width)
	newTooltip:SetWidth(height)
	newTooltip:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	newTooltip:SetBackdropColor(0, 0, 0, 1)
	newTooltip:RegisterForDrag("LeftButton")
	newTooltip:EnableMouse(true)
	newTooltip:SetResizable(true)

	newTooltip:SetScript("OnDragStart", function(self)
		self:StartSizing()
	end)
	newTooltip:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
	end)

	return newTooltip;
end

function AddHeaderText(targetFrame, message)
	margin_top = 5
	ToolTipCursorPosition.y = ToolTipCursorPosition.y - (16 / 2) - margin_top
	targetFrame.newHeaderText = targetFrame:CreateFontString(nil,"ARTWORK")
	targetFrame.newHeaderText:SetFont("Fonts\\FRIZQT__.TTF", 16, "THICKOUTLINE")
	targetFrame.newHeaderText:SetText(message)
	targetFrame.newHeaderText:SetPoint("CENTER", targetFrame, "TOP", 0, ToolTipCursorPosition.y) -- Anchor of the text is in the center, and its centered in its parent.
	print(targetFrame.get)
	--targetFrame.newHeaderText:SetPoint("CENTER", ToolTipCursorPosition.x, ToolTipCursorPosition.y)
	ToolTipCursorPosition.y = ToolTipCursorPosition.y - (16 / 2)
end

function AddCurrencyText(targetFrame, message)
	ToolTipCursorPosition.y = ToolTipCursorPosition.y - (13 / 2)
	-- Add the currency Name
	targetFrame.newCurrencyName = targetFrame:CreateFontString(nil, "ARTWORK")
	targetFrame.newCurrencyName:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
	targetFrame.newCurrencyName:SetText(message)
	targetFrame.newCurrencyName:SetPoint("TOPLEFT", targetFrame, "TOPLEFT", ToolTipCursorPosition.x, ToolTipCursorPosition.y)
	ToolTipCursorPosition.y = ToolTipCursorPosition.y - 13

	newCurrencyFrameWidth, newCurrencyFrameHeight = targetFrame.newCurrencyName:GetSize()
	targetFrameWidth, targetFrameHeight = targetFrame:GetSize()

	-- get total width and rescale targetFrame
	if targetFrameWidth < (newCurrencyFrameWidth + 100) then
		targetFrame:SetWidth(newCurrencyFrameWidth + 100)
	end

	targetFrame:SetHeight(math.abs(ToolTipCursorPosition.y) + 2 + 4)
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

local ToolTip = CreateToolTip(100,200)


for i = 1, CurrencyListSize do
	name, isHeader, isExpanded, isUnused, isWatched, count, extraCurrencyType, icon, itemID = GetCurrencyListInfo(i)

	-- check if its a header
	if isHeader then
		AddHeaderText(ToolTip, name)
	else
		AddCurrencyText(ToolTip, name)
	end

	--AddCurrencyText(ToolTip, name, "FRIZQT", size, style)

end



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





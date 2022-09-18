-- Bagnon Currencies 2.0 Retail

if WOW_PROJECT_ID ~= 1 then
	return {}
end

-- overrides to work with retail wow
GetCurrencyListSize = C_CurrencyInfo.GetCurrencyListSize;



local ToolTipCursorPosition = {x = 10, y = -4}

local function CreateToolTip(width, height)
	newTooltip = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	newTooltip:SetHeight(width)
	newTooltip:SetWidth(height)
	newTooltip:Hide()
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

function AddHeaderText(targetFrame, name)
	font_size = 14

	if not targetFrame["header" .. name] then
		ToolTipCursorPosition.y = ToolTipCursorPosition.y - font_size
		targetFrame["header" .. name] = targetFrame:CreateFontString(nil,"ARTWORK")
		targetFrame["header" .. name]:SetFont("Fonts\\FRIZQT__.TTF", font_size, "OUTLINE")
		targetFrame["header" .. name]:SetPoint("CENTER", targetFrame, "TOP", 0, ToolTipCursorPosition.y) -- Anchor of the text is in the center, and its centered in its parent.
		ToolTipCursorPosition.y = ToolTipCursorPosition.y - font_size
	end

	targetFrame["header" .. name]:SetText("\124cffffcc00" .. name)
end

function AddCurrencyText(targetFrame, name, amount, iconId)
	-- Add the currency Name

	if not targetFrame["currency" .. name] then
		targetFrame["currency" .. name] = targetFrame:CreateFontString(nil, "ARTWORK")
		targetFrame["currency" .. name]:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
		targetFrame["currency" .. name]:SetPoint("TOPLEFT", targetFrame, "TOPLEFT", ToolTipCursorPosition.x, ToolTipCursorPosition.y)
	end

	targetFrame["currency" .. name]:SetText(name)

	if not targetFrame["currencyIcon" .. name] then
		targetFrame["currencyIcon" .. name] = targetFrame:CreateFontString(nil, "ARTWORK")
		targetFrame["currencyIcon" .. name]:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
		targetFrame["currencyIcon" .. name]:SetPoint("TOPRIGHT", targetFrame, "TOPRIGHT", -10, ToolTipCursorPosition.y)

		newCurrencyFrameWidth, newCurrencyFrameHeight = targetFrame["currency" .. name]:GetSize()
		targetFrameWidth, targetFrameHeight = targetFrame:GetSize()

		if targetFrameWidth < (newCurrencyFrameWidth + 100) then
			targetFrame:SetWidth(newCurrencyFrameWidth + 100)
		end

		ToolTipCursorPosition.y = ToolTipCursorPosition.y - 13
		targetFrame:SetHeight(math.abs(ToolTipCursorPosition.y) + 2 + 10)
	end

	-- TODO: Find a solution to show Honor-point icon properly
	targetFrame["currencyIcon" .. name]:SetText(amount .. " |T" .. tostring(iconId) .. ":0|t")

end

function CreateLDBCurrencyString()
	local LDBString = "Click here to set up Currencies";
	-- Lets iterate trough the tracked currencies
	if GetNumWatchedTokens() >= 1 then
		LDBString = ""
		for i = 1, GetCurrencyListSize() do
			local line = C_CurrencyInfo.GetCurrencyListInfo(i)

			if line.isShowInBackpack then
				local textureString = "|T" .. tostring(line.iconFileID) .. ":0|t"
				if line.name == "Honor Points" then -- Honor Points
					textureString = "|T" .. tostring(line.iconFileID)  .. ":25:25:0:-5|t"
				end

				local currencyString =  line.quantity .. textureString
				LDBString = LDBString .. currencyString .. "    "
			end
		end
	end
	return LDBString
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

-- Tooltip
local ToolTip = CreateToolTip(100,200)
function tooltip_painter ()
	for i = 1, GetCurrencyListSize() do
		local line = C_CurrencyInfo.GetCurrencyListInfo(i)

		if line.isHeader then
			AddHeaderText(ToolTip, line.name)
		else
			AddCurrencyText(ToolTip, line.name, line.quantity, line.iconFileID)
		end
	end
end

tooltip_painter()

dataObject.text = CreateLDBCurrencyString();

-- Events
function dataObject:OnEnter ()
	tooltip_painter()
	ToolTip:SetParent(self)
	ToolTip:SetPoint("BOTTOMLEFT",0,20)
	ToolTip:SetFrameStrata("TOOLTIP")
	ToolTip:Show()
end

function dataObject:OnLeave ()
	ToolTip:Hide()
end

function UpdateDataObject()
	dataObject.text = CreateLDBCurrencyString();
end

local frame = CreateFrame("FRAME", "Bagnon_Currencies_EventFrame");

local function eventHandler(self, event, ...)

	if event == "CURRENCY_DISPLAY_UPDATE" then
		UpdateDataObject()
	end
end
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
frame:SetScript("OnEvent", eventHandler);


-- We use this as an event to tell us that the tracked currencies have changed, and needs re-render
local function TrackedCurrenciesChanged()
	UpdateDataObject()
	-- We dont need to update the tooltip since that is updated every time its being shown
	-- TODO: Maybe we should update the tooltip here since people may be getting currency while the tooltip is shown....
end
hooksecurefunc(C_CurrencyInfo, "SetCurrencyBackpack", TrackedCurrenciesChanged)
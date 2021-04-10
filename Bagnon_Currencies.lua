-- Bagnon Currencies 1.0

local strjoin = _G.strjoin;
local tinsert = _G.tinsert;
local unpack = _G.unpack;

local ToggleCharacter = _G.ToggleCharacter;
local GetNumWatchedTokens = _G.GetNumWatchedTokens;
local GetBackpackCurrencyInfo = _G.C_CurrencyInfo.GetBackpackCurrencyInfo;
local GetCurrencyInfo = _G.C_CurrencyInfo.GetCurrencyInfo;

local GameTooltip = _G.GameTooltip;

local ldb = _G.LibStub:GetLibrary("LibDataBroker-1.1");

local dataObject = ldb:NewDataObject("Bagnon-Currencies", {
	type = "data source",
	text = "Loading currencies...",
	OnClick = function() ToggleCharacter("TokenFrame") end
});

local events = {};
local parentFrame;

local function createIconString (iconPath)
	return strjoin("", "|T", iconPath, ":15:15:0:0|t");
end

local function whitenText (text)
	return strjoin("", "|cffffffff", text, "|r");
end

local function updateDataObject ()
	local text = {};

	if table.getn(getWatchedCurrencies()) == 0 then
		tinsert(text, "Show Currencies")
	else
		for i, v in pairs(getWatchedCurrencies()) do
			local currencyInfo = GetCurrencyInfo(v.currencyTypesID)
			tinsert(text, strjoin("", currencyInfo.quantity, createIconString(currencyInfo.iconFileID)));
		end

	end

	dataObject.text = strjoin(" ",  unpack(text));
end

local function setTooltipParent (parent)
	GameTooltip:SetOwner(parent, "ANCHOR_NONE");
	GameTooltip:SetPoint("BOTTOMRIGHT", parent, "BOTTOMLEFT");
end

local function setTooltipText ()

	if table.getn(getWatchedCurrencies()) == 0 then
		GameTooltip:AddLine(whitenText("Click to open Currency-tab"));
	else
		GameTooltip:AddLine(whitenText("Currencies"));

		for i, v in pairs(getWatchedCurrencies()) do
			-- Fetch detailed information about current currency.
			local currencyInfo = GetCurrencyInfo(v.currencyTypesID)
			-- Get icon-url
			local icon = createIconString(v.iconFileID);

			-- If the currency has a maxQuantity
			if currencyInfo.maxQuantity then
				GameTooltip:AddDoubleLine(
						whitenText(strjoin(" ", icon, currencyInfo.name)),
						whitenText(strjoin("", currencyInfo.quantity, "/", currencyInfo.maxQuantity, " ", icon))
				);
			else
				GameTooltip:AddDoubleLine(
						whitenText(strjoin(" ", icon, currencyInfo.name)),
						whitenText(strjoin(" ", currencyInfo.quantity, icon))
				);
			end

			-- Add a second line for weekly limit if that exists for currency
			if currencyInfo.maxWeeklyQuantity and currencyInfo.maxWeeklyQuantity > 0 then
				GameTooltip:AddDoubleLine(
						"Weekly Maximum:",
						whitenText(strjoin("", currencyInfo.quantityEarnedThisWeek, "/", currencyInfo.maxWeeklyQuantity, " ", icon))
				);
			end

		end

	end

	GameTooltip:Show();
end

local function updateTooltip ()
	if (GameTooltip:GetOwner() ~= parentFrame) then return end

	setTooltipText();
end

function dataObject:OnEnter ()
	--[[ self is not dataObject here! ]]
	parentFrame = self;
	setTooltipParent(parentFrame);
	setTooltipText();
end

function events:CURRENCY_DISPLAY_UPDATE (...)

	updateDataObject();
	updateTooltip();
end

-- Will update the dataobject whenever mouse is clicked while the currency-window is open.
function events:GLOBAL_MOUSE_UP (...)
	if TokenFrame:IsVisible() then
		updateDataObject();
		updateTooltip();
	end
end

function getWatchedCurrencies()
	-- Create new empty table.
	local currencies = {}
	-- This lets is iterate trough the alleged amount of currencies that is watched.
	-- This is known to be incorrect if you unwatch the last watched currency. (Still says 1 instead of 0).
	for i = 1, GetNumWatchedTokens() do
		local currency = GetBackpackCurrencyInfo(i);
		-- Insert currency into table only if it exists.
		if currency then
			table.insert(currencies, currency)
		end
	end
	return currencies
end

--[[ event handling ]]
local eventFrame = _G.CreateFrame('Frame');

for event in pairs (events) do
	eventFrame:RegisterEvent(event);
end

eventFrame:SetScript('OnEvent', function (_, event, ...)
	events[event](...);
end);

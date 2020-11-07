-- Bagnon Currencies 1.0

local strjoin = _G.strjoin;
local tinsert = _G.tinsert;
local unpack = _G.unpack;
local C_Timer = _G.C_Timer;

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

	for i = 1, GetNumWatchedTokens(), 1 do
		local info = GetBackpackCurrencyInfo(i);

		if info then
			tinsert(text, strjoin("", info.quantity, createIconString(info.iconFileID)));
		end
	end

	dataObject.text = strjoin(" ",  unpack(text));
end

local function setTooltipParent (parent)
	GameTooltip:SetOwner(parent, "ANCHOR_NONE");
	GameTooltip:SetPoint("BOTTOMRIGHT", parent, "BOTTOMLEFT");
end

local function setTooltipText ()
	GameTooltip:ClearLines();
	GameTooltip:AddLine(whitenText("Currencies"));

	for i = 1, GetNumWatchedTokens() do
		local backpackInfo = GetBackpackCurrencyInfo(i);
		local info = GetCurrencyInfo(backpackInfo.currencyTypesID);
		local icon = createIconString(info.iconFileID);
		local totalMax = info.maxQuantity;
		local weeklyMax = info.maxWeeklyQuantity;
		local amount = info.quantity;
		local earnedThisWeek = info.quantityEarnedThisWeek;

		if totalMax <= 0 then
			GameTooltip:AddDoubleLine(
				whitenText(strjoin(" ", icon, info.name)),
				whitenText(strjoin(" ", amount, icon))
			);
		else
			GameTooltip:AddDoubleLine(
				whitenText(strjoin(" ", icon, info.name)),
				whitenText(strjoin("", amount, "/", totalMax, " ", icon))
			);
		end

		if weeklyMax > 0 then
			GameTooltip:AddDoubleLine(
				"Weekly Maximum:",
				whitenText(strjoin("", earnedThisWeek, "/", weeklyMax, " ", icon))
			);
		end
	end

	GameTooltip:Show();
end

local function updateTooltip ()
	if (GameTooltip:GetOwner() ~= parentFrame) then return end

	setTooltipText();
end

local function updateDataAndTooltip ()
	updateDataObject();
	updateTooltip();
end

function dataObject:OnEnter ()
	--[[ self is not dataObject here! ]]
	parentFrame = self;
	setTooltipParent(parentFrame);
	setTooltipText();
end

events.CURRENCY_DISPLAY_UPDATE = updateDataAndTooltip;

_G.hooksecurefunc(_G.C_CurrencyInfo, 'SetCurrencyBackpack', function ()
	--[[ Right after "SetCurrencyBackPack" was called, "GetNumWatchedTokens"
			 still returns the previous count. Therefore, data has to be updated on
			 the next frame. ]]
	C_Timer.After(0, updateDataAndTooltip);
end);

--[[ event handling ]]
local eventFrame = _G.CreateFrame('Frame');

for event in pairs (events) do
	eventFrame:RegisterEvent(event);
end

eventFrame:SetScript('OnEvent', function (_, event, ...)
	events[event](...);
end);

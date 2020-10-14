-- Bagnon Currencies 1.0

local strjoin = _G.strjoin;
local tinsert = _G.tinsert;
local unpack = _G.unpack;

local ToggleCharacter = _G.ToggleCharacter;
local GetNumWatchedTokens = _G.GetNumWatchedTokens;
local GetBackpackCurrencyInfo = _G.C_CurrencyInfo.GetBackpackCurrencyInfo;
local GetCurrencyInfo = _G.C_CurrencyInfo.GetCurrencyInfo;

local GameTooltip = _G.GameTooltip;

-- Include Databroker-library
local ldb = _G.LibStub:GetLibrary("LibDataBroker-1.1")
-- Create dataobject
local dataobj = ldb:NewDataObject("Bagnon-Currencies", {type = "data source", text = "Loading currencies...", OnClick = function() ToggleCharacter("TokenFrame") end})
-- Create frame
local frame = _G.CreateFrame("frame")

-- Text-colors

local function createIconString (iconPath)
	return strjoin("", "|T", iconPath, ":15:15:0:0|t");
end

local function whitenText (text)
	return strjoin("", "|cffffffff", text, "|r");
end

frame:RegisterEvent('CURRENCY_DISPLAY_UPDATE');

frame:SetScript("OnEvent", function ()
	local text = {};

	for i = 1, GetNumWatchedTokens(), 1 do
		local info = GetBackpackCurrencyInfo(i);

		tinsert(text, strjoin("", info.quantity, createIconString(info.iconFileID)));
	end

	dataobj.text = strjoin(" ",  unpack(text));
end)

-- Tooltip-settings
function dataobj:OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_NONE");
	GameTooltip:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT");
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

		GameTooltip:AddLine(whitenText(strjoin(" ", icon, info.name)));

		if totalMax <= 0 then
			GameTooltip:AddDoubleLine(whitenText(strjoin(" ", icon, info.name)), whitenText(strjoin(" ", amount, icon)));
		else
			GameTooltip:AddDoubleLine(whitenText(strjoin(" ", icon, info.name)), whitenText(strjoin("", amount, "/", totalMax, " ", icon)))
		end

		if weeklyMax > 0 then
			GameTooltip:AddDoubleLine("Weekly Maximum:", whitenText(strjoin("", earnedThisWeek, "/", weeklyMax, " ", icon)))
		end
	end

	GameTooltip:Show()
end

-- Bagnon Currencies 1.0


-- Include Databroker-library
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
-- Create dataobject
local dataobj = ldb:NewDataObject("Bagnon-Currencies", {type = "data source", text = "Loading currencies...", OnClick = function() ToggleCharacter("TokenFrame") end})
-- Create frame
local frame = CreateFrame("frame")

-- Text-colors
local textWhite = "|cffffffff"

local function getWatchedTokensAmount()
	local amount = 0;
			for i = 1, MAX_WATCHED_TOKENS do
				if(GetBackpackCurrencyInfo(i)) then
					amount = amount+1
				end
			end
	return amount
end


frame:SetScript("OnUpdate", function(self, elap)
	-- Ghetto stringbuilder
	local text = "";

	-- Iterate trough each currency-type that have been marked for view.
	for i = 1, getWatchedTokensAmount() do
		local name, count, icon = GetBackpackCurrencyInfo(i);
		text = text.. count.."|T"..icon..":15:15:0:0|t "
	end
	-- Output
	dataobj.text = text

end)

-- Tooltip-settings
function dataobj:OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT")
	GameTooltip:ClearLines()
	GameTooltip:AddLine(textWhite .. "Currencies|r")

	for i = 1, getWatchedTokensAmount() do

		local name, count, icon, itemID  = GetBackpackCurrencyInfo(i);
		local name, amount, texturePath, earnedThisWeek, weeklyMax, totalMax, isDiscovered = GetCurrencyInfo(itemID);


		GameTooltip:AddLine(textWhite .. "|T"..icon..":15:15:0:0|t ".. name)

		if totalMax <= 0 then
			GameTooltip:AddDoubleLine("Total: ", textWhite .. amount .. " |T"..icon..":15:15:0:0|t ")
		else
			GameTooltip:AddDoubleLine("Total Maximum: ", textWhite .. amount .. "/" .. string.format("%02d",totalMax) .." |T"..icon..":15:15:0:0|t ")
		end

		if weeklyMax > 0 then
			GameTooltip:AddDoubleLine("Total Weekly Maximum: ", textWhite .. earnedThisWeek .. "/".. string.format("%02d",weeklyMax) .." |T"..icon..":15:15:0:0|t ")
		end

	end
	GameTooltip:Show()
end

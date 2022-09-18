# Buildscript for mac

# Create Addon-folder if it doesnt exist in Classic
mkdir /Applications/World\ of\ Warcraft/_classic_/Interface/AddOns/Bagnon_Currencies
# Upload to Classic
rsync -av --exclude=".*" ../. /Applications/World\ of\ Warcraft/_classic_/Interface/AddOns/Bagnon_Currencies

# Create Addon-folder if it doesnt exist in Retail
mkdir /Applications/World\ of\ Warcraft/_retail_/Interface/AddOns/Bagnon_Currencies
# Upload to Retail
rsync -av --exclude=".*" ../. /Applications/World\ of\ Warcraft/_retail_/Interface/AddOns/Bagnon_Currencies

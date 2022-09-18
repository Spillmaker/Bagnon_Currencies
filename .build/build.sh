# Buildscript for mac

rm -r ../dist/*
mkdir ../dist
cp ../src/* ../dist/
# Upload to Classic
rm -r /Applications/World\ of\ Warcraft/_classic_/Interface/AddOns/Bagnon_Currencies
mkdir /Applications/World\ of\ Warcraft/_classic_/Interface/AddOns/Bagnon_Currencies
cp ../dist/* /Applications/World\ of\ Warcraft/_classic_/Interface/AddOns/Bagnon_Currencies

# Upload to Retail
rm -r /Applications/World\ of\ Warcraft/_retail_/Interface/AddOns/Bagnon_Currencies
mkdir /Applications/World\ of\ Warcraft/_retail_/Interface/AddOns/Bagnon_Currencies
cp ./dist/* /Applications/World\ of\ Warcraft/_retail_/Interface/AddOns/Bagnon_Currencies
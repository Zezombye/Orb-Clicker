
for (var key in upgrades) {
    upgrades[key.toUpperCase()] = upgrades[key]
    delete upgrades[key]
}

var result = ""

result += "enum ShopPositions:\n"
for (var key in upgrades) {
    result += "\t"+key+" = "+upgrades[key].buyPos+",\n";
}

result += "enum ShopUnlockThresholds:\n"
for (var key in upgrades) {
    result += "\t"+key+" = "+upgrades[key].unlockAtBoss+",\n";
}

result += "enum ShopBaseCosts:\n"
for (var key in upgrades) {
    result += "\t"+key+" = "+upgrades[key].baseCost+",\n";
}

result += "enum ShopCostMults:\n"
for (var key in upgrades) {
    result += "\t"+key+" = "+upgrades[key].costMultiplier+",\n";
}

//Create the shop description hud

result += 'rule "shop description hud":\n\thudHeader(any([pos for pos in [';
for (var key in upgrades) {
    result += upgrades[key].buyPos+" if "+upgrades[key].unlockAtBoss+" <= currentBoss else null,";
}
result += "] if pos != null and distance(localPlayer.getPosition(), pos) < 1]), '{}\n\n[{}] to buy | {} money'.format({";
for (var key in upgrades) {
    result += upgrades[key].buyPos + ": "+JSON.stringify(upgrades[key].description)+",";
}
result += "}[[pos for pos in [";
for (var key in upgrades) {
    result += upgrades[key].buyPos+" if "+upgrades[key].unlockAtBoss+" <= currentBoss else null,";
}
result += "] if pos != null and distance(localPlayer.getPosition(), pos) < 1][0]],buttonString(Button.INTERACT), formatNb(localPlayer.money)), HudPosition.TOP, TopSortOrder.SHOP_DESCRIPTION, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)\n";

//UPPER_CASE -> camelCase
function upperCaseToCamelCase(str) {
	var result = str.toLowerCase().replace(/(_\w)/g, x => x[1].toUpperCase());
	result = result[0].toLowerCase()+result.substring(1)
	return result;
}

for (var key in upgrades) {
    result += "playervar "+upperCaseToCamelCase(key+"_COST")+" = "+upgrades[key].baseCost+"\n"
}

result;

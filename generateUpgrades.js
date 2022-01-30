
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

result += "enum ShopCostMultipliers:\n"
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

//Create the buy rule

//UPPER_CASE -> camelCase
function upperCaseToCamelCase(str) {
	var result = str.toLowerCase().replace(/(_\w)/g, x => x[1].toUpperCase());
	result = result[0].toLowerCase()+result.substring(1)
	return result;
}

for (var key in upgrades) {
    result += "playervar "+upperCaseToCamelCase(key+"_COST")+" = "+upgrades[key].baseCost+"\n"
}


result += `
rule "f to upgrade":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition gameStatus == GameStatus.IN_SHOP
`
for (var key in upgrades) {
    result += "\tif currentBoss >= "+upgrades[key].unlockAtBoss+" and distance(eventPlayer.getPosition(), "+upgrades[key].buyPos+") < 1:\n\tif isLessThanOrEqual(";
    result += upgrades[key].costFormula || "eventPlayer."+upperCaseToCamelCase(key+"_COST");
    result += ", eventPlayer.money):\n\t\teventPlayer." + (upgrades[key].upgradeVariable || upperCaseToCamelCase(key));
    if (upgrades[key].upgradeType === "multiplicative") {
        result += " = multiplyBySmallNb(eventPlayer."+(upgrades[key].upgradeVariable || upperCaseToCamelCase(key))+", "+upgrades[key].upgradeFormula+")\n"
    } else if (upgrades[key].upgradeType === "additiveSmall") {
        result += " += "+upgrades[key].upgradeFormula+"\n";
    } else {
        result += "= add(eventPlayer."+(upgrades[key].upgradeVariable || upperCaseToCamelCase(key))+", "+upgrades[key].upgradeFormula+")\n";
    }
    result += "\t\teventPlayer.money = subtract(eventPlayer.money, "+(upgrades[key].costFormula || "eventPlayer."+upperCaseToCamelCase(key+"_COST"))+")\n"
    result += "\t\teventPlayer."+upperCaseToCamelCase(key+"_COST")+" = ";
    if (upgrades[key].upgradeCostType === "factorial") {
        result += "multiplyBySmallNb(eventPlayer."+upperCaseToCamelCase(key+"_COST")+", (eventPlayer."+(upgrades[key].upgradeVariable || upperCaseToCamelCase(key))+")+1)\n"
    } else {
        result += "multiplyBySmallNb(eventPlayer."+upperCaseToCamelCase(key+"_COST")+", "+upgrades[key].costMultiplier+")\n";
    }
    result += "\tgoto end\n"
}
result += `
    end:
    wait()
    if eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.CROUCH):
        goto RULE_START
`

result;

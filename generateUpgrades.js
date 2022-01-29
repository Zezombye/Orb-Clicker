
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

result;

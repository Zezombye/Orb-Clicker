#!mainFile "main.opy"

#!define generateUpgrades(upgrades) __script__("generateUpgrades.js")

generateUpgrades({
    "dmg": {
        buyPos: vect(-194, 20, 96),
        unlockAtBoss: 0,
        baseCost: vect(10, 0, 0),
        costMultiplier: 1.1,
        description: "placeholder dmg description",
        costFormula: "multiply(eventPlayer.dmgCost, eventPlayer.dmgCostReduction)",
        upgradeFormula: "eventPlayer.dmgIncrement",
        upgradeVariable: "dmgMult",
    },
    "money_mult": {
        buyPos: vect(-194, 20, 100),
        unlockAtBoss: 1,
        baseCost: vect(1, 3, 0),
        costMultiplier: 1.3,
        description: "placeholder money description",
        upgradeFormula: "eventPlayer.moneyIncrement",
    },
    "dmg_mult": {
        buyPos: vect(-190, 20, 96),
        unlockAtBoss: 1,
        baseCost: vect(5, 3, 0),
        costMultiplier: 1.5,
        description: "placeholder dmg mult description",
        upgradeType: "multiplicative",
        upgradeFormula: "DMG_MULT_VALUE",
    },
    "crit_mult": {
        buyPos: vect(-192, 20, 98),
        unlockAtBoss: 1,
        baseCost: vect(7, 15, 0),
        costMultiplier: 1.3,
        description: "placeholder crit mult description",
        upgradeType: "additiveSmall",
        upgradeFormula: "CRIT_MULT_INCREMENT",
    },
    "crit_chance": {
        buyPos: vect(-192, 20, 96),
        unlockAtBoss: 1,
        baseCost: vect(250, 3, 0),
        costMultiplier: null, //#"factorial",
        description: "placeholder crit chance description",
        upgradeType: "additiveSmall",
        upgradeFormula: "1",
        upgradeCostType: "factorial",
    },
    "dmg_cost_reduction": {
        buyPos: vect(-192, 20, 100),
        unlockAtBoss: 2,
        baseCost: vect(5, 3, 0),
        costMultiplier: 1.15,
        description: "placeholder dmg cost reduction description",
        upgradeType: "multiplicative",
        upgradeFormula: "DMG_REDUCTION_COST_MULT",
    },
    /*"poison": {
        buyPos: vect(-190, 20, 98),
        unlockAtBoss: 13,
        baseCost: vect(20, 27, 0),
        costMultiplier: 5,
        description: "placeholder poison description",
    },
    "life": {
        buyPos: vect(-194, 20, 98),
        unlockAtBoss: 4,
        baseCost: vect(4, 0, 0),
        costMultiplier: 1.2,
        description: "placeholder life description",
    },*/
})


enum UpgradesUnlockThresholds:
    DMG_UPGRADE_1 = 6,
    MONEY_ULT_CHARGE = 7,
    CRIT_SQUARED = 9,


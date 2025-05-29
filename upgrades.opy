#!mainFile "main.opy"

#!define generateUpgrades(upgrades) __script__("generateUpgrades.js")

enum ShopPositions:
	DMG = vect(-194,20,96),
	MONEY_MULT = vect(-194,20,100),
	DMG_MULT = vect(-190,20,96),
	CRIT_MULT = vect(-192,20,98),
	CRIT_CHANCE = vect(-192,20,96),
	DMG_COST_REDUCTION = vect(-192,20,100),
	POISON = vect(-190,20,98),
	LIFE = vect(-194,20,98),
enum ShopUnlockThresholds:
	DMG = 0,
	MONEY_MULT = 1,
	DMG_MULT = 1,
	CRIT_MULT = 1,
	CRIT_CHANCE = 1,
	DMG_COST_REDUCTION = 2,
	POISON = 13,
	LIFE = 4,
enum ShopBaseCosts:
	DMG = vect(10,0,0),
	MONEY_MULT = vect(1,3,0),
	DMG_MULT = vect(5,3,0),
	CRIT_MULT = vect(7,15,0),
	CRIT_CHANCE = vect(250,3,0),
	DMG_COST_REDUCTION = vect(5,3,0),
	POISON = vect(20,27,0),
	LIFE = vect(4,0,0),
enum ShopCostMults:
	DMG = 1.1,
	MONEY_MULT = 1.3,
	DMG_MULT = 1.5,
	CRIT_MULT = 1.3,
	CRIT_CHANCE = null,
	DMG_COST_REDUCTION = 1.15,
	POISON = 5,
	LIFE = 1.2,
rule "shop description hud":

    A = "owo\n {uwu+2} r"
    B = bf"owo\n {uwu+'zaer'+2} r"
    B = bf'owo\n {uwu+"zaer"+2} r'
    C = "owo {} {0} {1243} {fe}"
    C = 'owo {} {0} {1243} {fe}'

	hudHeader(any([pos for pos in [vect(-194,20,96) if 0 <= currentBoss else null,vect(-194,20,100) if 1 <= currentBoss else null,vect(-190,20,96) if 1 <= currentBoss else null,vect(-192,20,98) if 1 <= currentBoss else null,vect(-192,20,96) if 1 <= currentBoss else null,vect(-192,20,100) if 2 <= currentBoss else null,vect(-190,20,98) if 13 <= currentBoss else null,vect(-194,20,98) if 4 <= currentBoss else null,] if pos != null and distance(localPlayer.getPosition(), pos) < 1]), '{}

[{}] to buy | {} money'.format({vect(-194,20,96): "placeholder dmg description",vect(-194,20,100): "placeholder money description",vect(-190,20,96): "placeholder dmg mult description",vect(-192,20,98): "placeholder crit mult description",vect(-192,20,96): "placeholder crit chance description",vect(-192,20,100): "placeholder dmg cost reduction description",vect(-190,20,98): "placeholder poison description",vect(-194,20,98): "placeholder life description",}[[pos for pos in [vect(-194,20,96) if 0 <= currentBoss else null,vect(-194,20,100) if 1 <= currentBoss else null,vect(-190,20,96) if 1 <= currentBoss else null,vect(-192,20,98) if 1 <= currentBoss else null,vect(-192,20,96) if 1 <= currentBoss else null,vect(-192,20,100) if 2 <= currentBoss else null,vect(-190,20,98) if 13 <= currentBoss else null,vect(-194,20,98) if 4 <= currentBoss else null,] if pos != null and distance(localPlayer.getPosition(), pos) < 1][0]],buttonString(Button.INTERACT), formatNb(localPlayer.money)), HudPosition.TOP, TopSortOrder.SHOP_DESCRIPTION, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
playervar dmgCost = vect(10,0,0)
playervar moneyMultCost = vect(1,3,0)
playervar dmgMultCost = vect(5,3,0)
playervar critMultCost = vect(7,15,0)
playervar critChanceCost = vect(250,3,0)
playervar dmgCostReductionCost = vect(5,3,0)
playervar poisonCost = vect(20,27,0)
playervar lifeCost = vect(4,0,0)

/*generateUpgrades({
    "dmg": {
        //buyPos: vect(-194, 20, 96),
        //unlockAtBoss: 0,
        //baseCost: vect(10, 0, 0),
        //costMultiplier: 1.1,
        //description: "placeholder dmg description",
        //costFormula: "multiply(eventPlayer.dmgCost, eventPlayer.dmgCostReduction)",
        //upgradeFormula: "eventPlayer.dmgIncrement",
        //upgradeVariable: "dmgMult",
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
    },*/
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
    },*//*
})*/


enum UpgradesUnlockThresholds:
    DMG_UPGRADE_1 = 6,
    MONEY_ULT_CHARGE = 7,
    CRIT_SQUARED = 9,

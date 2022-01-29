#!mainFile "main.opy"

#!define generateUpgrades(upgrades) __script__("generateUpgrades.js")

generateUpgrades({
    
    "dmg": {
        buyPos: vect(-194, 20, 96),
        unlockAtBoss: 0,
        baseCost: vect(10, 0, 0),
        costMultiplier: 1.1,
    },
    "dmg_mult": {
        buyPos: vect(-190, 20, 96),
        unlockAtBoss: 1,
        baseCost: vect(5, 3, 0),
        costMultiplier: 1.5,
    },
    "money": {
        buyPos: vect(-194, 20, 100),
        unlockAtBoss: 1,
        baseCost: vect(1, 3, 0),
        costMultiplier: 1.3,
    },
    "crit_chance": {
        buyPos: vect(-192, 20, 96),
        unlockAtBoss: 1,
        baseCost: vect(250, 3, 0),
        costMultiplier: null, //#"factorial",
    },
    "crit_mult": {
        buyPos: vect(-192, 20, 98),
        unlockAtBoss: 1,
        baseCost: vect(7, 15, 0),
        costMultiplier: 1.3,
    },
    "dmg_cost_reduction": {
        buyPos: vect(-192, 20, 100),
        unlockAtBoss: 2,
        baseCost: vect(5, 3, 0),
        costMultiplier: 1.15,
    },
    "poison": {
        buyPos: vect(-190, 20, 98),
        unlockAtBoss: 13,
        baseCost: vect(20, 27, 0),
        costMultiplier: 5,
    },
    "life": {
        buyPos: vect(-194, 20, 98),
        unlockAtBoss: 4,
        baseCost: vect(4, 0, 0),
        costMultiplier: 1.2,
    },
})


enum UpgradesUnlockThresholds:
    DMG_UPGRADE_1 = 6,
    MONEY_ULT_CHARGE = 7,
    CRIT_SQUARED = 9,


#!define BOSS_HP_MULT 5
#!define BOSS_DMG_MULT 2
#!define BOSS_MONEY_MULT 10

#!define DMG_MULT_VALUE 1.1
#!define BASE_CRIT_MULT 2
#!define CRIT_MULT_INCREMENT 0.1
#!define DMG_REDUCTION_COST_MULT 0.99
#!define POISON_DMG_INCREMENT 0.0001
#!mainFile "main.opy"

enum ShopPositions:
    DMG = vect(-194, 20, 96),
    DMG_MULT = vect(-190, 20, 96),
    MONEY = vect(-194, 20, 100),
    CRIT_CHANCE = vect(-192, 20, 96),
    CRIT_MULT = vect(-192, 20, 98),
    DMG_COST_REDUCTION = vect(-192, 20, 100),
    POISON = vect(-190, 20, 98),
    LIFE = vect(-194, 20, 98),

    CURRENT_BOSS = vect(-190, 20, 92),
    NEXT_BOSS = vect(-186, 20, 92)

enum UnlockThresholds:
    DMG = 0,
    DMG_MULT = 1,
    MONEY = 1,
    CRIT_CHANCE = 1,
    CRIT_MULT = 1,
    DMG_COST_REDUCTION = 2,
    POISON = 13,
    LIFE = 4,
    DMG_UPGRADE_1 = 6,
    MONEY_ULT_CHARGE = 7,
    CRIT_SQUARED = 9,

enum BaseCosts:
    DMG = vect(10, 0, 0),
    DMG_MULT = vect(5, 3, 0),
    MONEY = vect(1, 3, 0),
    CRIT_CHANCE = vect(250, 3, 0),
    CRIT_MULT = vect(7, 15, 0),
    DMG_COST_REDUCTION = vect(5, 3, 0),
    POISON = vect(20, 27, 0),
    LIFE = 4,
    NEXT_BOSS = vect(69, 0, 0)

enum CostMultipliers:
    DMG = 1.1,
    DMG_MULT = 1.5,
    MONEY = 1.3,
    #CRIT_CHANCE = factorial,
    CRIT_MULT = 1.3,
    DMG_COST_REDUCTION = 1.15,
    POISON = 5,
    LIFE = 1.2,
    NEXT_BOSS = 10,

#!define BOSS_HP_MULT 5
#!define BOSS_DMG_MULT 2
#!define BOSS_MONEY_MULT 10

#!define DMG_MULT_VALUE 1.1
#!define BASE_CRIT_MULT 2
#!define CRIT_MULT_INCREMENT 0.1
#!define DMG_REDUCTION_COST_MULT 0.99
#!define POISON_DMG_INCREMENT 0.0001
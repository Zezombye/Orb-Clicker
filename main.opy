
#!include "settings.opy"
#!include "beegNumbers.opy"


#!obfuscate

enum LeftSortOrder:
    SERVER_LOAD,
    STATS_BANNER,
    MONEY,
    DMG,
    DMG_COST,
    CRIT,
    BOSS,
    DMG_RATIO,
    LAST_DMG_DEALT,

enum TopSortOrder:
    BOSS_HP_BAR,
    SHOP_DESCRIPTION_VERTICAL_OFFSET,
    SHOP_DESCRIPTION,

enum GameStatus:
    WAITING_FOR_PLAYERS, #unused for now - game starts immediately
    IN_SHOP,
    FIGHTING,


#!define BOSS_HP_MULT 5
#!define BOSS_DMG_MULT 2
#!define BOSS_MONEY_MULT 10

#!define DMG_MULT_VALUE 1.1
#!define BASE_CRIT_MULT 2
#!define CRIT_MULT_INCREMENT 0.1
#!define DMG_REDUCTION_COST_MULT 0.99
#!define POISON_DMG_INCREMENT 0.0001

globalvar gameStatus = GameStatus.IN_SHOP
    

globalvar i
globalvar nbSpheres = 33
globalvar bossPositions = [vect(-187.909, 18, 56.487), vect(-187.999, 53.714, 116.579), vect(-187.68, 59, 0.437), vect(-194.671, 9, 25.029), vect(-163.787, 16, 22.174), vect(-164.039, 16, -22.175), vect(-188.376, 15.981, -0.409), vect(-194.36, 9, -26.312), vect(-209.161, 18.716, -59.169), vect(-187.763, 53.574, -121.065), vect(67.707, 2.116, -303.574), vect(83.898, 6.419, -310.817), vect(70.848, 7.5, -279.124), vect(152.073, 7.537, -258.077), vect(114.957, 9, -295.685), vect(114.844, 7.5, -248.443), vect(111.242, 11.501, -217.716), vect(142.877, 7.5, -220.137), vect(177.029, 5.5, -240.937), vect(173.216, 7.5, -176.523), vect(206.235, 6.419, -185.695), vect(239.869, 7.746, 134.814), vect(217.053, 0.999, 172.741), vect(194.92, 0.85, 206.221), vect(176.048, 4.101, 250.773), vect(127.888, 4, 231.505), vect(146.491, 4.101, 280.022), vect(111.808, 0.85, 299.021), vect(154.745, 10.982, 293.431), vect(142.029, 32.916, 305.4), vect(203.675, 32.916, 246.844), vect(70.324, 1, 319.488)]
globalvar spawnroom
globalvar bossHeroes = getAllHeroes()
globalvar bossHpMult = [vect(1,0,0)]

globalvar shopPositions = []
globalvar bossEntity = null

globalvar dmgIndicatorTime

globalvar suffixes = ["", "K", "M", "B", "T", "Qạ", "Qі", "Sҳ", "Sṗ", "Oƈ", "Nο", "Dƈ", "Uḍ", "Dḍ", "Tḍ", "Qạḍ", "Qіḍ", "Sҳḍ", "Sṗḍ", "Oḍ", "Nḍ"]
globalvar currentBoss = 0
globalvar timeToBeatBoss = 0
playervar money = vect(0.00000000001, 0, 0)
playervar moneyMult = vect(1, 0, 0)

playervar tempCalculation
playervar name
playervar hpMultiplier

playervar moneyIncrement = vect(1, 0, 0)

playervar dmgMult = vect(1, 0, 0)
playervar dmgIncrement = vect(1, 0, 0)

playervar critChance = 0

playervar critMult = BASE_CRIT_MULT

playervar dmgCostReduction = vect(1, 0, 0)
#!include "upgrades.opy"

playervar damageRatio = 100
playervar hasUnlockedMoneyUltCharge = false
playervar hasUnlockedCritSquared = false

playervar lastDmgDealt
playervar dmgDealt = []
playervar dmgIndicatorTextPos = []
playervar dmgIndicatorVelocity = []
playervar dmgIndicatorAngle = []
playervar dmgIndicatorXMultiplier = []
playervar dmgIndicatorTimeOffsets = []
playervar dmgIndicatorColors = []
playervar dmgIndicatorTextIndex = 0
#!define DMG_INDICATOR_GRAVITY 30
#!define DMG_INDICATOR_MAX_TEXTS 25

#!define BOSS_PORTAL_POSITION vect(-188, 20, 93)

#!include "debug.opy"
#!include "dummy.opy"

rule "init":
    hudSubtext(localPlayer, "load: {}, avg: {}, max: {}".format(getServerLoad(), getAverageServerLoad(), getPeakServerLoad()), HudPosition.LEFT, LeftSortOrder.SERVER_LOAD, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(localPlayer, "Stats", HudPosition.LEFT, LeftSortOrder.STATS_BANNER, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(localPlayer, "Money: ${} | {} money/dmg".format(formatNb(localPlayer.money), formatNb(multiplyBySmallNb(localPlayer.moneyMult, max(1, localPlayer.getUltCharge()) if localPlayer.hasUnlockedMoneyUltCharge else 1))), HudPosition.LEFT, LeftSortOrder.MONEY, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(localPlayer, "{}% dmg dealt".format(formatNb(localPlayer.dmgMult)), HudPosition.LEFT, LeftSortOrder.DMG, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(localPlayer, "dmg cost reduced by {}%".format(formatNb(localPlayer.dmgCostReduction)), HudPosition.LEFT, LeftSortOrder.DMG_COST, Color.TURQUOISE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(localPlayer, "{}% chance to crit for {}×dmg".format(localPlayer.critChance, localPlayer.critMult), HudPosition.LEFT, LeftSortOrder.CRIT, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(localPlayer, "current boss: {}, time to beat: {}".format(currentBoss, timeToBeatBoss), HudPosition.LEFT, LeftSortOrder.BOSS, Color.ROSE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudSubtext(localPlayer, "dmg ratio*1000: {}, hp mult: {}".format(localPlayer.damageRatio*1000, formatNb(bossHpMult[localPlayer.currentBoss])), HudPosition.LEFT, LeftSortOrder.DMG_RATIO, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudHeader(localPlayer, localPlayer.lastDmgDealt, HudPosition.LEFT, LeftSortOrder.LAST_DMG_DEALT, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(localPlayer, " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudPosition.TOP, TopSortOrder.SHOP_DESCRIPTION_VERTICAL_OFFSET, Color.ROSE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    for i in range(1, len(bossHeroes)):
        bossHpMult[i] = multiplyBySmallNb(bossHpMult[i-1], BOSS_HP_MULT)
    
    for i in range(DMG_INDICATOR_MAX_TEXTS):
        createInWorldText(localPlayer if dmgIndicatorTime - localPlayer.dmgIndicatorTimeOffsets[evalOnce(i)] >= 0 and dmgIndicatorTime - localPlayer.dmgIndicatorTimeOffsets[evalOnce(i)] <= 0.7 else null, localPlayer.dmgDealt[evalOnce(i)], updateEveryTick(localPlayer.dmgIndicatorTextPos[evalOnce(i)] + vect(
            0,
            (localPlayer.dmgIndicatorVelocity[evalOnce(i)] * (dmgIndicatorTime - localPlayer.dmgIndicatorTimeOffsets[evalOnce(i)]) * sinDeg(localPlayer.dmgIndicatorAngle[evalOnce(i)]) - 0.5 * DMG_INDICATOR_GRAVITY * (dmgIndicatorTime - localPlayer.dmgIndicatorTimeOffsets[evalOnce(i)]) * (dmgIndicatorTime - localPlayer.dmgIndicatorTimeOffsets[evalOnce(i)])) * distance(localPlayer.getEyePosition(), localPlayer.dmgIndicatorTextPos[evalOnce(i)])/10,
            0
        ) + (
            worldVector(Vector.LEFT, localPlayer, Transform.ROTATION) * localPlayer.dmgIndicatorXMultiplier[evalOnce(i)] * localPlayer.dmgIndicatorVelocity[evalOnce(i)] * (dmgIndicatorTime - localPlayer.dmgIndicatorTimeOffsets[evalOnce(i)]) * cosDeg(localPlayer.dmgIndicatorAngle[evalOnce(i)]) * distance(localPlayer.getEyePosition(), localPlayer.dmgIndicatorTextPos[evalOnce(i)])/10
        )), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, localPlayer.dmgIndicatorColors[evalOnce(i)], SpecVisibility.ALWAYS)

    wait(5)
    chase(dmgIndicatorTime, Math.INFINITY, rate=1, ChaseReeval.NONE)
        


rule "init player":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned()
    eventPlayer.disableGamemodeHud()
    eventPlayer.disableGamemodeInWorldUi()
    eventPlayer.setMaxHealth(0)
    if DEBUG_INVINCIBLE:
        eventPlayer.setDamageReceived(0)
    eventPlayer.disableMessages()
    eventPlayer.setRespawnTime(Math.INFINITY)
    eventPlayer.disableRespawn()
    chase(timeToBeatBoss, 99999, rate=1, ChaseReeval.NONE)
    
    wait(5)
    eventPlayer.enableMessages()
    if DEBUG_MONEY:
        eventPlayer.money = vect(1,3,0)

rule "no assemble heroes":
    @Condition isAssemblingHeroes()
    setMatchTime(0)

rule "no setup":
    @Condition isInSetup()
    setMatchTime(0)

rule "infinite progress":
    @Condition isGameInProgress()
    setMatchTime(Math.INFINITY)
    wait(1)
    pauseMatchTime()

rule "tp player to shop":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition gameStatus == GameStatus.IN_SHOP
    eventPlayer.respawn()
    eventPlayer.teleport(vect(-187.976, 19.998, 105.998))
    eventPlayer.setFacing(vect(0, 0, -1), Relativity.TO_WORLD)
    #eventPlayer.setDamageDealt(20 if DEBUG_NORMAL_DMG else 0.001)
    if not eventPlayer.isDummy():
        #eventPlayer.startHoT(null, 99999, 9999)


rule "create spheres":
    for i in range(len(bossPositions)):
        createEffect(getAllPlayers(), Effect.SPHERE, Color.WHITE, bossPositions[i], 10, EffectReeval.VISIBILITY)
        wait()

rule "create effects":
    createEffect(getAllPlayers(), Effect.RING, Color.GREEN, BOSS_PORTAL_POSITION, 1, EffectReeval.VISIBILITY)
    createInWorldText(getAllPlayers(), "Gather here to go to current boss", BOSS_PORTAL_POSITION+vect(0,1,0), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.GREEN, SpecVisibility.ALWAYS)

    createEffect([currentBoss >= ShopUnlockThresholds.MONEY_MULT], Effect.RING, Color.LIME_GREEN, ShopUnlockThresholds.MONEY_MULT, 1, EffectReeval.VISIBILITY)
    createInWorldText([currentBoss >= ShopUnlockThresholds.MONEY_MULT], "+{} money/dmg: ${}".format(formatNb(localPlayer.moneyIncrement), formatNb(localPlayer.moneyMultCost)), ShopUnlockThresholds.MONEY_MULT+vect(0,1,0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.LIME_GREEN, SpecVisibility.ALWAYS)

    createEffect(getAllPlayers(), Effect.RING, Color.AQUA, ShopPositions.DMG, 1, EffectReeval.VISIBILITY)
    createInWorldText(getAllPlayers(), "+{}% dmg: ${}".format(formatNb(localPlayer.dmgIncrement), formatNb(multiply(localPlayer.dmgCost, localPlayer.dmgCostReduction))), ShopPositions.DMG+vect(0,1,0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.AQUA, SpecVisibility.ALWAYS)
    
    createEffect(getAllPlayers(), Effect.RING, Color.AQUA, ShopPositions.CRIT_CHANCE, 1, EffectReeval.VISIBILITY)
    createInWorldText(getAllPlayers(), "+1% crit chance: ${}".format(formatNb(localPlayer.critChanceCost)), ShopPositions.CRIT_CHANCE+vect(0,1,0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.AQUA, SpecVisibility.ALWAYS)
    
    createEffect(getAllPlayers(), Effect.RING, Color.AQUA, ShopPositions.CRIT_MULT, 1, EffectReeval.VISIBILITY)
    createInWorldText(getAllPlayers(), "+{} crit multiplier: ${}".format(CRIT_MULT_INCREMENT, formatNb(localPlayer.critMultCost)), ShopPositions.CRIT_MULT+vect(0,1,0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.AQUA, SpecVisibility.ALWAYS)

    createEffect(getAllPlayers(), Effect.RING, Color.AQUA, ShopPositions.DMG_COST_REDUCTION, 1, EffectReeval.VISIBILITY)
    createInWorldText(getAllPlayers(), "dmg {}% cheaper (compounding): ${}".format(100-DMG_REDUCTION_COST_MULT*100, formatNb(localPlayer.dmgCostReductionCost)), ShopPositions.DMG_COST_REDUCTION+vect(0,1,0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.AQUA, SpecVisibility.ALWAYS)

    createEffect(getAllPlayers(), Effect.RING, Color.AQUA, ShopPositions.DMG_MULT, 1, EffectReeval.VISIBILITY)
    createInWorldText(getAllPlayers(), "+{}% dmg (compounding): ${}".format(DMG_MULT_VALUE*100-100, formatNb(localPlayer.dmgMultCost)), ShopPositions.DMG_MULT+vect(0,1,0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.AQUA, SpecVisibility.ALWAYS)

    progressBarHud(
        [gameStatus == GameStatus.FIGHTING], bossEntity.getNormalizedHealth()*100, "{}/{}".format(
            formatNb(
                multiplyBySmallNb(bossHpMult[currentBoss], bossEntity.getHealth())
            ),
            formatNb(bossEntity.hpMultiplier)
        ), 
        HudPosition.TOP, TopSortOrder.BOSS_HP_BAR, Color.RED, Color.RED, ProgressHudReeval.VISIBILITY_AND_VALUES, SpecVisibility.DEFAULT
    )

rule "all players gathered to boss":
    @Condition all([distance(p.getPosition(), BOSS_PORTAL_POSITION) < 1.5 for p in getPlayers(Team.1)])
    gameStatus = GameStatus.FIGHTING


rule "spawn boss":
    @Condition gameStatus == GameStatus.FIGHTING
    createDummy(bossHeroes[currentBoss], Team.2, -1, bossPositions[currentBoss], Vector.FORWARD)

rule "player is fighting":
    @Event eachPlayer
    @Team 1
    @Condition gameStatus == GameStatus.FIGHTING
    @Condition eventPlayer.hasSpawned()
    eventPlayer.damageRatio = divide(eventPlayer.dmgMult, bossHpMult[currentBoss])
    eventPlayer.damageRatio = toSmallNb(eventPlayer.damageRatio) / 2500 #500% dmg taken * 10000% dmg taken * 500% dmg dealt
    eventPlayer.setDamageDealt(eventPlayer.damageRatio)
    eventPlayer.setUltCharge(0)
    eventPlayer.teleport(bossPositions[currentBoss])
    

rule "player exited arena":
    @Event eachPlayer
    @Condition gameStatus == GameStatus.FIGHTING
    @Condition distance(eventPlayer.getPosition(), bossPositions[currentBoss]) > 10
    do:
        eventPlayer.teleport(bossPositions[currentBoss])
        wait()
    while RULE_CONDITION

rule "all players ded":
    @Condition len(getDeadPlayers(Team.1)) == len(getPlayers(Team.1))
    gameStatus = GameStatus.IN_SHOP



rule "gain money":
    @Event playerDealtDamage
    @Team 1
    @Condition attacker != victim
    
    #https://discord.com/channels/570672959799164958/570688774216876052/776257368228757554

    if eventAbility == null:
        smallMessage(attacker, "Dealt an additional {} real dmg".format(eventDamage))
    else:
        if random.uniform(0,100) < attacker.critChance:
            if attacker.hasUnlockedCritSquared and random.uniform(0,100) < attacker.critChance:
                attacker.tempCalculation = multiplyBySmallNb(bossHpMult[currentBoss], min(eventDamage*attacker.critMult*attacker.critMult, eventDamage+victim.getHealth()))
                attacker.lastDmgDealt = "Crit²! Dealt {} damage ({} real)".format(formatNb(multiplyBySmallNb(bossHpMult[currentBoss], eventDamage*attacker.critMult*attacker.critMult)), eventDamage)
                smallMessage(attacker, "Dealing an additional {} raw damage".format(eventDamage / attacker.damageRatio / 25 * (attacker.critMult*attacker.critMult-1) * (1/0.5 if victim.getHealthOfType(Health.ARMOR) > 0 else 1) * (1/0.8 if victim.getCurrentHero() == Hero.BASTION and victim.isUsingAbility1() else 1/0.6 if victim.getCurrentHero() == Hero.ORISA and victim.isUsingAbility1() else 1/0.5 if victim.getCurrentHero() == Hero.ROADHOG and victim.isUsingAbility2() else 1)))
                damage(victim, attacker, eventDamage / attacker.damageRatio / 25 * (attacker.critMult*attacker.critMult-1) * (1/0.5 if victim.getHealthOfType(Health.ARMOR) > 0 else 1) * (1/0.8 if victim.getCurrentHero() == Hero.BASTION and victim.isUsingAbility1() else 1/0.6 if victim.getCurrentHero() == Hero.ORISA and victim.isUsingAbility1() else 1/0.5 if victim.getCurrentHero() == Hero.ROADHOG and victim.isUsingAbility2() else 1))
            else:
                attacker.tempCalculation = multiplyBySmallNb(bossHpMult[currentBoss], min(eventDamage*attacker.critMult, eventDamage+victim.getHealth()))
                attacker.lastDmgDealt = "Crit! Dealt {} damage ({} real)".format(formatNb(multiplyBySmallNb(bossHpMult[currentBoss], eventDamage)), eventDamage)
                smallMessage(attacker, "Dealing an additional {} raw damage".format(eventDamage / attacker.damageRatio / 25 * (attacker.critMult-1) * (1/0.5 if victim.getHealthOfType(Health.ARMOR) > 0 else 1) * (1/0.8 if victim.getCurrentHero() == Hero.BASTION and victim.isUsingAbility1() else 1/0.6 if victim.getCurrentHero() == Hero.ORISA and victim.isUsingAbility1() else 1/0.5 if victim.getCurrentHero() == Hero.ROADHOG and victim.isUsingAbility2() else 1)))
                damage(victim, attacker, eventDamage / attacker.damageRatio / 25 * (attacker.critMult-1) * (1/0.5 if victim.getHealthOfType(Health.ARMOR) > 0 else 1) * (1/0.8 if victim.getCurrentHero() == Hero.BASTION and victim.isUsingAbility1() else 1/0.6 if victim.getCurrentHero() == Hero.ORISA and victim.isUsingAbility1() else 1/0.5 if victim.getCurrentHero() == Hero.ROADHOG and victim.isUsingAbility2() else 1))
        else:
            attacker.lastDmgDealt = "Dealt {} damage ({} real)".format(formatNb(multiplyBySmallNb(bossHpMult[currentBoss], eventDamage)), eventDamage)
            attacker.tempCalculation = multiplyBySmallNb(bossHpMult[currentBoss], eventDamage)
            #attacker.tempCalculation = multiplyBySmallNb(attacker.dmgMultiplier, eventDamage / attacker.damageRatio / 2500)
            #smallMessage(attacker, "Dealt {} damage ({} real)".format(formatNb(attacker.tempCalculation), eventDamage))
        attacker.tempCalculation = multiply(attacker.tempCalculation, attacker.moneyMult)
        if attacker.hasUnlockedMoneyUltCharge:
            attacker.tempCalculation = multiplyBySmallNb(attacker.tempCalculation, min(1, attacker.getUltCharge()))
        attacker.money = add(attacker.money, attacker.tempCalculation)

        #damage indicator
        #attacker.dmgDealt[attacker.dmgIndicatorTextIndex] = eventDamage
        attacker.dmgDealt[attacker.dmgIndicatorTextIndex] = formatNb(multiplyBySmallNb(bossHpMult[currentBoss], eventDamage))
        
        attacker.dmgIndicatorColors[attacker.dmgIndicatorTextIndex] = rgb(255, max(255 - (256*8)*(eventDamage/victim.getMaxHealth()), 21), abs(255 - (256*16)*(eventDamage/victim.getMaxHealth())))
        attacker.dmgIndicatorTextPos[attacker.dmgIndicatorTextIndex] = victim.getEyePosition()
        attacker.dmgIndicatorVelocity[attacker.dmgIndicatorTextIndex] = random.uniform(9, 12)
        attacker.dmgIndicatorAngle[attacker.dmgIndicatorTextIndex] = random.uniform(50, 70)
        attacker.dmgIndicatorXMultiplier[attacker.dmgIndicatorTextIndex] = random.uniform(1, 0.5) * (-1 if random.randint(0,1) else 1)
        attacker.dmgIndicatorTimeOffsets[attacker.dmgIndicatorTextIndex] = dmgIndicatorTime
        attacker.dmgIndicatorTextIndex++
        attacker.dmgIndicatorTextIndex %= DMG_INDICATOR_MAX_TEXTS


rule "killed boss":
    @Event playerDealtFinalBlow
    @Team 1
    @Condition attacker != victim
    @Condition gameStatus == GameStatus.FIGHTING
    bigMessage(getAllPlayers(), "{} killed the boss!".format(attacker))
    if currentBoss == ShopUnlockThresholds.MONEY_MULT - 1:
        bigMessage(getAllPlayers(), "Unlocked money upgrade")
    if currentBoss == UpgradesUnlockThresholds.DMG_UPGRADE_1 - 1:
        bigMessage(getAllPlayers(), "Unlocked dmg upgrade 1 (x1.5)")
        #TODO: handle players who join mid-game
        getAllPlayers().dmgMult = multiplyBySmallNb(eventPlayer.dmgMult, 1.5)
        getAllPlayers().dmgIncrement = multiplyBySmallNb(eventPlayer.dmgIncrement, 1.5)
    if currentBoss == UpgradesUnlockThresholds.MONEY_ULT_CHARGE - 1:
        bigMessage(getAllPlayers(), "Unlocked money *= ult charge")
        getAllPlayers().hasUnlockedMoneyUltCharge = true
    if currentBoss == UpgradesUnlockThresholds.CRIT_SQUARED - 1:
        bigMessage(getAllPlayers(), "Unlocked crit²")
        getAllPlayers().hasUnlockedCritSquared = true

    printLog("{} killed boss {} with {}e{} money mult and {}e{}% dmg in {}s".format(attacker, currentBoss, eventPlayer.moneyMult.mantissa, eventPlayer.moneyMult.exponent, eventPlayer.dmgMult.mantissa, eventPlayer.money.exponent, timeToBeatBoss))
    currentBoss++
    getAllPlayers().moneyMult = multiplyBySmallNb(eventPlayer.moneyMult, BOSS_MONEY_MULT)
    getAllPlayers().moneyIncrement = multiplyBySmallNb(eventPlayer.moneyIncrement, BOSS_MONEY_MULT)
    timeToBeatBoss = 0
    getAllPlayers().respawn()
    gameStatus = GameStatus.IN_SHOP


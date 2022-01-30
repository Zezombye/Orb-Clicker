#!mainFile "main.opy"

rule "f to upgrade":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition gameStatus == GameStatus.IN_SHOP

    if distance(eventPlayer.getPosition(), ShopPositions.DMG) < 1:
        if isLessThanOrEqual(multiply(eventPlayer.dmgCost, eventPlayer.dmgCostReduction), eventPlayer.money):
            eventPlayer.dmgMultiplier = add(eventPlayer.dmgMultiplier, eventPlayer.dmgIncrement)
            eventPlayer.money = subtract(eventPlayer.money, multiply(eventPlayer.dmgCost, eventPlayer.dmgCostReduction))
            eventPlayer.dmgCost = multiplyBySmallNb(eventPlayer.dmgCost, ShopCostMultipliers.DMG)
    
    elif currentBoss >= ShopUnlockThresholds.MONEY and distance(eventPlayer.getPosition(), ShopPositions.MONEY) < 1:
        if isLessThanOrEqual(eventPlayer.moneyCost, eventPlayer.money):
            eventPlayer.moneyMultiplier = add(eventPlayer.moneyMultiplier, eventPlayer.moneyIncrement)
            eventPlayer.money = subtract(eventPlayer.money, eventPlayer.moneyCost)
            eventPlayer.moneyCost = multiplyBySmallNb(eventPlayer.moneyCost, ShopCostMultipliers.MONEY)

            
    elif currentBoss >= ShopUnlockThresholds.DMG_MULT and distance(eventPlayer.getPosition(), ShopPositions.DMG_MULT) < 1:
        if isLessThanOrEqual(eventPlayer.dmgMultiplierCost, eventPlayer.money):
            eventPlayer.dmgMultiplier = multiplyBySmallNb(eventPlayer.dmgMultiplier, DMG_MULT_VALUE)
            eventPlayer.dmgIncrement = multiplyBySmallNb(eventPlayer.dmgIncrement, DMG_MULT_VALUE)
            eventPlayer.money = subtract(eventPlayer.money, eventPlayer.dmgMultiplierCost)
            eventPlayer.dmgMultiplierCost = multiplyBySmallNb(eventPlayer.dmgMultiplierCost, ShopCostMultipliers.DMG_MULT)

    elif currentBoss >= ShopUnlockThresholds.CRIT_MULT and distance(eventPlayer.getPosition(), ShopPositions.CRIT_MULT) < 1:
        if isLessThanOrEqual(eventPlayer.critMultCost, eventPlayer.money):
            eventPlayer.critMult += CRIT_MULT_INCREMENT
            eventPlayer.money = subtract(eventPlayer.money, eventPlayer.critMultCost)
            eventPlayer.critMultCost = multiplyBySmallNb(eventPlayer.critMultCost, ShopCostMultipliers.CRIT_MULT)

    elif currentBoss >= ShopUnlockThresholds.CRIT_CHANCE and distance(eventPlayer.getPosition(), ShopPositions.CRIT_CHANCE) < 1:
        if isLessThanOrEqual(eventPlayer.critChanceCost, eventPlayer.money):
            eventPlayer.critChance++
            eventPlayer.money = subtract(eventPlayer.money, eventPlayer.critChanceCost)
            eventPlayer.critChanceCost = multiplyBySmallNb(eventPlayer.critChanceCost, eventPlayer.critChance+1)
            
    elif currentBoss >= ShopUnlockThresholds.DMG_COST_REDUCTION and distance(eventPlayer.getPosition(), ShopPositions.DMG_COST_REDUCTION) < 1:
        if isLessThanOrEqual(eventPlayer.dmgCostReductionCost, eventPlayer.money):
            eventPlayer.dmgCostReduction = multiplyBySmallNb(eventPlayer.dmgCostReduction, DMG_REDUCTION_COST_MULT)
            eventPlayer.money = subtract(eventPlayer.money, eventPlayer.dmgCostReductionCost)
            eventPlayer.dmgCostReductionCost = multiplyBySmallNb(eventPlayer.dmgCostReductionCost, ShopCostMultipliers.DMG_COST_REDUCTION)

    wait()
    if eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.CROUCH):
        goto RULE_START

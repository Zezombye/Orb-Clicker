#!mainFile "main.opy"

rule "f to upgrade":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition gameStatus == GameStatus.IN_SHOP

    if distance(eventPlayer.getPosition(), ShopPositions.DMG) < 1:
        if isLessThanOrEqual(multiply(eventPlayer.dmgCost, eventPlayer.dmgCostReduction), eventPlayer.money):
            eventPlayer.dmgMult = add(eventPlayer.dmgMult, eventPlayer.dmgIncrement)
            eventPlayer.money = subtract(eventPlayer.money, multiply(eventPlayer.dmgCost, eventPlayer.dmgCostReduction))
            eventPlayer.dmgCost = multiplyBySmallNb(eventPlayer.dmgCost, ShopCostMults.DMG)
    
    elif currentBoss >= ShopUnlockThresholds.MONEY_MULT and distance(eventPlayer.getPosition(), ShopPositions.MONEY_MULT) < 1:
        if isLessThanOrEqual(eventPlayer.moneyMultCost, eventPlayer.money):
            eventPlayer.moneyMult = add(eventPlayer.moneyMult, eventPlayer.moneyIncrement)
            eventPlayer.money = subtract(eventPlayer.money, eventPlayer.moneyMultCost)
            eventPlayer.moneyMultCost = multiplyBySmallNb(eventPlayer.moneyMultCost, ShopCostMults.MONEY_MULT)

            
    elif currentBoss >= ShopUnlockThresholds.DMG_MULT and distance(eventPlayer.getPosition(), ShopPositions.DMG_MULT) < 1:
        if isLessThanOrEqual(eventPlayer.dmgMultCost, eventPlayer.money):
            eventPlayer.dmgMult = multiplyBySmallNb(eventPlayer.dmgMult, DMG_MULT_VALUE)
            eventPlayer.dmgIncrement = multiplyBySmallNb(eventPlayer.dmgIncrement, DMG_MULT_VALUE)
            eventPlayer.money = subtract(eventPlayer.money, eventPlayer.dmgMultCost)
            eventPlayer.dmgMultCost = multiplyBySmallNb(eventPlayer.dmgMultCost, ShopCostMults.DMG_MULT)

    elif currentBoss >= ShopUnlockThresholds.CRIT_MULT and distance(eventPlayer.getPosition(), ShopPositions.CRIT_MULT) < 1:
        if isLessThanOrEqual(eventPlayer.critMultCost, eventPlayer.money):
            eventPlayer.critMult += CRIT_MULT_INCREMENT
            eventPlayer.money = subtract(eventPlayer.money, eventPlayer.critMultCost)
            eventPlayer.critMultCost = multiplyBySmallNb(eventPlayer.critMultCost, ShopCostMults.CRIT_MULT)

    elif currentBoss >= ShopUnlockThresholds.CRIT_CHANCE and distance(eventPlayer.getPosition(), ShopPositions.CRIT_CHANCE) < 1:
        if isLessThanOrEqual(eventPlayer.critChanceCost, eventPlayer.money):
            eventPlayer.critChance++
            eventPlayer.money = subtract(eventPlayer.money, eventPlayer.critChanceCost)
            eventPlayer.critChanceCost = multiplyBySmallNb(eventPlayer.critChanceCost, eventPlayer.critChance+1)
            
    elif currentBoss >= ShopUnlockThresholds.DMG_COST_REDUCTION and distance(eventPlayer.getPosition(), ShopPositions.DMG_COST_REDUCTION) < 1:
        if isLessThanOrEqual(eventPlayer.dmgCostReductionCost, eventPlayer.money):
            eventPlayer.dmgCostReduction = multiplyBySmallNb(eventPlayer.dmgCostReduction, DMG_REDUCTION_COST_MULT)
            eventPlayer.money = subtract(eventPlayer.money, eventPlayer.dmgCostReductionCost)
            eventPlayer.dmgCostReductionCost = multiplyBySmallNb(eventPlayer.dmgCostReductionCost, ShopCostMults.DMG_COST_REDUCTION)

    wait()
    if eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.CROUCH):
        goto RULE_START

#!mainFile "main.opy"


rule "dummies":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.isDummy()
    eventPlayer.setMaxHealth(20)
    eventPlayer.setDamageReceived(10000)
    #eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    bossEntity = eventPlayer
    eventPlayer.name = eventPlayer.getCurrentHero()
    wait()
    if DEBUG_SAME_BOSS_HEROES:
        eventPlayer.startForcingHero(Hero.TORBJORN)
    wait()
    eventPlayer.hpMultiplier = multiplyBySmallNb(bossHpMult[currentBoss], eventPlayer.getMaxHealth())
    while true:
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
        wait()


rule "destroy dummies when nobody is at boss":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.isDummy()
    @Condition gameStatus == GameStatus.IN_SHOP
    destroyDummy(Team.2, eventPlayer.getSlot())
        
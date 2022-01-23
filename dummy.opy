#!mainFile "main.opy"


rule "dummies":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.isDummy()
    eventPlayer.isFighting = true
    eventPlayer.setMaxHealth(20)
    eventPlayer.setDamageReceived(10000)
    #eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.currentBoss = bossHeroes.index(eventPlayer.getCurrentHero())
    bossEntities[eventPlayer.currentBoss] = eventPlayer
    eventPlayer.name = eventPlayer.getCurrentHero()
    wait()
    if DEBUG_SAME_BOSS_HEROES:
        eventPlayer.startForcingHero(Hero.TORBJORN)
    wait()
    eventPlayer.hpMultiplier = multiplyBySmallNb(bossHpMult[eventPlayer.currentBoss], eventPlayer.getMaxHealth())
    /*while true:
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
        wait()*/


rule "destroy dummy when nobody is at boss":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.isDummy()
    @Condition len([p for p in getPlayers(Team.1) if p.isFighting and p.currentBoss == eventPlayer.currentBoss]) == 0
    destroyDummy(Team.2, eventPlayer.getSlot())
        
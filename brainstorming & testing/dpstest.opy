
#OverPy starter pack

/*
[00:01:41] Took 53.30s for hero Reaper
[00:03:33] Took 104.44s for hero Tracer
[00:05:40] Took 121.21s for hero Mercy
[00:08:13] Took 89.44s for hero Hanzo
[00:09:13] Took 40.86s for hero Torbjörn
[00:10:37] Took 71.95s for hero Reinhardt
[00:14:47] Took 72.01s for hero Pharah
[00:17:12] Took 139.65s for hero Winston
[00:20:13] Took 78.64s for hero Widowmaker
[00:20:57] Took 30.48s for hero Bastion
[00:21:57] Took 30.48s for hero Symmetra
[00:23:33] Took 90.20s for hero Zenyatta
[00:26:31] Took 129.61s for hero Genji
[00:28:04] Took 82.67s for hero Roadhog
[00:28:52] Took 41.15s for hero McCree
[00:02:32] Took 78.09s for hero Junkrat
[00:05:43] Took 157.22s for hero Zarya
[00:07:17] Took 85.53s for hero Soldier: 76
[00:10:57] Took 194.72s for hero Lúcio
[00:13:26] Took 59.13s for hero D.Va
[00:14:58] Took 85.69s for hero Mei
[00:17:06] Took 120.67s for hero Sombra
[00:21:36] Took 99.80s for hero Doomfist
[00:24:23] Took 162.81s for hero Ana
[00:26:40] Took 93.69s for hero Orisa
[00:32:52] Took 96.99s for hero Brigitte
[00:35:04] Took 125.63s for hero Moira
[00:02:15] Took 114.28s for hero Wrecking Ball
[00:04:32] Took 130.51s for hero Ashe
[00:03:30] Took 88.44s for hero Echo
[00:07:18] Took 85.50s for hero Baptiste
[00:08:30] Took 66.25s for hero Sigma
*/

settings {
    "main": {
        "description": "Some awesome game mode"
    },
    "gamemodes": {
        "skirmish": {
            "enabledMaps": [
                "workshopChamber"
            ]
        },
        "general": {
            "heroLimit": "off",
            "respawnTime%": 30,
        }
    }
}

#33.74
#10.45
#21.94
#10.45

globalvar timer
globalvar heroIndex = 0
globalvar randomPoint

rule "init":
    print(timer)
    createDummy(Hero.MCCREE, Team.2, -1, null, null)
    setMatchTime(99999)
    pauseMatchTime()

rule "Teleport player on pressing interact":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    timer = 0
    chase(timer, 9999, rate=1, ChaseReeval.NONE)
    eventPlayer.setMaxAmmo(0, 99999)
    eventPlayer.setAmmo(0, 99999)
    eventPlayer.setUltCharge(100)
    while true:
        eventPlayer.setProjectileSpeed(100)
        wait()
    
rule "dummy":
    @Event eachPlayer
    @Condition eventPlayer.isDummy()
    wait()
    print(eventPlayer.getHealth())
    eventPlayer.setKnockbackReceived(0)
    eventPlayer.setMaxHealth(2222.2222222222*2)
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), hostPlayer.getEyePosition()), 9999, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    wait(10)
    hostPlayer.startFacing(directionTowards(hostPlayer.getEyePosition(), eventPlayer.getEyePosition()), 9999, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    /*while true:
        randomPoint = vect(random.uniform(-19, 19), 0, random.uniform(-19, 19))
        eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), randomPoint), 1, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.DIRECTION_AND_MAGNITUDE)
        wait(random.uniform(0.1, 1))*/

rule "Display position":
    @Event playerEarnedElimination
    stopChasingVariable(timer)
    printLog("Took {}s for hero {}".format(timer, getAllHeroes()[heroIndex]))
    #heroIndex++
    #hostPlayer.startForcingHero(getAllHeroes()[heroIndex])



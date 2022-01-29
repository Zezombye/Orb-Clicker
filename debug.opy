#!mainFile "main.opy"

#!define DEBUG_INSTAKILL false
#!define DEBUG_INVINCIBLE false
#!define DEBUG_HUGE_DMG false
#!define DEBUG_MONEY false
#!define DEBUG_SAME_BOSS_HEROES false

rule "insta kill":
    @Event eachPlayer
    @Condition gameStatus == GameStatus.FIGHTING
    @Condition DEBUG_INSTAKILL
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    kill(bossEntity, eventPlayer)


rule "":
    @Event playerTookDamage
    @Team 1
    smallMessage(victim, "took {} damage".format(eventDamage))
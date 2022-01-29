
#OverPy starter pack

settings {
    "main": {
        "description": "Some awesome game mode"
    },
    "gamemodes": {
        "skirmish": {
            "enabledMaps": [
                "oasis"
            ]
        },
        "general": {
            "heroLimit": "off",
            "respawnTime%": 30
        }
    },
    "heroes": {
        "allTeams": {
            "pharah": {
                "enableSecondaryFireUnlimitedFuel": true
            },
            "general": {
                "enableHeadshotsOnly": true
            }
        }
    }
}

globalvar i
globalvar nbSpheres = 0
globalvar positions = []

rule "init":
    print(nbSpheres)
    nbSpheres = 32
    positions = [vect(-187.999, 53.714, 116.579), vect(-187.68, 59, 0.437), vect(-187.909, 18, 56.487), vect(-194.671, 9, 25.029), vect(-163.787, 16, 22.174), vect(-164.039, 16, -22.175), vect(-188.376, 15.981, -0.409), vect(-194.36, 9, -26.312), vect(-209.161, 18.716, -59.169), vect(-187.763, 53.574, -121.065), vect(67.707, 2.116, -303.574), vect(83.898, 6.419, -310.817), vect(70.848, 7.5, -279.124), vect(152.073, 7.537, -258.077), vect(114.957, 9, -295.685), vect(114.844, 7.5, -248.443), vect(111.242, 11.501, -217.716), vect(142.877, 7.5, -220.137), vect(177.029, 5.5, -240.937), vect(173.216, 7.5, -176.523), vect(206.235, 6.419, -185.695), vect(239.869, 7.746, 134.814), vect(217.053, 0.999, 172.741), vect(194.92, 0.85, 206.221), vect(176.048, 4.101, 250.773), vect(127.888, 4, 231.505), vect(146.491, 4.101, 280.022), vect(111.808, 0.85, 299.021), vect(154.745, 10.982, 293.431), vect(142.029, 32.916, 305.4), vect(203.675, 32.916, 246.844), vect(70.324, 1, 319.488)]


rule "create spheres":
    for i in range(len(positions)):
        createEffect(getAllPlayers(), Effect.SPHERE, Color.WHITE, positions[i], 10, EffectReeval.VISIBILITY)
        wait()


rule "Teleport player on pressing interact":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    eventPlayer.teleport(eventPlayer.getEyePosition() + eventPlayer.getFacingDirection()*5)
    #Hold the player in place, to reset falling velocity
    eventPlayer.startForcingPosition(eventPlayer.getPosition(), false)
    wait()
    eventPlayer.stopForcingPosition()

rule "Display position":
    @Event eachPlayer
    print("Position of {}: {}".format(eventPlayer, eventPlayer.getPosition()))

rule "add sphere":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.WHITE, eventPlayer.getPosition(), 10, EffectReeval.VISIBILITY)
    positions.append(eventPlayer.getPosition())
    nbSpheres++


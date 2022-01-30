#!mainFile "main.opy"

settings {
    "main": {
        "description": "Orb Clicker (BETA - DO NOT SHARE)\nBy Zezombye & Vlosk"
    },
    "gamemodes": {
        "control": {
            "enabledMaps": [
                "oasis"
            ],
            "setValidControlPoints": "third",
        },
        "general": {
            "heroLimit": "off",
            "respawnTime%": 10,
            "gamemodeStartTrigger": "immediately",
        }
    },
    "heroes": {
        "allTeams": {
            "pharah": {
                "enableSecondaryFireUnlimitedFuel": true
            },
            "general": {
                "health%": 500,
                "damageDealt%": 500,
                "damageReceived%": 500,
                "abilityCooldown%": 1,
            }
        }
    }
}
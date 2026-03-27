extends Node2D
var STATE = "off"

var VALUES: Dictionary = {
	"game": {
		"TIME_FOR_GROWTH": 90,  # Slower scaling for better pacing
		"MIN_SPAWN_DISTANCE": 2000.0,
	},
	"player": {
		"MAX_HEALTH": 120.0,
		"MAX_EFFECT_DURATION": 20.0,
		"SPEED": 650.0,
	},
	"mobs": {
		"basic_mob": {
			"HEALTH": 30,
			"DAMAGE": 4,
			"SPEED": 120.0,
			"SCORE": 5,
		},
		"big_mob": {
			"HEALTH": 120,
			"DAMAGE": 8,
			"SPEED": 80.0,
			"SCORE": 25,
		},
		"fast_mob": {
			"HEALTH": 15,
			"DAMAGE": 3,
			"SPEED": 350.0,
			"SCORE": 12,
		},
		"inverter_mob": {
			"HEALTH": 40,
			"DAMAGE": 0,
			"SPEED": 130.0,
			"SCORE": 20,
			"EFFECT_DURATION": 8.0,
		},
		"matt_mob_secret": {
			"HEALTH": 1.0,  # Still almost one-shot
			"DAMAGE": 800,  # Slightly less one-shot potential
			"SPEED": 1800.0,  # Still very fast
			"SCORE": 1000,  # Extreme reward
		},
		"matt_mob": {
			"HEALTH": 0.1,
			"DAMAGE": 10, 
			"SPEED": 500.0,
			"SCORE": 250,
		},
		"poison_mob": {
			"HEALTH": 40,
			"DAMAGE": 3,
			"SPEED": 180.0,
			"SCORE": 18,
			"EFFECT_DURATION": 8.0,
		}
	},
	"weapons": {
		"needle": {
			"MAX_MAG_CAPACITY": 5,
			"RELOAD_TIME": 1.2,
			"projectile": {
				"DAMAGE": 40.0,
				"MAX_PENETRATION": 5,
				"SPEED": 1600.0,
				"LIFETIME": 10.0,
			}
		},
		"button": {
			"FIRE_RATE": 0.25,
			"projectile": {
				"DAMAGE": 5.0,
				"MAX_PENETRATION": 1,
				"SPEED": 800.0,
				"LIFETIME": 2.5,
			}
		},
		"ruler": {
			"SPIN_SPEED": 400.0,
			"DAMAGE": 7,
			"RATIO_MODE": 2
		},
		"scissors": {
			"DAMAGE": 30.0,
			"ATTACK_SPEED": 0.5
		}
	}
}

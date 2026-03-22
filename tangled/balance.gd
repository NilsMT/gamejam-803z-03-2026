extends Node2D
class_name BalanceValues

@export var VALUES: Dictionary = {
	"mobs" : {
		"basic_mob" : {
			"HEALTH" : 25,
			"DAMAGE" : 5,
			"SPEED" : 150.0,
			"SCORE" : 5,
		},
		"big_mob" : {
			"HEALTH" : 100,
			"DAMAGE" : 10,
			"SPEED" : 100.0,
			"SCORE" : 20,
		},
		"fast_mob" : {
			"HEALTH" : 20,
			"DAMAGE" : 5,
			"SPEED" : 400.0,
			"SCORE" : 10,
		},
		"inverter_mob" : {
			"HEALTH" : 50,
			"DAMAGE" : 0,
			"SPEED" : 150.0,
			"SCORE" : 15,
			"EFFECT_DURATION" : 10.0,
		},
		"matt_mob" : {
			"HEALTH" : 0.001,
			"DAMAGE" : 1000,
			"SPEED" : 2000.0,
			"SCORE" : 1000,
		},
		"poison_mob" : {
			"HEALTH" : 50,
			"DAMAGE" : 5,
			"SPEED" : 200.0,
			"SCORE" : 15,
			"EFFECT_DURATION" : 10.0,
		}
	},
	"weapons" : {
		"needle" : {
			"MAX_MAG_CAPACITY" : 3,
			"RELOAD_TIME" : 1.0,
			"projectile" : {
				"DAMAGE" : 25.0,
				"MAX_PENETRATION" : 5,
				"SPEED" : 500.0,
				"LIFETIME" : 5.0,
			}
		},
		"button" : {
			"FIRE_RATE" : 0.3,
			"projectile" : {
				"DAMAGE" : 2.5,
 				"MAX_PENETRATION" : 1,
				"SPEED" : 750.0,
				"LIFETIME" : 2.0,
			}
		},
		"ruler" : {
			"SPIN_SPEED" : 500.0,
			"DAMAGE" : 5,
			"RATIO_MODE" : 2
		},
		"scissors" : {
			"DAMAGE" : 12.5,
			"ATTACK_SPEED" : 2.0
		}
	}
}

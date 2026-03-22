extends Node2D

signal death_finished

func play_death():
	%AnimationPlayer.play("death")
	await %AnimationPlayer.animation_finished
	emit_signal("death_finished")

func play_walk():
	%AnimationPlayer.play("walk")
	
func play_hurt():
	%AnimationPlayer.play("hurt")
	await %AnimationPlayer.animation_finished
	%AnimationPlayer.play("RESET")

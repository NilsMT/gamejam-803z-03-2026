extends Node2D

func play_death():
	%AnimationPlayer.play("death")

func play_walk():
	%AnimationPlayer.play("walk")
	
func play_idle():
	%AnimationPlayer.play("idle")
	
func play_hurt():
	%AnimationPlayer.play("hurt")

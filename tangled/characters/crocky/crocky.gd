extends Node2D

signal animation_death_done

func play_death():
	%AnimationPlayer.play("death")
	await %AnimationPlayer.animation_finished
	animation_death_done.emit()

func play_walk():
	%AnimationPlayer.play("walk")
	
func play_idle():
	%AnimationPlayer.play("idle")

func _ready():
	%AnimationPlayer.play("idle")

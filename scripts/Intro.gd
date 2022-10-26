extends Node2D


func _ready():
	
	yield(get_tree().create_timer(3), "timeout")
	$AnimationPlayer.play("FadeIn")
	yield(get_tree().create_timer(6), "timeout")
	$AnimationPlayer.play("FadeOut")
	yield(get_tree().create_timer(6), "timeout")
	get_tree().change_scene("res://scenes/MainMenu.tscn")

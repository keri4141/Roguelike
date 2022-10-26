extends Button

export(Color,RGB) var mouse_entered
export(Color,RGB) var mouse_exited

func _on_NewGame_mouse_entered():
	set_modulate(mouse_entered)


func _on_NewGame_mouse_exited():
	set_modulate(mouse_exited)


func _on_NewGame_pressed():
	.get_tree().change_scene("res://scenes/test/PlayerTest.tscn")
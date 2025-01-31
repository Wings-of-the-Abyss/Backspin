extends Control

func _on_buttons_mouse_entered() -> void:
	$hover.play()

func _on_quit_pressed() -> void:
	get_tree().quit() # Replace with function body.


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/settings.tscn") # Replace with function body.


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")

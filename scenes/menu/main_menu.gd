extends Control
@onready var transition: AnimationPlayer = $transition

func _ready() -> void:
	pass

func _on_buttons_mouse_entered() -> void:
	$hover.play()

func _on_quit_pressed() -> void:
	get_tree().quit() # Replace with function body.


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/settings.tscn") # Replace with function body.


func _on_play_pressed():
	transition.play("fade-out")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")

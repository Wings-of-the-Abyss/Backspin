extends Control

@onready var transition: AnimationPlayer = $transition
@onready var click = $click

func _on_buttons_mouse_entered() -> void:
	$hover.play()

func _on_quit_pressed() -> void:
	click.play()
	transition.play("fade-out")
	await transition.animation_finished
	get_tree().quit() # Replace with function body.


func _on_options_pressed() -> void:
	click.play()
	get_tree().change_scene_to_file("res://scenes/menu/settings.tscn") # Replace with function body.


func _on_play_pressed():
	click.play()
	transition.play("fade-out")
	PlayerData.ActionPoints.clear()
	await get_tree().create_timer(1.0).timeout
	PlayerData.HP = 100
	TurnManager.reset()
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")

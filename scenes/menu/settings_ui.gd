extends Control

@onready var Masterbus = $MarginContainer/Panel/VBoxContainer/MarginContainer/VBoxContainer/MasterVolume/HSlider
@onready var SFXBus = $MarginContainer/Panel/VBoxContainer/MarginContainer/VBoxContainer/SFXVolume/HSlider
@onready var MusicBus = $MarginContainer/Panel/VBoxContainer/MarginContainer/VBoxContainer/MusicVolume/HSlider

func _ready():
	Masterbus.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	SFXBus.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	MusicBus.value = db_to_linear(AudioServer.get_bus_volume_db(2))

func _on_master_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))

func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))

func _unhandled_input(event):
	if Input.is_action_just_pressed("exit"):
		exit()

func exit():
	get_tree().change_scene_to_file("res://scenes/menu/main menu.tscn")

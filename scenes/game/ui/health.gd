extends Control

@onready var hp = $VBoxContainer/HP
@onready var hype = $VBoxContainer/HYPE

func _process(delta):
	hp.value = PlayerData.HP
	hype.value = PlayerData.Hype

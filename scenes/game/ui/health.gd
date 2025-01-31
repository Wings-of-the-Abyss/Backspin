extends Control

@onready var hp = $VBoxContainer/HP
@onready var hype = $VBoxContainer/HYPE

func _ready():
	PlayerData.damage_taken.connect(tween_health)
	PlayerData.hype_updated.connect()

func tween_health() -> void:
	pass

func tween_hype() -> void

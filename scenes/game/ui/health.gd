extends Control

@onready var hp = $HP
@onready var hype = $HYPE

func _ready():
	PlayerData.damage_taken.connect(tween_health)
	PlayerData.hype_updated.connect(tween_hype)
	hp.value = PlayerData.HP
	hype.value = PlayerData.Hype

func tween_health() -> void:
	var t = get_tree().create_tween()
	t.tween_property(hp, "value", PlayerData.HP, 0.5)

func tween_hype() -> void:
	var t = get_tree().create_tween()
	t.tween_property(hype, "value", PlayerData.Hype, 0.5)

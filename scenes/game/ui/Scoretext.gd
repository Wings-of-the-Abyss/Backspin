extends Control

var label_config = preload("res://scenes/menu/settings_ui.gd")

func _ready():
	PlayerData.HypeMax.connect(spawn_hypetext)
	PlayerData.NoteHit.connect(spawntext)

func spawntext(score: int):
	var label = Label.new()
	var quality = score > 0
	if quality: quality = "Good!"
	else: quality = "Eh..."
	label.text = quality
	label.label_settings = label_config
	add_child(label)
	var t_Pos = get_tree().create_tween()
	var t_Vis = get_tree().create_tween()
	t_Pos.tween_property(label, "position", label.position + Vector2(0, 32.0), 1.5)
	t_Vis.tween_property(label, "modulate", Color.TRANSPARENT, 1.0)
	await t_Vis.finished
	label.queue_free()

func spawn_hypetext() -> void:
	var label = Label.new()
	label.text = "Hype Hit!"
	label.label_settings = label_config
	add_child(label)
	var t_Pos = get_tree().create_tween()
	var t_Vis = get_tree().create_tween()
	t_Pos.tween_property(label, "position", label.position + Vector2(0, 32.0), 1.5)
	t_Vis.tween_property(label, "modulate", Color.TRANSPARENT, 1.0)
	await t_Vis.finished
	label.queue_free()

extends TextureProgressBar



func _process(delta):
	if !TurnManager.ActiveBoss: return
	if value != TurnManager.ActiveBoss.Health:
		update()

func update() -> void:
	var t = get_tree().create_tween()
	t.tween_property(self, "value", TurnManager.ActiveBoss.Health, 0.1)

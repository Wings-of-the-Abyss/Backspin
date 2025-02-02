extends TextureProgressBar

func _process(_delta):
	if !TurnManager.ActiveBoss: return
	if value != TurnManager.ActiveBoss.Hype:
		update()

func update() -> void:
	var t = get_tree().create_tween()
	t.tween_property(self, "value", TurnManager.ActiveBoss.Hype, 0.1)

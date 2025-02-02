extends AnimationPlayer

const ENEMY_1 = preload("res://scenes/game/Opponents/enemy_1.tscn")
const ENEMY_2 = preload("res://scenes/game/Opponents/enemy_2.tscn")

const ENEMY_ORDER = [
	ENEMY_1,
	ENEMY_2
]

func _ready():
	TurnManager.boss_down.connect(remove_old)

func remove_old():
	if is_playing(): return
	if TurnManager.ActiveBoss.Health > 0: return
	await get_tree().create_timer(0.5).timeout
	var t = get_tree().create_tween()
	t.tween_property(TurnManager.ActiveBoss, "position", Vector3(-100, 21, -7), 0.5)
	add_new()

func add_new():
	var index = TurnManager.BossIndex
	if index >= ENEMY_ORDER.size():
		print("out of bosses :( ")
		await get_tree().create_timer(5.0).timeout
		TurnManager.on_death()
		return
	var e = ENEMY_ORDER[index].instantiate()
	get_tree().root.get_node("/root/Game").add_child(e)
	e.position = Vector3(-9, 50, -7)
	e.scale = Vector3.ONE*12
	var t = get_tree().create_tween()
	t.tween_property(e, "position", Vector3(-9, 21.6, -7), 0.5)

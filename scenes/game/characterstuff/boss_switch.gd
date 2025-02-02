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
	play("Remove_dead")
	await animation_finished
	TurnManager.ActiveBoss.queue_free()
	add_new()

func add_new():
	var index = TurnManager.BossIndex
	if ENEMY_ORDER.size() >= index:
		print("out of bosses :( ")
		TurnManager.on_death()
	var e = ENEMY_ORDER[index].instantiate()
	get_tree().root.get_node("/root/Game").add_child(e)
	e.position = Vector3(-9, 50, -7)
	e.scale = Vector3.ONE*12
	var t = get_tree().create_tween()
	t.tween_property(e, "position", Vector3(-9, 21.6, -7), 0.5)

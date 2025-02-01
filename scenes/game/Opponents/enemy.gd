extends AnimatedSprite3D

@export var EnemyMoves: Array[Move] = []
var Health: float = 100
@onready var anims = $AnimationPlayer

signal downed

func _ready():
	PlayerData.NoteHit.connect(take_damage)
	TurnManager.set("ActiveBoss", self)

func take_damage(amount: float) -> void:
	if !TurnManager.turn: return
	Health -= amount
	if Health <= 0:
		downed.emit()
		anims.play("die")

func EnemyNote(n: StringName):
	match n:
		&"left":
			anims.play("leftHit")
		&"up":
			anims.play("upHit")
		&"right":
			anims.play("rightHit")
		&"down":
			anims.play("downHit")
	await anims.animation_finished
	anims.play("idle")

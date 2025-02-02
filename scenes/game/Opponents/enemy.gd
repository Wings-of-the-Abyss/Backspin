extends AnimatedSprite3D

@export var EnemyMoves: Array[Move] = []
var Health: float = 500
var Hype: float = 0.0
@onready var anims = $AnimationPlayer

signal downed

func _ready():
	Health = 500.0
	Hype = 0.0
	TurnManager.set("ActiveBoss", self)

func take_damage(amount: float) -> void:
	if !TurnManager.turn: amount /= 2
	Health -= amount
	if Health <= 0:
		downed.emit()
		anims.play("die")

func _process(_delta):
	if Hype >= 100.0:
		Health = min(100.0, Health + 100/3)
		Hype = 0

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

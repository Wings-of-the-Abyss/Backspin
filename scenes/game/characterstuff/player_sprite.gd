extends AnimatedSprite3D

@onready var player_anim = $PlayerAnim

func NoteHit(n: StringName):
	if !TurnManager.turn:
		match n:
			&"left":
				player_anim.play("leftHit")
			&"up":
				player_anim.play("upHit")
			&"right":
				player_anim.play("rightHit")
			&"down":
				player_anim.play("downHit")
		await player_anim.animation_finished
		player_anim.play("idle")

func MoveHit(M: StringName) -> void:
	player_anim.play(M)

func hypehit() -> void:
	player_anim.play("hype")
	await player_anim.animation_changed
	player_anim.play("idle")

func die() -> void:
	player_anim.play("die")

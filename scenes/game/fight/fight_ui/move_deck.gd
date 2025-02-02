extends Control

const BACKSPIN = preload("res://scenes/game/Moves/playermoves/backspin.tres")
const HEADSPIN = preload("res://scenes/game/Moves/playermoves/headspin.tres")
const STEPIN = preload("res://scenes/game/Moves/playermoves/stepin.tres")
const STEPOUT = preload("res://scenes/game/Moves/playermoves/stepout.tres")
const SWEEPDOWN = preload("res://scenes/game/Moves/playermoves/sweepdown.tres")

const hand: Array[Move] = [
	BACKSPIN,
	HEADSPIN,
	STEPIN,
	STEPOUT,
	SWEEPDOWN
]

const ARROW_DOWN = preload("res://assets/arrows/Arrowblue_single.png")
const ARROW_LEFT = preload("res://assets/arrows/Arrowgreen_single.png")
const ARROW_RIGHT = preload("res://assets/arrows/Arroworange_single.png")
const ARROW_UP = preload("res://assets/arrows/Arrowred_single.png")

@onready var move_1 = $HBoxContainer/move1
@onready var move_2 = $HBoxContainer/move2
@onready var move_3 = $HBoxContainer/move3
@onready var move_4 = $HBoxContainer/move4
@onready var move_5 = $HBoxContainer/move5

@onready var h_box_container = $HBoxContainer
@onready var animation_player = $AnimationPlayer
@onready var APdisplay = $HBoxContainer/Control/HBoxContainer2

func _ready():
	randomize()
	TurnManager.player_turn_started.connect(show_hand)
	animation_player.play_backwards("down")
	show()

func show_hand() -> void:
	animation_player.play_backwards("down")
	set_deck_visible(true)

func _unhandled_input(_event) -> void:
	if TurnManager.queue.size() > 0 and Input.is_action_just_pressed("ui_accept"):
		TurnManager.selection_complete()
		animation_player.play("down")
		await animation_player.animation_finished
		set_deck_visible(false)
	
	if Input.is_action_just_pressed("card1"):
		_on_move_1_button_down()
	elif Input.is_action_just_pressed("card2"):
		_on_move_2_button_down()
	elif Input.is_action_just_pressed("card3"):
		_on_move_3_button_down()
	elif Input.is_action_just_pressed("card4"):
		_on_move_4_button_down()
	elif Input.is_action_just_pressed("card5"):
		_on_move_5_button_down()

func refreshAPDisplay() -> void:
	for c in APdisplay.get_children():
		c.texture = null
	for n in range(PlayerData.ActionPoints.size()):
		var node = APdisplay.get_child(n)
		if not node:
			APdisplay.add_child(TextureRect.new())
			node = APdisplay.get_child(n) as TextureRect
			node.expand_mode = TextureRect.EXPAND_FIT_WIDTH
			node.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
		var texture
		match PlayerData.ActionPoints[n]:
			&"left":
				texture = ARROW_LEFT
			&"up":
				texture = ARROW_UP
			&"right":
				texture = ARROW_RIGHT
			&"down":
				texture = ARROW_DOWN
		node.texture = texture
		

func set_deck_visible(b: bool) -> void:
	for B in h_box_container.get_children():
		B.visible = b

func _on_move_1_button_down() -> void:
	if TurnManager.add_move_to_queue(hand[0]):
		var t = get_tree().create_tween()
		t.tween_property(move_1, "position", Vector2(move_1.position.x, 0), 0.2)
		await t.finished
		move_1.hide()
		refreshAPDisplay()

func _on_move_2_button_down() -> void:
	if TurnManager.add_move_to_queue(hand[1]):
		var t = get_tree().create_tween()
		t.tween_property(move_2, "position", Vector2(move_2.position.x, 0), 0.2)
		await t.finished
		move_2.hide()
		refreshAPDisplay()

func _on_move_3_button_down() -> void:
	if TurnManager.add_move_to_queue(hand[2]):
		var t = get_tree().create_tween()
		t.tween_property(move_3, "position", Vector2(move_3.position.x, 0), 0.2)
		await t.finished
		move_3.hide()
		refreshAPDisplay()

func _on_move_4_button_down() -> void:
	if TurnManager.add_move_to_queue(hand[3]):
		var t = get_tree().create_tween()
		t.tween_property(move_4, "position", Vector2(move_4.position.x, 0), 0.2)
		await t.finished
		move_4.hide()
		refreshAPDisplay()

func _on_move_5_button_down() -> void:
	if TurnManager.add_move_to_queue(hand[4]):
		var t = get_tree().create_tween()
		t.tween_property(move_5, "position", Vector2(move_5.position.x, 0), 0.2)
		await t.finished
		move_5.hide()
		refreshAPDisplay()

func _on_move_mouse_entered(button: int):
	var hover = h_box_container.get_child(button-1)
	var t = get_tree().create_tween()
	t.tween_property(hover, "position", Vector2(hover.position.x, -200), 0.2)

func _on_move_mouse_exited(button: int):
	var hover = h_box_container.get_child(button-1)
	var t = get_tree().create_tween()
	t.tween_property(hover, "position", Vector2(hover.position.x, -170), 0.2)

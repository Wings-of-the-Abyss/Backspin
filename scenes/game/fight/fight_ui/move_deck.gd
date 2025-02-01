extends Control

var hand: Array[Move] = []

const ARROW_DOWN = preload("res://assets/arrows/Arrowblue_single.png")
const ARROW_LEFT = preload("res://assets/arrows/Arrowgreen_single.png")
const ARROW_RIGHT = preload("res://assets/arrows/Arroworange_single.png")
const ARROW_UP = preload("res://assets/arrows/Arrowred_single.png")

@onready var move_1 = $HBoxContainer/move1
@onready var move_2 = $HBoxContainer/move2
@onready var move_3 = $HBoxContainer/move3
@onready var move_4 = $HBoxContainer/move4
@onready var h_box_container = $HBoxContainer
@onready var animation_player = $AnimationPlayer
@onready var APdisplay = $HBoxContainer/HBoxContainer2

func _ready():
	randomize()
	TurnManager.player_turn_started.connect(create_hand)
	await get_tree().create_timer(0.5).timeout
	if hand.is_empty():
		create_hand()
	show()

func create_hand() -> void:
	var newhand: Array[Move] = []
	for i in range(4):
		newhand.append(PlayerData.MoveDeck.pick_random())
	var index = 0
	for N in newhand:
		var button = h_box_container.get_child(index)
		var slot = 0
		for i in N.Notes:
			var note_slot = button.get_child(slot) as TextureRect
			var texture
			match i:
				&"left":
					texture = ARROW_LEFT
				&"up":
					texture = ARROW_UP
				&"right":
					texture = ARROW_RIGHT
				&"down":
					texture = ARROW_DOWN
			note_slot.texture = texture
			slot += 1
		index += 1
	hand = newhand
	
	refreshAPDisplay()
	set_deck_visible(true)
	animation_player.play_backwards("down")

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
	h_box_container.visible = b

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

func _on_move_mouse_entered(button: int):
	var hover = h_box_container.get_child(button-1)
	var t = get_tree().create_tween()
	t.tween_property(hover, "position", Vector2(hover.position.x, -200), 0.2)

func _on_move_mouse_exited(button: int):
	var hover = h_box_container.get_child(button-1)
	var t = get_tree().create_tween()
	t.tween_property(hover, "position", Vector2(hover.position.x, -170), 0.2)

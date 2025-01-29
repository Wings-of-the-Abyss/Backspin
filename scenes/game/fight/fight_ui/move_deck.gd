extends Control

var hand: Array[Move] = []

@onready var move_1 = $HBoxContainer/move1
@onready var move_2 = $HBoxContainer/move2
@onready var move_3 = $HBoxContainer/move3
@onready var move_4 = $HBoxContainer/move4

func _ready():
	randomize()
	TurnManager.player_turn_started.connect(create_hand)

func create_hand() -> void:
	var newhand = []
	for i in range(4):
		newhand.append(PlayerData.MoveDeck.pick_random())
	hand = newhand
	move_1.disabled = false
	move_2.disabled = false
	move_3.disabled = false
	move_4.disabled = false

func _unhandled_input(event) -> void:
	if TurnManager.queue.size() > 0 and Input.is_action_just_pressed("ui_accept"):
		TurnManager.execute_queue()
		move_1.disabled = true
		move_2.disabled = true
		move_3.disabled = true
		move_4.disabled = true

func _on_move_1_button_down() -> void:
	TurnManager.add_move_to_queue(hand[0])

func _on_move_2_button_down() -> void:
	TurnManager.add_move_to_queue(hand[1])

func _on_move_3_button_down() -> void:
	TurnManager.add_move_to_queue(hand[2])

func _on_move_4_button_down() -> void :
	TurnManager.add_move_to_queue(hand[3])

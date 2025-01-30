extends Control

var hand: Array[Move] = []

@onready var move_1 = $HBoxContainer/move1
@onready var move_2 = $HBoxContainer/move2
@onready var move_3 = $HBoxContainer/move3
@onready var move_4 = $HBoxContainer/move4
@onready var h_box_container = $HBoxContainer

func _ready():
	randomize()
	TurnManager.player_turn_started.connect(create_hand)
	TurnManager.setup_complete = true

func create_hand() -> void:
	var newhand: Array[Move] = []
	for i in range(4):
		newhand.append(PlayerData.MoveDeck.pick_random())
	hand = newhand
	set_deck_visible(true)

func _unhandled_input(event) -> void:
	if TurnManager.queue.size() > 0 and Input.is_action_just_pressed("ui_accept"):
		TurnManager.selection_complete()
		set_deck_visible(false)

func set_deck_visible(b: bool) -> void:
	h_box_container.visible = b

func _on_move_1_button_down() -> void:
	TurnManager.add_move_to_queue(hand[0])
	print(hand[0])

func _on_move_2_button_down() -> void:
	TurnManager.add_move_to_queue(hand[1])

func _on_move_3_button_down() -> void:
	TurnManager.add_move_to_queue(hand[2])

func _on_move_4_button_down() -> void:
	TurnManager.add_move_to_queue(hand[3])

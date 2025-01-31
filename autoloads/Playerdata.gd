extends Node

const EXAMPLE = preload("res://scenes/game/Moves/Example.tres")

var MoveDeck: Array[Move] = [
	EXAMPLE,
]
var ActionPoints: Array[StringName] = []

var HP: int = 100
var Hype: int = 0

signal died

func _ready():
	died.connect(TurnManager.on_death)

func update_hype(amount: int):
	Hype += amount
	if Hype >= 100:
		HP = min(HP + 25, 100)
		Hype = 75

func deal_damage(amount: int) -> void:
	HP -= amount
	if HP <= 0:
		died.emit()

func add_to_deck(m: Move) -> void:
	#add additional deck adding  logic here
	MoveDeck.append(m)

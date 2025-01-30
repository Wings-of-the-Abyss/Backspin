extends Node

const EXAMPLE = preload("res://scenes/game/Moves/Example.tres")

var CurrentScore: int = 0
var Combo: int = 1
var MoveDeck: Array[Move] = [
	EXAMPLE,
]
var ActionPoints: Array[StringName] = []

func update_score(amount: int):
	if amount < 0:
		Combo = 1
	CurrentScore = max(0, CurrentScore + (amount*Combo))

func add_to_deck(m: Move) -> void:
	#add additional deck adding  logic here
	MoveDeck.append(m)

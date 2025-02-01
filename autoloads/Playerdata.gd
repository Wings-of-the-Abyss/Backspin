extends Node

const movePath = "res://scenes/game/Moves/playermoves/"
var MoveDeck: Array[Move] = [
	
]
var ActionPoints: Array[StringName] = []

var HP: int = 100
var Hype: int = 0

signal died
signal damage_taken
signal hype_updated

signal HypeMax
signal NoteHit(value: int)

func _ready():
	var movelist = DirAccess.get_files_at(movePath)
	for M in movelist:
		MoveDeck.append(load(movePath + M))
	died.connect(TurnManager.on_death)

func update_hype(amount: int):
	Hype = max(0, Hype+amount)
	NoteHit.emit(amount)
	hype_updated.emit()
	if Hype >= 100:
		HypeMax.emit()
		get_tree().get_first_node_in_group("player").hypehit()
		HP = 100
		Hype = 0

func deal_damage(amount: int) -> void:
	HP -= amount
	damage_taken.emit()
	if HP <= 0:
		died.emit()

func add_to_deck(m: Move) -> void:
	#add additional deck adding  logic here
	MoveDeck.append(m)

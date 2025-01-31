extends Node

@onready var notecatcher = $Notecatcher

var FallingNotes: Dictionary = {}
var FreedNotes: Array[Note] = []

const ARROW_DOWN = preload("res://assets/arrows/Arrowblue_single.png")
const ARROW_LEFT = preload("res://assets/arrows/Arrowgreen_single.png")
const ARROW_RIGHT = preload("res://assets/arrows/Arroworange_single.png")
const ARROW_UP = preload("res://assets/arrows/Arrowred_single.png")

var note_startY = 256.0

@export var enemy: bool = false

func _unhandled_input(_event):
	if TurnManager.active_notes.is_empty() or TurnManager.turn: return
	for N in TurnManager.active_notes:
		if abs(N.time_window) <= 0.075:
			FreedNotes.append(N)
			FallingNotes.get(N).hide()
		

func _process(delta):
	if FallingNotes.is_empty(): return
	for N in FallingNotes.keys():
		if N.time_window <= -1.0:
			FreedNotes.append(N)
			continue
		N.time_window -= delta
		var node = FallingNotes.get(N)
		node.position.y = (note_startY*N.time_window)+notecatcher.position.y

func note_cleanup() -> void:
	if FreedNotes.is_empty(): return
	for FN in FreedNotes:
		if FallingNotes.get(FN) != null:
			FallingNotes.get(FN).queue_free()
		FallingNotes.erase(FN)
		TurnManager.active_notes.erase(FN)

func add_note(type: StringName, id: Note) -> void:
	var sprite = Sprite2D.new()
	var texture
	var startpos = Vector2(notecatcher.position.x, 256)
	
	match type:
		&"left":
			texture = ARROW_LEFT
			startpos.x += 8
		&"up":
			texture = ARROW_UP
			startpos.x += -55
		&"right":
			texture = ARROW_RIGHT
			startpos.x += 49
		&"down":
			texture = ARROW_DOWN
			startpos.x += -25
	
	if texture:
		sprite.scale = Vector2.ONE*0.125
		sprite.texture = texture
		add_child(sprite)
		sprite.position = startpos
		FallingNotes[id] = sprite

func add_note_inverse(note_type: StringName, note: Note) -> void:
	match note_type:
		&"left":
			add_note(&"right", note)
		&"up":
			add_note(&"down", note)
		&"right":
			add_note(&"left", note)
		&"down":
			add_note(&"up", note)

func _on_timer_timeout():
	note_cleanup()

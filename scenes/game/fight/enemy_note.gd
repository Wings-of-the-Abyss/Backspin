extends Node

@onready var notecatcher = $Notecatcher

var FallingNotes: Dictionary = {}
var FreedNotes: Array[Note] = []

const ARROW_DOWN = preload("res://assets/arrows/Arrowblue_single.png")
const ARROW_LEFT = preload("res://assets/arrows/Arrowgreen_single.png")
const ARROW_RIGHT = preload("res://assets/arrows/Arroworange_single.png")
const ARROW_UP = preload("res://assets/arrows/Arrowred_single.png")

var note_startY = 1024.0

signal move(n: StringName)

func _process(delta):
	if FallingNotes.is_empty(): return
	
	for N in FallingNotes.keys():
		if abs(N.time_window) < 0.05:
			FreedNotes.append(N)
			FallingNotes.get(N).hide()
			move.emit(N.assigned_input)
		N.time_window -= delta/3
		var node = FallingNotes.get(N)
		node.position.y = (note_startY*N.time_window/2)+notecatcher.position.y
	
	note_cleanup()

func note_cleanup() -> void:
	if FreedNotes.is_empty(): return
	for FN in FreedNotes:
		if !FallingNotes.has(FN): continue
		FallingNotes.get(FN).queue_free()
		FallingNotes.erase(FN)
		TurnManager.active_notes.erase(FN)
	FreedNotes.clear()

func add_note(type: StringName, id: Note) -> void:
	var sprite = Sprite2D.new()
	var texture
	var startpos = Vector2(notecatcher.position.x, note_startY)
	
	match type:
		&"left":
			texture = ARROW_LEFT
			startpos.x += 78
		&"up":
			texture = ARROW_UP
			startpos.x += 12.5
		&"right":
			texture = ARROW_RIGHT
			startpos.x += 115
		&"down":
			texture = ARROW_DOWN
			startpos.x += 42

	if texture:
		sprite.scale = Vector2.ONE*0.1
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

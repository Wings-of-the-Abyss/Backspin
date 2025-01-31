extends Node

@onready var NoteCatcher = $Notecatcher

var FallingNotes: Dictionary = {}
var FreedNotes: Array[Note] = []

@onready var notecatcher = $Notecatcher

const ARROW_DOWN = preload("res://assets/arrows/Arrowblue_single.png")
const ARROW_LEFT = preload("res://assets/arrows/Arrowgreen_single.png")
const ARROW_RIGHT = preload("res://assets/arrows/Arroworange_single.png")
const ARROW_UP = preload("res://assets/arrows/Arrowred_single.png")

var note_startY = 256.0

func _unhandled_input(_event):
	if TurnManager.active_notes.is_empty(): return
	for N in TurnManager.active_notes:
		var input = (
			(Input.is_action_just_pressed("left") and N.assigned_input ==  &"left") or
			(Input.is_action_just_pressed("up") and N.assigned_input ==  &"up") or
			(Input.is_action_just_pressed("right") and N.assigned_input ==  &"right") or
			(Input.is_action_just_pressed("down") and N.assigned_input ==  &"down")
			)
		
		var score = 0
		if input:
			var poptime = abs(N.time_window)
			if poptime < 0.2:
				FreedNotes.append(N)
				score = 30 * (1-poptime) 
				print("Hit!")
			else:
				score = -30
				print("miss...")
		
		
		if score != 0: PlayerData.update_hype(score)

func _process(delta):
	if TurnManager.active_notes.is_empty(): return
	for N in TurnManager.active_notes:
		if N.time_window <= -1.0:
			FreedNotes.append(N)
			continue
		N.time_window -= delta
		var node = FallingNotes.get(N)
		node.position.y = (note_startY*N.time_window)+notecatcher.position.y
	
	note_cleanup()

func note_cleanup() -> void:
	for FN in FreedNotes:
		FallingNotes.get(FN).queue_free()
		FallingNotes.erase(FN)
		TurnManager.active_notes.erase(FN)

func add_note(type: StringName, id: Note) -> void:
	var sprite = Sprite2D.new()
	var texture
	var startpos = Vector2(0, 256)
	
	match type:
		&"left":
			texture = ARROW_LEFT
			startpos.x = 327.0
		&"up":
			texture = ARROW_UP
			startpos.x = 248.5
		&"right":
			texture = ARROW_RIGHT
			startpos.x = 279.0
		&"down":
			texture = ARROW_DOWN
			startpos.x = 286.0
	
	if texture:
		sprite.scale = Vector2.ONE*0.125
		sprite.texture = texture
		add_child(sprite)
		sprite.position = startpos
		FallingNotes[id] = sprite

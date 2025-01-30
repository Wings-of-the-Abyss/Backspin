extends Node

@onready var NoteCatcher = $Notecatcher

var FallingNotes: Dictionary = {}

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
		
		var score = 0.0
		if input:
			var poptime = abs(N.time_window)
			if poptime < 0.2:
				print("Hit!")
			else:
				print("miss...")
		
		
		if score != 0.0: PlayerData.update_score(score)

func _process(delta):
	if TurnManager.active_notes.is_empty(): return
	var freed_notes = []
	for N in TurnManager.active_notes:
		if N.time_window <= -1.0:
			freed_notes.append(N)
			continue
		N.time_window -= delta
		var node = FallingNotes.get(N)
		node.position.y = (note_startY*N.time_window)+notecatcher.position.y
	for FN in freed_notes:
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
			startpos.x = 139.0
		&"up":
			texture = ARROW_UP
			startpos.x = 59.5
		&"right":
			texture = ARROW_RIGHT
			startpos.x = 188.0
		&"down":
			texture = ARROW_DOWN
			startpos.x = 96.0
	
	if texture:
		sprite.scale = Vector2.ONE*0.125
		sprite.texture = texture
		add_child(sprite)
		sprite.position = startpos
		FallingNotes[id] = sprite

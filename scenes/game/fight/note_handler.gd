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
	if TurnManager.active_notes.is_empty(): return
	for N in FallingNotes.keys():
		var input = (
			(Input.is_action_just_pressed("left") and N.assigned_input ==  &"left") or
			(Input.is_action_just_pressed("up") and N.assigned_input ==  &"up") or
			(Input.is_action_just_pressed("right") and N.assigned_input ==  &"right") or
			(Input.is_action_just_pressed("down") and N.assigned_input ==  &"down")
			)
		
		var hype: int = 0
		if input:
			var poptime = abs(N.time_window)
			if poptime*100 < 5.0:
				FreedNotes.append(N)
				FallingNotes.get(N).hide()
				hype += floor(25 * (1-poptime)*N.hype_mult)
				print("Hit!")
			else:
				hype = -30
				print("miss...")
				if !TurnManager.turn:
					PlayerData.deal_damage(10)
		
		
		if hype != 0: PlayerData.update_hype(hype)

func _process(delta):
	if FallingNotes.is_empty(): return
	for N in FallingNotes.keys():
		if N.time_window <= -0.5 and !FreedNotes.has(N):
			FreedNotes.append(N)
			PlayerData.update_hype(-10)
			if !TurnManager.turn:
				PlayerData.deal_damage(10)
			continue
		N.time_window -= delta
		var node = FallingNotes.get(N)
		node.position.y = (note_startY*N.time_window)+notecatcher.position.y

func note_cleanup() -> void:
	if FreedNotes.is_empty(): return
	for FN in FreedNotes:
		FallingNotes.get(FN)
		FallingNotes.erase(FN)
		TurnManager.active_notes.erase(FN)
	FreedNotes.clear()

func add_note(type: StringName, id: Note) -> void:
	var sprite = Sprite2D.new()
	var texture
	var startpos = Vector2(notecatcher.position.x, 256)
	
	match type:
		&"left":
			texture = ARROW_LEFT
			startpos.x += 16
		&"up":
			texture = ARROW_UP
			startpos.x += -110
		&"right":
			texture = ARROW_RIGHT
			startpos.x += 98
		&"down":
			texture = ARROW_DOWN
			startpos.x += -50
	
	if texture:
		sprite.scale = Vector2.ONE*0.2
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

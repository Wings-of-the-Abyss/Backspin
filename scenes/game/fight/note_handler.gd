extends Node

@onready var notecatcher = $Notecatcher
@onready var notehit_up = $NotehitUp
@onready var notehit_down = $NotehitDown
@onready var notehit_left = $NotehitLeft
@onready var notehit_right = $NotehitRight
@onready var up = $Up
@onready var down = $Down
@onready var left = $Left
@onready var right = $Right

var FallingNotes: Dictionary = {}
var FreedNotes: Array[Note] = []

const ARROW_DOWN = preload("res://assets/arrows/Arrowblue_single.png")
const ARROW_LEFT = preload("res://assets/arrows/Arrowgreen_single.png")
const ARROW_RIGHT = preload("res://assets/arrows/Arroworange_single.png")
const ARROW_UP = preload("res://assets/arrows/Arrowred_single.png")

var note_startY = 1024.0

@export var enemy: bool = false

func _ready():
	up.restart()
	await up.finished
	up.show()
	left.restart()
	await left.finished
	left.show()
	right.restart()
	await right.finished
	right.show()
	down.restart()
	await down.finished
	down.show()

func _physics_process(delta):
	if TurnManager.active_notes.is_empty(): return
	for N in FallingNotes.keys():
		if N.time_window > 0.5: continue
		var input = (
			(Input.is_action_just_pressed("left") and N.assigned_input ==  &"left") or
			(Input.is_action_just_pressed("up") and N.assigned_input ==  &"up") or
			(Input.is_action_just_pressed("right") and N.assigned_input ==  &"right") or
			(Input.is_action_just_pressed("down") and N.assigned_input ==  &"down")
			)
		
		var hype: int = 0
		if input:
			var poptime = abs(N.time_window)
			if poptime*100 < 7.5:
				get_tree().get_first_node_in_group("player").NoteHit(N.assigned_input)
				FreedNotes.append(N)
				FallingNotes.get(N).hide()
				hype += floor(20 * N.hype_mult)
				hit_audio(N.assigned_input)
				print("Hit!")
			else:
				hype = -30
				print("miss...")
				if !TurnManager.turn:
					PlayerData.deal_damage(10)
		
		if hype != 0: 
			PlayerData.update_hype(hype)
			return

func _process(delta):
	if FallingNotes.is_empty(): return
	for N in FallingNotes.keys():
		if N.time_window <= -0.5 and !FreedNotes.has(N):
			FreedNotes.append(N)
			PlayerData.update_hype(-10)
			if !TurnManager.turn:
				PlayerData.deal_damage(10)
			continue
		N.time_window -= delta/3
		var node = FallingNotes.get(N)
		node.position.y = lerpf(notecatcher.position.y, note_startY, N.time_window)

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

func _on_timer_timeout():
	note_cleanup()

func hit_audio(type: StringName) -> void:
	match type:
		&"left":
			notehit_left.play()
			left.restart()
		&"up":
			notehit_up.play()
			up.restart()
		&"right":
			notehit_right.play()
			right.restart()
		&"down":
			notehit_down.play()
			down.restart()

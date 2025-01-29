extends Node

@onready var left = $left
@onready var up = $up
@onready var right = $right
@onready var down = $down

func _process(delta):
	if TurnManager.active_notes.is_empty(): return
	for N in TurnManager.active_notes:
		match N.assigned_input:
			

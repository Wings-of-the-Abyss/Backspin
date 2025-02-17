extends Node

var turn: bool = false
var active_notes: Array[Note] = []
var queue: Array[Move] = []

var enemymove_index = 0
var enemy_move: Move

const actionpoint_refresh: Array[StringName] = [
	&"left",
	&"right",
	&"up",
	&"down"
]

signal execute_moves
signal execution_complete

signal enemy_execution_complete

signal player_turn_started
signal enemy_turn_started

var note_handler
var enemy_note

signal boss_down
var BossIndex = 0

var dead = false

var break_loop: bool = false

var ActiveBoss:
	set(boss):
		while !enemy_note:
			enemy_note = get_tree().get_first_node_in_group("enemy-note")
			await get_tree().create_timer(0.01).timeout
		enemy_note.move.connect(boss.EnemyNote)
		boss.downed.connect(switch_boss)
		ActiveBoss = boss

func reset() -> void:
	dead = false
	turn = false
	break_loop = false
	active_notes.clear()
	queue.clear()
	enemymove_index = 0
	BossIndex = 0
	while !note_handler or !enemy_note:
		note_handler = get_tree().get_first_node_in_group("note-handler")
		enemy_note = get_tree().get_first_node_in_group("enemy-note")
		await get_tree().create_timer(0.01).timeout
	turn_switch()

##Sequence of events for the Player's turn
func player_turn() -> void:
	turn = true
	PlayerData.ActionPoints.append_array(actionpoint_refresh)
	player_turn_started.emit()
	await execute_moves
	execute_queue()
	await execution_complete
	turn_switch()

##Sequence of events for the enemy's turn
func enemy_turn() -> void:
	turn = false
	enemy_turn_started.emit()
	await enemy_pick_move()
	enemy_execute_move()
	await enemy_execution_complete
	turn_switch()

func reset_turns() -> void:
	break_loop = true
	active_notes.clear()
	queue.clear()
	note_handler.clear_notes()
	enemy_note.clear_notes()
	player_turn()

##Turn switcher
func turn_switch() -> void:
	if dead: return
	if break_loop:
		break_loop = false
		return
	while !active_notes.is_empty() or !queue.is_empty(): await get_tree().create_timer(0.01).timeout
	await get_tree().create_timer(1.0).timeout
	if turn:
		enemy_turn()
	else:
		player_turn()

func on_death() -> void:
	if dead: return
	dead = true
	get_tree().get_first_node_in_group("player").die()
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://scenes/menu/main menu.tscn")

func switch_boss() -> void:
	boss_down.emit()
	BossIndex += 1
	reset_turns()

#region Player Move Stuff
func selection_complete() -> void:
	execute_moves.emit()

##Use this to add a move from the available bunch to the queue, use their index in the deck (card number 0, 1, etc)
func add_move_to_queue(move: Move) -> bool:
	var has_points = true
	for N in move.Cost:
		if N == &"": continue
		if !PlayerData.ActionPoints.has(N):
			has_points = false
			break
	if has_points:
		for n in move.Cost:
			PlayerData.ActionPoints.erase(n)
		queue.append(move)
		return true
	return false

##Executes the queue
func execute_queue() -> void:
	for M in queue:
		await play_move(M)
	queue.clear()
	execution_complete.emit()
	

##Executes the sequence of notes
func play_move(move: Move) -> void:
	if turn:
		get_tree().get_first_node_in_group("player").MoveHit(move.AnimName)
	for i in range(move.Notes.size()):
		var note_type = move.Notes[i]
		var note = Note.new()
		note.assigned_input = note_type
		note.hype_mult = move.Multiplier
		active_notes.push_front(note)
		get_tree().get_first_node_in_group("note-handler").add_note(note_type, note)
		await get_tree().create_timer(move.Timings[i]).timeout

#endregion

#region Enemy Move stuff

func enemy_pick_move():
	var enemy = ActiveBoss
	enemy_move = enemy.EnemyMoves.pick_random()

func enemy_execute_move() -> void:
	if turn: return
	play_move(enemy_move)
	for i in range(enemy_move.Notes.size()):
		var newnote = Note.new()
		newnote.assigned_input = enemy_move.Notes[i]
		active_notes.push_front(newnote)
		get_tree().get_first_node_in_group("enemy-note").add_note_inverse(enemy_move.Notes[i], newnote)
		await get_tree().create_timer(enemy_move.Timings[i]).timeout
	enemy_execution_complete.emit()
#endregion

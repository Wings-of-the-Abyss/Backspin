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

var ActiveBoss:
	set(boss):
		while !enemy_note:
			enemy_note = get_tree().get_first_node_in_group("enemy-note")
			await get_tree().create_timer(0.01).timeout
		enemy_note.move.connect(boss.EnemyNote)
		boss.downed.connect(switch_boss)
		ActiveBoss = boss
		

func _ready():
	note_handler = get_tree().get_first_node_in_group("note-handler")
	enemy_note = get_tree().get_first_node_in_group("enemy-note")
	turn_switch()

##Sequence of events for the Player's turn
func player_turn() -> void:
	PlayerData.ActionPoints.append_array(actionpoint_refresh)
	player_turn_started.emit()
	await execute_moves
	await get_tree().create_timer(1.0).timeout
	execute_queue()
	await execution_complete
	turn_switch()

##Sequence of events for the enemy's turn
func enemy_turn() -> void:
	enemy_turn_started.emit()
	await enemy_pick_move()
	enemy_execute_move()
	await enemy_execution_complete
	turn_switch()

##Turn switcher
func turn_switch() -> void:
	while !active_notes.is_empty():
		await get_tree().create_timer(0.01).timeout
	await get_tree().create_timer(1.0).timeout
	if turn:
		enemy_turn()
	else:
		player_turn()
	turn = !turn

func on_death() -> void:
	if dead: return
	dead = true
	get_tree().get_first_node_in_group("player").die()
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://scenes/menu/main menu.tscn")

func switch_boss() -> void:
	BossIndex += 1
	boss_down.emit()
	

#region Player Move Stuff
func selection_complete() -> void:
	execute_moves.emit()

##Use this to add a move from the available bunch to the queue, use their index in the deck (card number 0, 1, etc)
func add_move_to_queue(move: Move) -> bool:
	var has_points = true
	for N in move.Notes:
		if N == &"": continue
		if !PlayerData.ActionPoints.has(N):
			has_points = false
			break
	if has_points:
		for n in move.Notes:
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
	var enemy = get_tree().get_first_node_in_group("enemy")
	if enemymove_index >= enemy.EnemyMoves.size(): enemymove_index = 0
	enemy_move = enemy.EnemyMoves[enemymove_index]
	enemymove_index += 1

func enemy_execute_move() -> void:
	play_move(enemy_move)
	for i in range(enemy_move.Notes.size()):
		var newnote = Note.new()
		newnote.assigned_input = enemy_move.Notes[i]
		active_notes.push_front(newnote)
		get_tree().get_first_node_in_group("enemy-note").add_note_inverse(enemy_move.Notes[i], newnote)
		await get_tree().create_timer(enemy_move.Timings[i]).timeout
	enemy_execution_complete.emit()
#endregion

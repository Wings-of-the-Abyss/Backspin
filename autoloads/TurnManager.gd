extends Node

var turn: bool = true
var active_notes: Array[Note] = []
var queue: Array[Move] = []

var actionpoint_refresh: Array[StringName] = [
	&"left",
	&"right",
	&"up",
	&"down"
]

signal execute_moves
signal execution_complete

signal player_turn_started
signal enemy_turn_started

##Sequence of events for the Player's turn
func player_turn() -> void:
	player_turn_started.emit()
	PlayerData.ActionPoints.append_array(actionpoint_refresh)
	await execute_moves
	execute_queue()
	await execution_complete
	turn_switch()

##Sequence of events for the enemy's turn
func enemy_turn() -> void:
	print("Enemy Turn")

##Turn switcher
func turn_switch() -> void:
	if turn:
		enemy_turn()
	else:
		player_turn()
	turn = !turn

#region Player Move Stuff
func selection_complete() -> void:
	execute_moves.emit()

##Use this to add a move from the available bunch to the queue, use their index in the deck (card number 0, 1, etc)
func add_move_to_queue(move: Move) -> void:
	for N in move.Notes:
		if !PlayerData.ActionPoints.has(N):
			print("not enough action points")
			return
		PlayerData.ActionPoints.erase(N)
	queue.append(move)

##Executes the queue
func execute_queue() -> void:
	for M in queue:
		await play_move(M)

##Executes the sequence of notes
func play_move(move: Move) -> void:
	for i in range(move.Notes.size()-1):
		var note_type = move.Notes[i]
		var note = Note.new()
		note.assigned_input = note_type
		active_notes.append(note)
		await get_tree().create_timer(move.Timings[i]).timeout
	return

#endregion

#region Enemy Move stuff

#endregion

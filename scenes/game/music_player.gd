extends AudioStreamPlayer

const Battle1 = preload("res://assets/musics/minions/1st Battle - C_mon.mp3")
const Battle2 = preload("res://assets/musics/minions/2nd Battle - Centered.mp3")
const Battle3 = preload("res://assets/musics/minions/3rd Battle - Keep it Up.mp3")
const Battle4 = preload("res://assets/musics/minions/4th Battle - Swap.mp3")
const Battle5 = preload("res://assets/musics/minions/5th Battle - Screamin_.mp3")
const Battle6 = preload("res://assets/musics/minions/6th Battle - Get Away.mp3")

const afroguy = preload("res://assets/musics/bosses/Afro Theme - Blue in Fear.mp3")

const SongList: Dictionary = {
	0 : Battle1,
	1 : Battle2,
	2 : Battle3,
	3 : Battle4,
	4: afroguy
}

func _ready():
	stream = Battle1
	TurnManager.boss_down.connect(next_song)
	next_song()

func next_song() -> void:
	if TurnManager.BossIndex >= SongList.size(): return
	stream = SongList.get(TurnManager.BossIndex)
	playing = true

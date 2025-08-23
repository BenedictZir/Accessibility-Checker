extends Node2D

func _ready() -> void:
	$malam.show()
	SoundManager.play_kos_music()
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("kos_dialog")
	
func _on_dialogic_signal(arg):
	match arg:
		"mulai_tidur":
			SoundManager.kos_music.stream_paused = true
			SceneTransition.transition()
			await SceneTransition.animation_player.animation_finished
			SoundManager.kos_music.stream_paused = false
			$malam.hide()
			Dialogic.start("kos_dialog", "selesai_tidur")
		"end":
			GlobalVar.next_day()
			_save()
			SceneTransition.change_scene("res://scene/map.tscn")
			
	
func _save():
	var player_data = PlayerData.new()
	player_data.player_name = Dialogic.VAR.player_name
	player_data.date = GlobalVar.date
	player_data.day = GlobalVar.day
	player_data.musim_idx = GlobalVar.musim_idx
	player_data.idx_title = GlobalVar.idx_title
	player_data.poin_inklusif = Dialogic.VAR.poin_inklusif
	player_data.taman_first_time = GlobalVar.taman_first_time
	player_data.alt_text_on = GlobalAltText.alt_text_on
	ResourceSaver.save(player_data, "user://player_data.res")

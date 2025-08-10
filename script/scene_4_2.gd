extends Node2D
func _ready() -> void:
	SoundManager.play_kantor_music()
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("scene_4_2")

func _on_dialogic_signal(arg):  
	if arg == "end_day":
		SceneTransition.change_scene("res://scene/map.tscn")
	if arg == "jawaban_benar":
		ParticleManager.emit_50()
		Dialogic.VAR.poin_inklusif += 50

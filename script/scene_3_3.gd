extends Node2D

func _ready() -> void:
	SoundManager.play_kantor_music()

	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("scene_3_3")

func _on_dialogic_signal(arg):  
	if arg == "end":
		SceneTransition.change_scene("res://scene/map.tscn")

extends Node2D

# 205, 445
func _ready() -> void:
	SoundManager.play_kantor_music()

	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("scene_3_1")

func _on_dialogic_signal(arg):  
	if arg == "end":
		SceneTransition.change_scene("res://story_scene/scene_3_2.tscn")

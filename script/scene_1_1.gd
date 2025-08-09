extends Node2D
func _ready() -> void:
	SoundManager.play_kantor_music()
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("scene_1_1")

func _on_dialogic_signal(arg):  
	if arg == "change_background":

		$backgrounds/backrgound_1.hide()
		$backgrounds/background_2.show()

	if arg == "end":
		SceneTransition.change_scene("res://story_scene/scene_1_2.tscn")

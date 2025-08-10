extends Node2D
func _ready() -> void:
	SoundManager.play_kantor_music()
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("scene_1_1")

func _on_dialogic_signal(arg):  
	if arg == "change_background":
		$Camera2D.position = Vector2(960, 540)
		$backgrounds/backrgound_1.hide()
		$backgrounds/background_2.show()
	if arg == "move_camera":
		var tween = create_tween()
		tween.tween_property($Camera2D, "position:y", -1307, 1)
	if arg == "end":
		SceneTransition.change_scene("res://story_scene/scene_1_2.tscn")
	if arg == "jawaban_benar":
		ParticleManager.emit_50()
		Dialogic.VAR.poin_inklusif += 50

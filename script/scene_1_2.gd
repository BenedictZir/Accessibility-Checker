extends Node2D
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("scene_1_2")

func _on_dialogic_signal(arg):
	if arg == "":
		pass

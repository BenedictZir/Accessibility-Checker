extends Node2D

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("kos_dialog")
	
func _on_dialogic_signal(arg):
	match arg:
		"mulai_tidur":
			SceneTransition.transition()
			await SceneTransition.animation_player.animation_finished
			Dialogic.start("kos_dialog", "selesai_tidur")
		"end":
			GlobalVar.next_day()
			SceneTransition.change_scene("res://scene/map.tscn")
		
	

extends Node2D

# 205, 445
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("scene_1_1")

func _on_dialogic_signal(arg):  
	if arg == "change_background":
		print("bg changed")
		$backgrounds/backrgound_1.hide()
		$backgrounds/background_2.show()
	if arg == "pak_anton_join":
		$AnimationPlayer.play("pak_anton_join")
	if arg == "pak_anton_talk":
		$pak_anton.play("talk")

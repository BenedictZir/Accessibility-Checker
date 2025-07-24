extends Node2D

func play(arg: String):
	var audio = find_child(arg)
	if audio:
		audio.play()

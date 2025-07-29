extends Area2D

var occupied_by : Area2D = null
var alt_text = ""

func get_text():
	return alt_text
func set_text(text):
	alt_text = text

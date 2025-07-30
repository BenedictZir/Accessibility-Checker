extends Area2D

var occupied_by : Area2D = null
var alt_text = ""

func get_text():
	return alt_text
func set_text():
	if (occupied_by):
		alt_text = occupied_by.label.text

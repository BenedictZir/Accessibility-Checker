extends TextureRect
@onready var label: Label = $Label
@onready var line_2d: Line2D = $Line2D
var connected_to = null
const GREEN = preload("res://gradient/green.tres")
const RED = preload("res://gradient/red.tres")

func _process(delta: float) -> void:
	if connected_to:
		line_2d.gradient = GREEN
	else:
		line_2d.gradient = RED
func connect_to(doc_text):
	if connected_to:
		connected_to.disconnect_to()
	connected_to = doc_text
	find_parent("structure_minigame").emit_signal("connecting", doc_text.label.text, self.label.text)
func disconnect_to():
	if connected_to:
		connected_to.disconnect_to() 
		connected_to = null

extends TextureRect
@onready var label: Label = $Label
@onready var line_2d: Line2D = $Line2D
var connected_to = null



func connect_to(doc_text):
	if connected_to:
		connected_to.disconnect_to()
	connected_to = doc_text
func disconnect_to():
	if connected_to:
		connected_to.disconnect_to() 
		connected_to = null

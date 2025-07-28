extends TextureRect
signal selected
signal deselect
@onready var highlight: Line2D = $highlight
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@export var correct_alt_text: String
@export var mid_alt_text: String
@export var wrong_alt_text: String


func _ready() -> void:
	collision_shape_2d.shape.size = size
	collision_shape_2d.position = size/2
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		var parent = find_parent("level_template")
		parent.select(self)
		print("image clicked")


func _on_selected() -> void:
	highlight.clear_points()
	
	var w = size.x
	var h = size.y
	
	highlight.add_point(Vector2(0, 0))
	highlight.add_point(Vector2(w, 0))
	highlight.add_point(Vector2(w, h))
	highlight.add_point(Vector2(0, h))





func _on_deselect() -> void:
	highlight.clear_points()
	
func return_alt_texts():
	var alt_texts = [correct_alt_text, mid_alt_text, wrong_alt_text]
	return alt_texts

extends Label
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var highlight: Line2D = $highlight

@export_enum("heading", "subheading", "text") var intended_struct
var is_contrast := false
signal selected
signal deselect

func _ready():
	update_size()

func _process(delta):
	pass
func update_size():	
	var line_height = get_line_height()
	var line_count = get_line_count()
	var total_height = line_height * line_count
	var total_width = size.x  # atau batas wrapping kamu
	var new_size = Vector2(total_width, total_height)
	size = new_size
	collision_shape_2d.position = new_size / 2
	collision_shape_2d.shape.size = size
	

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		var parent = find_parent("level_template")
		parent.select(self)


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
func check_contrast(self_color, bg_color):
	pass

func examine_text(background_color, text_color):
	if name.contains("heading"):
		if intended_struct == 0:
			return 1
		else:
			return 0
	if name.contains("subheading"):
		if intended_struct == 1:
			return 1
		else:
			return 0
	if name.contains("text"):
		if intended_struct == 2:
			return 1
		else:
			return 0

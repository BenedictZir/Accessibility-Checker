extends Label
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var highlight: Line2D = $highlight

@export_enum("heading", "subheading", "text") var intended_structure
var structure := "text"
var is_contrast := false
const text_size = 22
const subheading_size = 50
const headidng_size = 80
var display_name = ""
@export var part := 1
signal selected
signal deselect

func _ready():
	update_size()

func _process(delta):
	if structure == "text":
		add_theme_font_size_override("font_size", text_size)
	elif structure == "subheading":
		add_theme_font_size_override("font_size", subheading_size)
	else:
		add_theme_font_size_override("font_size", headidng_size)
	update_size()
func update_size():	
	collision_shape_2d.position = size / 2
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

func examine(background_color):
	if structure.contains("subheading"):
		if intended_structure == 1:
			print("subheading sesuai")
			return 2
		else:
			print("subheading tidak sesuai")
			return 0
	elif structure.contains("heading"):
		if intended_structure == 0:
			print("heading sesuai")
			return 2
		else:
			print("heading tdk sesuai")
			return 0
	elif structure.contains("text"):
		if intended_structure == 2:
			print("text sesuai")
			return 2
		else:
			print("trxt tidak sesuai")
			return 0

func get_part():
	return part

func set_display_name(display):
	display_name = display

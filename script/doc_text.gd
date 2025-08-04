extends Label
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var highlight: Line2D = $highlight

@export_enum("judul", "subjudul", "teks") var intended_structure
var structure := "teks"
var is_contrast := false
const text_size = 22
const subheading_size = 50
const headidng_size = 80
var display_name = ""
var is_selected := false
@export var part := 1
signal selected
signal deselect

func _ready():
	update_size()

func _process(delta):
	if structure == "teks":
		add_theme_font_size_override("font_size", text_size)
	elif structure == "subjudul":
		add_theme_font_size_override("font_size", subheading_size)
	else:
		add_theme_font_size_override("font_size", headidng_size)
	update_size()
	if is_selected:
		update_highlight()
func update_size():	
	collision_shape_2d.position = size / 2
	collision_shape_2d.shape.size = size
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		var parent = find_parent("level_template")
		parent.select(self)


func _on_selected() -> void:
	is_selected = true
	update_highlight()




func update_highlight():
	highlight.clear_points()
	
	var w = size.x
	var h = size.y
	
	highlight.add_point(Vector2(0, 0))
	highlight.add_point(Vector2(w, 0))
	highlight.add_point(Vector2(w, h))
	highlight.add_point(Vector2(0, h))
func _on_deselect() -> void:
	is_selected = false
	highlight.clear_points()
func examine_color(background_color):
	pass

func examine_structure():
	if structure.contains("subjudul"):
		if intended_structure == 1:
			return 2
		else:
			return 0
	elif structure.contains("judul"):
		if intended_structure == 0:
			return 2
		else:
			return 0
	elif structure.contains("teks"):
		if intended_structure == 2:
			return 2
		else:
			return 0

func get_part():
	return part

func set_display_name(display):
	display_name = display

func _on_mouse_entered():
	GlobalVar.interactable = true


func _on_mouse_exited():
	GlobalVar.interactable = false

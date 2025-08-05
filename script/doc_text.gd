extends Label

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var highlight: Line2D = $highlight

const COLORS = {
	"merah" : Color("#d10f0b"),
	"oranye" : Color("#ff750a"),
	"kuning" : Color("#ffeb3b"),
	"hijau" : Color("#01b046"),
	"biru" : Color("#296cd4"),
	"hitam" : Color("#253238"),
	"ungu" : Color("#5f006f"),
	"putih" : Color("#fbfbfb")
}

@export_enum("judul", "subjudul", "teks") var intended_structure
@export var structure := "teks"
const LATO_LIGHT = preload("res://assets/fonts/Lato-Light.ttf")
const LATO_REGULAR = preload("res://assets/fonts/Lato-Regular.ttf")
const LATO_BOLD = preload("res://assets/fonts/Lato-Bold.ttf")
const LATO_BLACK = preload("res://assets/fonts/Lato-Black.ttf")
var is_contrast := false
const text_size = 26
const subheading_size = 28
const heading_size = 40
var display_name = ""
var is_selected := false
@export var part := 1
signal selected
signal deselect

func _ready():
	update_size()

func _process(delta):
	if structure == "teks":
		add_theme_font_override("font", LATO_LIGHT)
		add_theme_font_size_override("font_size", text_size)
	elif structure == "subjudul":
		add_theme_font_override("font", LATO_REGULAR)
		
		add_theme_font_size_override("font_size", subheading_size)
	else:
		add_theme_font_override("font", LATO_BOLD)
		add_theme_font_size_override("font_size", heading_size)
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

func colors_equal(c1: Color, c2: Color, tolerance := 0.01) -> bool:
	return abs(c1.r - c2.r) < tolerance and abs(c1.g - c2.g) < tolerance and abs(c1.b - c2.b) < tolerance and abs(c1.a - c2.a) < tolerance

func examine_color(background_color):
	var text_color = get_theme_color("font_color")
	var readable_pairs := [
		[COLORS["putih"], COLORS["hitam"]],
		[COLORS["putih"], COLORS["biru"]],
		[COLORS["putih"], COLORS["ungu"]],
		[COLORS["putih"], COLORS["merah"]],
		
		[COLORS["hitam"], COLORS["putih"]],
		[COLORS["hitam"], COLORS["kuning"]],
		[COLORS["hitam"], COLORS["hijau"]],
		[COLORS["hitam"], COLORS["oranye"]],
		
		[COLORS["kuning"], COLORS["hitam"]],
		[COLORS["kuning"], COLORS["ungu"]],
		[COLORS["kuning"], COLORS["merah"]],
		
		[COLORS["hijau"], COLORS["hitam"]],
		
		[COLORS["biru"], COLORS["putih"]],
		
		[COLORS["ungu"], COLORS["putih"]],
		[COLORS["ungu"], COLORS["kuning"]],
		[COLORS["ungu"], COLORS["oranye"]],
		
		[COLORS["merah"], COLORS["putih"]],
		[COLORS["merah"], COLORS["kuning"]],
		
		[COLORS["oranye"], COLORS["hitam"]],
		[COLORS["oranye"], COLORS["ungu"]]
	]

	for pair in readable_pairs:
		if colors_equal(background_color, pair[0]) and colors_equal(text_color, pair[1]):
			return 2
		if colors_equal(background_color, pair[1]) and colors_equal(text_color, pair[0]):
			return 2
	
	return 0

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

func get_structure():
	return structure

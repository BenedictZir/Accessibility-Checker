extends Label
@onready var heading: Sprite2D = $heading
@onready var subheading: Sprite2D = $subheading
@onready var text_bg: Sprite2D = $text
@onready var heading_selected: Sprite2D = $heading_selected
@onready var subheading_selected: Sprite2D = $subheading_selected
@onready var text_bg_selected: Sprite2D = $text_selected
@onready var label: Label = $Label

signal selected
signal deselect
const HEADING_X = 30
const SUBHEADING_X = 70
const TEXT_X = 110
var type
var is_selected := false
var currently_visible
func _ready() -> void:
	currently_visible = heading
	heading.show()
func _process(delta: float) -> void:
	label.text = name
	if name.containsn("subheading"):
		if is_selected:
			update_outline(subheading_selected, SUBHEADING_X)
		else:
			update_outline(subheading, SUBHEADING_X)
	elif name.containsn("heading"):
		if is_selected:
			update_outline(heading_selected, HEADING_X)
		else:
			update_outline(heading, HEADING_X)
	else:
		if is_selected:
			update_outline(text_bg_selected, TEXT_X)
		else:
			update_outline(text_bg, TEXT_X)
			
			


func update_outline(background, pos):
	currently_visible.hide()
	currently_visible = background
	currently_visible.show()
	label.position.x = pos
	


func _on_selected() -> void:
	is_selected = true

func _on_deselect() -> void:
	is_selected = false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		var parent = find_parent("level_template")
		parent.select_outline(self)

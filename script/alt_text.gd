extends Area2D
var selected = false
var answer_box
var original_pos: Vector2
@onready var label: Label = $Label
@export var text: String
func _ready() -> void:
	original_pos = global_position
	label.text = text
	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click") and !GlobalVar.is_dragging: # jika click di text dan tidak sedang drag text lain
		selected = true
		GlobalVar.is_dragging = true

		
func _physics_process(delta: float) -> void:
	if selected: # jika text sedang didrag, ikuti mouse
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	elif answer_box: # jika text dalam answer box 
		if answer_box.occupied_by == self or GlobalVar.is_dragging: # jika dilepas dalam box, masuk ke box
			global_position = lerp(global_position, answer_box.global_position, 10 * delta)
			Dialogic.VAR.ans = text
		else: # jika ada text baru masuk, kembali
			global_position = lerp(global_position, original_pos, 10 * delta)
	else: # jika text dilepas diluar box, kembali
		global_position = lerp(global_position, original_pos, 10 * delta)	
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			selected = false
			GlobalVar.is_dragging = false	
			
			
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("answer_box") and selected:
		area.occupied_by = self
		answer_box  = area
		
func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("answer_box"):
		if area.occupied_by == self:
			area.occupied_by = null
		answer_box = null

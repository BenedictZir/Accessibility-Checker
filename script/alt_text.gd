extends Area2D
var selected = false
var answer_box
var original_pos: Vector2
@onready var label: Label = $Label
@export var height: float = 50
@export var width: float = 120
func _ready() -> void:
	$Label.size = Vector2(width, height)
	$CollisionShape2D.shape.size = Vector2(width, height)
	original_pos = global_position
	
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
			answer_box.set_text(label.text)
		else: # jika ada text baru masuk, kembali
			global_position = lerp(global_position, original_pos, 10 * delta)
			
	else: # jika text dilepas diluar box, kembali
		global_position = lerp(global_position, original_pos, 10 * delta)	
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and selected:
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


func _on_mouse_entered() -> void:
	if !GlobalVar.is_dragging:
		expand()


func _on_mouse_exited() -> void:
	if !selected:
		if (answer_box != null):
			if (answer_box.occupied_by != self):
				shrink()
			else:
				return
		shrink()

func shrink():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_SINE)
func expand():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 1.2, 0.25).set_trans(Tween.TRANS_SINE)
	
func set_text(text):
	label.text = text 

func set_pos(pos):
	original_pos = pos
	

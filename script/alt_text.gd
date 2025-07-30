extends Area2D

@onready var label: Label = $Label
@export var height: float = 50
@export var width: float = 120

var selected := false
var is_hovered := false
var answer_box = null
var original_pos: Vector2
func _ready() -> void:
	original_pos = global_position
	label.size = Vector2(width, height)
	$CollisionShape2D.shape.size = Vector2(width, height)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and selected:
		selected = false
		GlobalVar.is_dragging = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click") and not GlobalVar.is_dragging:
		selected = true
		GlobalVar.is_dragging = true

func _physics_process(delta: float) -> void:

		
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	elif answer_box:
		if answer_box.occupied_by == self or GlobalVar.is_dragging:
			global_position = lerp(global_position, answer_box.global_position, 10 * delta)
			answer_box.set_text()
		else:
			global_position = lerp(global_position, original_pos, 10 * delta)
	else:
		global_position = lerp(global_position, original_pos, 10 * delta)

	if not selected and not is_hovered and (not answer_box or answer_box.occupied_by != self):
		shrink()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("answer_box") and selected:
		area.occupied_by = self
		answer_box = area

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("answer_box"):
		if area.occupied_by == self:
			area.occupied_by = null
		answer_box = null

func _on_mouse_entered() -> void:
	is_hovered = true
	if not GlobalVar.is_dragging:
		expand()

func _on_mouse_exited() -> void:
	is_hovered = false

func shrink():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE)

func expand():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 1.2, 0.1).set_trans(Tween.TRANS_SINE)

func set_text(text: String) -> void:
	label.text = text

func set_pos(pos: Vector2) -> void:
	original_pos = pos

func get_text():
	return label.text
	
func reset():
	selected = false
	GlobalVar.is_dragging = false
	scale = Vector2.ONE
	if answer_box:
		if answer_box.occupied_by == self:
			answer_box.occupied_by = null
	answer_box = null
	global_position = original_pos
func enter_box(ans_box):
	answer_box = ans_box
	answer_box.occupied_by = self
	global_position = answer_box.global_position
	expand()
	
func enable_collision():
	$CollisionShape2D.disabled = false

func disable_collision():
	$CollisionShape2D.disabled = true

extends TextureRect

@onready var line_2d: Line2D = $Line2D
@onready var area_2d: Area2D = $Line2D/Area2D
@onready var label: Label = $Label
@onready var collision_shape_2d: CollisionShape2D = $Line2D/Area2D/CollisionShape2D

var animating_back = false
var selected = false
var original_point_pos: Vector2
var connected_to = null

func _ready() -> void:
	original_point_pos = line_2d.points[2]

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	if Input.is_action_just_pressed("click") and not GlobalVar.is_dragging:
		selected = true
		if connected_to:
			connected_to.disconnect_to()
		GlobalVar.is_dragging = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and selected:
		selected = false
		GlobalVar.is_dragging = false
		if not connected_to:
			back_ori_pos()

func _process(delta: float) -> void:
	if selected and GlobalVar.is_dragging:
		var mouse_pos = line_2d.to_local(get_global_mouse_position())
		_set_line_point(mouse_pos)

func _set_line_point(pos: Vector2):
	line_2d.points[2] = pos
	area_2d.position = pos

func back_ori_pos():
	collision_shape_2d.call_deferred("set_disabled", true)
	animating_back = true
	var current_pos = line_2d.points[2]
	var tween = create_tween()
	tween.tween_method(_set_line_point, current_pos, original_point_pos, 0.3) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.connect("finished", _on_tween_finished)

func _on_tween_finished():
	collision_shape_2d.call_deferred("set_disabled", false)
	collision_shape_2d.disabled = false
	_set_line_point(original_point_pos)

func disconnect_to():
	connected_to = null
	if (not selected):
		back_ori_pos()

func _on_area_2d_area_entered(area: Area2D) -> void:
	var answer = area.get_parent().get_parent()
	if not answer.has_method("connect_to"):
		return
	
	if answer.connected_to:
		answer.disconnect_to()
	connected_to = answer
	answer.connect_to(self)
	
	selected = false
	GlobalVar.is_dragging = false
	_set_line_point(line_2d.to_local(answer.line_2d.global_position))

func _on_mouse_entered():
	GlobalVar.interactable.append(self)


func _on_mouse_exited():
	GlobalVar.interactable.erase(self)

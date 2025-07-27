extends Node2D
var original_y
@export var scroll_speed := 10.0
signal selected
signal deselect
func _ready() -> void:
	original_y = position.y



func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			position.y += scroll_speed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			position.y -= scroll_speed
		position.y = clamp(position.y, original_y - ( $Area2D/CollisionShape2D.shape.size.y - 864), original_y)

	if Input.is_action_just_pressed("click"):
		var parameters = PhysicsPointQueryParameters2D.new()
		parameters.position = event.position
		parameters.collide_with_areas = true
		var obj_clicked = get_world_2d().direct_space_state.intersect_point(parameters)
		if obj_clicked.size() <= 1:
			var parent = find_parent("level_template")
			parent.select(self)
			print("docs clicked")


func _on_selected() -> void:
	pass # Replace with function body.

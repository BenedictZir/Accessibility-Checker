extends Node2D
var original_y
@export var scroll_speed := 40.0
@onready var paper_area: Area2D = $paper_area
@export var paper_color = ""
signal selected
signal deselect
var ori_area_pos
@export var judul := ""
func _ready() -> void:
	original_y = position.y
	ori_area_pos = paper_area.global_position

func _process(delta: float) -> void:
	paper_area.global_position = ori_area_pos

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			position.y += scroll_speed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			position.y -= scroll_speed
		position.y = clamp(position.y, original_y - ( $paper_area/CollisionShape2D.shape.size.y - 864), original_y)

	if Input.is_action_just_pressed("click"):
		var parameters = PhysicsPointQueryParameters2D.new()
		parameters.position = event.position
		parameters.collide_with_areas = true
		var obj_clicked = get_world_2d().direct_space_state.intersect_point(parameters)
		if obj_clicked.size() <= 1:
			var parent = find_parent("level_template")
			parent.select(self)

func get_images():
	var containers = $DocumentObjects.get_children()
	var images = []
	for container in containers:
		for obj in container.get_children():
			if obj.is_in_group("images"):
				images.append(obj)
	return images

func get_texts():
	var containers = $DocumentObjects.get_children()
	var texts = []
	for container in containers:
		for obj in container.get_children():
			if obj.is_in_group("texts"):
				texts.append(obj)
	return texts
	
func _on_selected() -> void:
	pass # Replace with function body.

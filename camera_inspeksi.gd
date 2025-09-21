extends Camera2D
var part_size = Vector2(640, 360)
var mouse_pos_addition = Vector2.ZERO
func _ready() -> void:
	var mouse_pos = get_global_mouse_position()
	set_screen_position(mouse_pos)
	await get_tree().process_frame
	position_smoothing_enabled = true
	position_smoothing_speed = 7.0
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	set_screen_position(mouse_pos + mouse_pos_addition)
	print(global_position)

func set_screen_position(mouse_pos):
	var grid_x = floor(mouse_pos.x / part_size.x)
	var grid_y = floor(mouse_pos.y / part_size.y) 
	if zoom != 3 * Vector2.ONE:
		return
	if grid_x < 0 or grid_x > 2:
		return
	if grid_y < 0 or grid_y > 2:
		return
	var x = grid_x * part_size.x + part_size.x / 2
	var y = grid_y * part_size.y + part_size.y / 2
	
	global_position = Vector2(x,y)
	#mouse_pos_addition = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if zoom != 3 * Vector2.ONE:
					zoom = 3 * Vector2.ONE
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if zoom != Vector2.ONE:
					zoom = Vector2.ONE


func _on_right_area_mouse_entered() -> void:
	mouse_pos_addition = Vector2(40, 0)


func _on_left_area_mouse_entered() -> void:
	mouse_pos_addition = Vector2(-40, 0)

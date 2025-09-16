extends Area2D
@export_enum("horizontal", "vertical") var hammer_type = 0
var dragging := false
var returning := false
var start_position: Vector2
var return_speed := 8.0 
var target_cell = null
func _ready() -> void:
	input_pickable = true
	start_position = global_position 

func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			returning = false
		else:
			if target_cell != null:
				if hammer_type == 0:
					target_cell.break_horizontal()
				else:
					target_cell.break_vertical()
			dragging = false
			returning = true   #
		

func _process(delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position()
	elif returning:
		global_position = global_position.lerp(start_position, return_speed * delta)

		if global_position.distance_to(start_position) < 2.0:
			global_position = start_position
			returning = false


func _on_hit_area_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("cells"):
		target_cell = area.get_parent()
	

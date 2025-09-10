extends Node

var default_cursor = load("res://assets/cursors/cursor_default.png")
var grab_cursor = load("res://assets/cursors/cursor_grab.png")
var interactable_cursor = load("res://assets/cursors/cursor_point.png")

func _process(delta: float) -> void:
	if GlobalVar.is_dragging:
		Input.set_custom_mouse_cursor(grab_cursor, Input.CURSOR_ARROW, Vector2(50, 50))
	elif is_mouse_over_button() or GlobalVar.interactable.size() > 0:
		Input.set_custom_mouse_cursor(interactable_cursor, Input.CURSOR_ARROW, Vector2(10, 0))
	else:
		Input.set_custom_mouse_cursor(default_cursor)
		
func is_mouse_over_button() -> bool:
	var hovered = get_viewport().gui_get_hovered_control()
	if hovered != null and hovered is Button:
		if not hovered.is_disabled() and hovered.visible:
			return true
		
	return false

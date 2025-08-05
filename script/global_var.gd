extends Node2D
var is_clicking := false
var is_dragging := false
var can_click := true
var can_drag := false
var player_name = ""
var date := 1
var day_list = ["SENIN", "SELASA", "RABU", "KAMIS", "JUMAT", "SABTU", "MINGGU"]
var title_list = ["STAFF MAGANG"]

var day := "SENIN"
var inclusive_point := 0
var done_working_today := false
var default_cursor = load("res://assets/cursors/cursor_default.png")
var grab_cursor = load("res://assets/cursors/cursor_grab.png")
var interactable_cursor = load("res://assets/cursors/cursor_point.png")
var interactable := []
func next_day():
	done_working_today = false
	date += 1
	day = day_list[((date - 1) % 7)]
	
func _process(delta: float) -> void:
	player_name = Dialogic.VAR.player_name
	if is_dragging:
		Input.set_custom_mouse_cursor(grab_cursor, Input.CURSOR_ARROW, Vector2(50, 50))
	elif is_mouse_over_button() or interactable.size() > 0:
		Input.set_custom_mouse_cursor(interactable_cursor, Input.CURSOR_ARROW, Vector2(10, 0))
	else:
		Input.set_custom_mouse_cursor(default_cursor)
		
func is_mouse_over_button() -> bool:
	var hovered = get_viewport().gui_get_hovered_control()
	if hovered != null and hovered is Button:
		if not hovered.is_disabled():
			return true
	return false

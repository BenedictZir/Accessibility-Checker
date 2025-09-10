extends Node2D

@onready var label: Label = $ColorRect/Label
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $ColorRect/VisibleOnScreenNotifier2D
@onready var color_rect: ColorRect = $ColorRect
var alt_text_on = true
func _process(delta: float) -> void:
	if alt_text_on:
		is_mouse_over_button()
		
func is_mouse_over_button() -> void:
	var button
	var hovered = get_viewport().gui_get_hovered_control()
	if hovered != null and hovered is Button and hovered.process_mode != PROCESS_MODE_DISABLED:
		if not hovered.is_disabled() and hovered.visible:
			button = hovered
	if button != null:
		if button.has_method("get_alt_text"):
			label.text = button.get_alt_text()
			
			var mouse_pos = get_global_mouse_position()
			color_rect.global_position = mouse_pos + Vector2(-140,  -150)
			
			color_rect.rotation = 0
			label.rotation = 0
			
			if color_rect.get_global_position().y - color_rect.size.y < 0:
				color_rect.rotation = PI
				color_rect.global_position = (mouse_pos + Vector2(160,  80)) + Vector2(0, 100)
				label.rotation = -color_rect.rotation
			color_rect.show()
		else:
			color_rect.hide()
	else:
		color_rect.hide()

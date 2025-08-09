extends Node2D
const HOVER_SCALE := 1.2
const NORMAL_SCALE := 1.0
const LERP_SPEED := 25.0
var buttons

func _ready() -> void:
	buttons = [$play_button, $credit_button, $exit_button]

func _process(delta: float) -> void:
	for button in buttons:
		var target_scale = HOVER_SCALE if button.is_hovered() and not button.disabled and button.visible else NORMAL_SCALE
		button.z_index = 1 if button.is_hovered() else 0
		var current_scale = button.scale.x
		var new_scale = lerp(current_scale, target_scale, delta * LERP_SPEED)
		button.scale = Vector2(new_scale, new_scale)


func _on_exit_button_pressed() -> void:
	get_tree().quit()

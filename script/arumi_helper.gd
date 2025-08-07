extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
signal aruna_pressed
func _on_mouse_entered() -> void:
	animation_player.play("show_aruni")


func _on_mouse_exited() -> void:

	animation_player.play("show_aruni", -1, -1.0, true)


func _on_button_tugas_pressed() -> void:
	aruna_pressed.emit()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		aruna_pressed.emit()

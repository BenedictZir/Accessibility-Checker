extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_mouse_entered() -> void:
	animation_player.play("show_aruni")


func _on_mouse_exited() -> void:
	print("a")

	animation_player.play("show_aruni", -1, -2.0, true)

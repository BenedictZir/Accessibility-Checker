extends Node2D
@onready var wheel: Sprite2D = $wheel
@onready var arrow: Sprite2D = $arrow
@onready var ray_cast_2d: RayCast2D = $arrow/RayCast2D
var rotating := true
var color := ""
func _process(delta: float) -> void:
	if rotating:
		arrow.rotate(deg_to_rad(200 * delta))
		wheel.rotate(deg_to_rad(-20 * delta))
	if Input.is_action_just_pressed("click") or Input.is_action_just_pressed("ui_accept"):
		color = ray_cast_2d.get_collider().name
		rotating = false

func return_color():
	return color

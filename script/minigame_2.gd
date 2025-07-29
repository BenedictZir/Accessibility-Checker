extends Node2D
@onready var wheel: Sprite2D = $wheel
@onready var arrow: Sprite2D = $arrow
@onready var ray_cast_2d: RayCast2D = $arrow/RayCast2D
@onready var before_label: Label = $before/Label
@onready var after_label: Label = $after/Label
@onready var befpre_polygon: Polygon2D = $before/Polygon2D
@onready var after_polygon: Polygon2D = $after/Polygon2D

signal done
signal canceled

var rotating := true
@export var wheel_speed := 200
@export var arrow_speed := -20
const COLORS = {
	"red" : Color("#d10f0b"),
	"orange" : Color("#d95a00"),
	"yellow" : Color("#faed00"),
	"green" : Color("#388b34"),
	"blue" : Color("#356db4"),
	"black" : Color("#000000"),
	"gray" : Color("#9f9f9f"),
	"purple" : Color("#88207d"),
	"dark_blue" : Color("#2f368b"),
	"white" : Color("#ffffff")
	
}
var color = null
func _process(delta: float) -> void:

	if color != null:
		$retry_button.show()
		$accept.show()
	else:
		$accept.hide()
		$retry_button.hide()
	if rotating:
		arrow.rotate(deg_to_rad(wheel_speed * delta))
		wheel.rotate(deg_to_rad(arrow_speed * delta))
	if Input.is_action_just_pressed("click") or Input.is_action_just_pressed("ui_accept"):
		var color_name = ray_cast_2d.get_collider().name
		if COLORS.has(color_name):
			color = COLORS[color_name]
			after_polygon.self_modulate = color
			after_label.add_theme_color_override("font_color", color)
			stop_rotating()
		else:	
			print("Warna", color_name, "tidak ditemukan di COLORS")
		stop_rotating()
		
func return_color():
	return color
	
func start_rotating():
	rotating = true

func stop_rotating():
	rotating = false
	

func init_wheel(obj):
	color = null
	if obj.is_in_group("texts"):
		befpre_polygon.hide()
		after_polygon.hide()
		
		before_label.text = obj.name
		after_label.text = obj.name
		before_label.add_theme_color_override("font_color", obj.get_theme_color("font_color"))
		after_label.add_theme_color_override("font_color", obj.get_theme_color("font_color"))
		
		before_label.show()
		after_label.show()
	else:
		before_label.hide()
		after_label.hide()
		
		befpre_polygon.self_modulate = obj.self_modulate
		after_polygon.self_modulate = obj.self_modulate
		
		befpre_polygon.show()
		after_polygon.show()
		
func _on_retry_button_pressed() -> void:
	color = null
	start_rotating()


func _on_accept_pressed() -> void:
	emit_signal("done")


func _on_cancel_button_pressed() -> void:
	emit_signal("canceled")

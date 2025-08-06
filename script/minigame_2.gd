extends Node2D
@onready var wheel: Sprite2D = $wheel
@onready var border: Sprite2D = $border

@onready var ray_cast_2d: RayCast2D = $border/arrow/RayCast2D

@onready var before_label: Label = $before/Label
@onready var after_label: Label = $after/Label
@onready var befpre_polygon: Polygon2D = $before/Polygon2D
@onready var after_polygon: Polygon2D = $after/Polygon2D
@onready var stop_button: Button = $stop_button

signal done
signal canceled

var rotating := true
var wheel_speed := 200
const SLOW_SPEED = 200
const MEDIUM_SPEED := 250
const HARD_SPEED := 300
const COLORS = {
	"merah" : Color("#d10f0b"),
	"oranye" : Color("#ff750a"),
	"kuning" : Color("#ffeb3b"),
	"hijau" : Color("#01b046"),
	"biru" : Color("#296cd4"),
	"hitam" : Color("#253238"),
	"ungu" : Color("#5f006f"),
	"putih" : Color("#fbfbfb")
	
}
var color = null
func _process(delta: float) -> void:
	if color != null:
		$retry_button.show()
		$accept.show()
		stop_button.hide()
		
	else:
		stop_button.show()
		$accept.hide()
		$retry_button.hide()
	if rotating:
		wheel.rotate(deg_to_rad(wheel_speed * delta))
	if Input.is_action_just_pressed("ui_accept"):
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
		
		before_label.text = obj.display_name
		after_label.text = obj.display_name
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


func _on_stop_button_pressed() -> void:
	var color_name = ray_cast_2d.get_collider().name
	if COLORS.has(color_name):
		color = COLORS[color_name]
		after_polygon.self_modulate = color
		after_label.add_theme_color_override("font_color", color)
		stop_rotating()
	else:	
		print("Warna", color_name, "tidak ditemukan di COLORS")
	stop_rotating()

func set_speed(diff):
	match diff:
		"easy":
			wheel_speed = SLOW_SPEED
		"medium":
			wheel_speed = MEDIUM_SPEED
		"hard":
			wheel_speed = HARD_SPEED

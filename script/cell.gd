@tool
extends Node2D
@onready var label: Label = $Label
@onready var background: ColorRect = $Background
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@export var text := ""
@export var size := Vector2(80, 60)

const CELL_SCENE: PackedScene = preload("res://scene/cell.tscn")

func _ready() -> void:
	update_size()

func _process(delta: float) -> void:
	update_size()
	
func update_size():
	label.text = text.replace("\\n", "\n")

	label.size = size
	label.position = size / Vector2(-2, -2)

	background.size = size
	background.position = size / Vector2(-2, -2)

	collision_shape_2d.shape.size = size


func break_horizontal():
	if size.x <= 80:
		return

	var text_left: String
	var text_right: String

	# pecah berdasar spasi, skip spasi kosong
	var words: Array = text.split(" ", false, 0)

	if words.size() > 1:
		var mid = words.size() / 2
		text_left = " ".join(words.slice(0, mid))
		text_right = " ".join(words.slice(mid, words.size()))
	else:
		# fallback: pecah berdasarkan panjang string
		var mid = text.length() / 2
		text_left = text.substr(0, mid)
		text_right = text.substr(mid)

	var cell_right = CELL_SCENE.instantiate()
	cell_right.size.x = size.x / 2 - size.x / 10
	cell_right.size.y = size.y
	get_parent().add_child(cell_right)
	cell_right.text = text_right
	cell_right.position = position + Vector2(size.x/4 + size.x/20, 0) 

	var cell_left = CELL_SCENE.instantiate()
	cell_left.size.x = size.x / 2 - size.x / 10
	cell_left.size.y = size.y
	get_parent().add_child(cell_left)
	cell_left.text = text_left
	cell_left.position = position + Vector2(-size.x/4 - size.x/20, 0) 
	
	queue_free()


func break_vertical():
	if size.y <= 60:
		return

	var text_top: String
	var text_bottom: String

	# pecah berdasarkan enter, skip line kosong
	var lines: Array = text.split("\\n", false, 0)
	print(lines)
	if lines.size() > 1:
		var mid = lines.size() / 2
		text_top = "\n".join(lines.slice(0, mid))
		text_bottom = "\n".join(lines.slice(mid, lines.size()))
	else:
		# fallback: pecah berdasarkan panjang string
		var mid = text.length() / 2
		text_top = text.substr(0, mid)
		text_bottom = text.substr(mid)

	# cell atas
	var cell_top = CELL_SCENE.instantiate()
	cell_top.size.x = size.x
	cell_top.size.y = size.y / 2 - size.y / 10
	get_parent().add_child(cell_top)
	cell_top.text = text_top
	cell_top.position = position + Vector2(0, -size.y/4 - size.y/20)

	# cell bawah
	var cell_bottom = CELL_SCENE.instantiate()
	cell_bottom.size.x = size.x
	cell_bottom.size.y = size.y / 2 - size.y / 10
	get_parent().add_child(cell_bottom)	
	cell_bottom.text = text_bottom
	cell_bottom.position = position + Vector2(0, size.y/4 + size.y/20)

	queue_free()

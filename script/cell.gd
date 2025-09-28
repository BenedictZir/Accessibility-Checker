@tool
extends Control


@onready var background_1: ColorRect = $Background1
@onready var background_2: ColorRect = $MarginContainer/Background2
@onready var background_3: ColorRect = $MarginContainer/MarginContainer/Background3
@onready var collision_shape: CollisionShape2D = $InteractionArea/CollisionShape
@onready var label: Label = $MarginContainer/Label

@export var shadow_offset := Vector2(2, 2)
@export var text := "Test"
@export var intended_size := Vector2(160, 60)
@export var intended_grid_pos := Vector2i.ZERO

const MIN_SPLIT_WIDTH := 40.0
const MIN_SPLIT_HEIGHT := 30.0
const CELL_GAP:= 10.0
const CELL_SCENE: PackedScene = preload("res://scene/cell.tscn")

func _ready():
	self.size = self.custom_minimum_size
	label.text = self.text
	pivot_offset = size / 2
	update_visuals()
	

func update_visuals():
	if not is_instance_valid(background_3):
		return
	
	background_3.position = -shadow_offset
	
	update_collision_shape()

func update_collision_shape():
	if not is_instance_valid(collision_shape): 
		return
	if collision_shape.shape:
		collision_shape.position = size / 2.0
		collision_shape.shape.size = size

func break_horizontal():
	
	if size.x < MIN_SPLIT_WIDTH * 2: 
		return false
	
	var text_left: String
	var text_right: String
	var separator = "&"

	var separator_indices = []
	var last_pos = 0
	while true:
		var pos = text.find(separator, last_pos)
		if pos == -1:
			break
		separator_indices.append(pos)
		last_pos = pos + 1

	if not separator_indices.is_empty():
		var mid_separator_index = separator_indices[separator_indices.size() / 2]
		
		text_left = text.substr(0, mid_separator_index).strip_edges()
		text_right = text.substr(mid_separator_index + 1).strip_edges()
	else:
		var mid_index = text.length() / 2
		text_left = text.substr(0, mid_index)
		text_right = text.substr(mid_index)
	
	var new_width = (size.x - CELL_GAP) / 2.0

	var cell_left = CELL_SCENE.instantiate()
	cell_left.text = text_left
	cell_left.custom_minimum_size = Vector2(new_width, size.y)
	cell_left.position = self.position
	cell_left.intended_size = self.intended_size 
	cell_left.intended_grid_pos = self.intended_grid_pos
	get_parent().add_child(cell_left)

	var cell_right = CELL_SCENE.instantiate()
	cell_right.text = text_right
	cell_right.custom_minimum_size = Vector2(new_width, size.y)
	cell_right.position = self.position + Vector2(new_width + CELL_GAP, 0)
	cell_right.intended_size = self.intended_size
	cell_right.intended_grid_pos = self.intended_grid_pos + Vector2i.RIGHT 
	get_parent().add_child(cell_right)
	
	queue_free()
	return true
	
func break_vertical():
	
	if size.y < MIN_SPLIT_HEIGHT * 2:
		return false
	
	var text_top: String
	var text_bottom: String
	var separator = "\n"

	var separator_indices = []
	var last_pos = 0
	while true:
		var pos = text.find(separator, last_pos)
		if pos == -1:
			break
		separator_indices.append(pos)
		last_pos = pos + 1
		
	if not separator_indices.is_empty():
		var mid_separator_index = separator_indices[separator_indices.size() / 2]
		
		text_top = text.substr(0, mid_separator_index).strip_edges()
		text_bottom = text.substr(mid_separator_index + 1).strip_edges()
	else:
		var mid_index = text.length() / 2
		text_top = text.substr(0, mid_index)
		text_bottom = text.substr(mid_index)

	var new_height = (size.y - CELL_GAP) / 2.0

	var cell_top = CELL_SCENE.instantiate()
	cell_top.text = text_top
	cell_top.custom_minimum_size = Vector2(size.x, new_height)
	cell_top.position = self.position
	cell_top.intended_size = self.intended_size
	cell_top.intended_grid_pos = self.intended_grid_pos
	get_parent().add_child(cell_top)

	var cell_bottom = CELL_SCENE.instantiate()
	cell_bottom.text = text_bottom
	cell_bottom.custom_minimum_size = Vector2(size.x, new_height)
	cell_bottom.position = self.position + Vector2(0, new_height + CELL_GAP)
	cell_bottom.intended_size = self.intended_size
	cell_bottom.intended_grid_pos = self.intended_grid_pos + Vector2i.DOWN
	get_parent().add_child(cell_bottom)
	queue_free()
	return true

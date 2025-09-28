extends Control

const CellScene = preload("res://scene/cell.tscn")
@export var table_scale := 1.3
@onready var table_background: ColorRect = $TableBackground

@export var initial_cells: Array[Dictionary] = [
	{
		"text": "No.", "position": Vector2(10, 10), "size": Vector2(80, 50),
		"intended_size": Vector2(80, 50), "grid_pos": Vector2i(0, 0)
	},
	{
		"text": "Nama Item", "position": Vector2(100, 10), "size": Vector2(250, 50),
		"intended_size": Vector2(250, 50), "grid_pos": Vector2i(1, 0)
	},
	{
		"text": "Kuantitas & Harga", "position": Vector2(360, 10), "size": Vector2(290, 50),
		"intended_size": Vector2(140, 50), "grid_pos": Vector2i(2, 0)
	},
	{
		"text": "1.", "position": Vector2(10, 70), "size": Vector2(80, 60),
		"intended_size": Vector2(80, 60), "grid_pos": Vector2i(0, 1)
	},
	{
		"text": "Keyboard Gaming \n Mouse Gaming", "position": Vector2(100, 70), "size": Vector2(250, 130),
		"intended_size": Vector2(250, 60), "grid_pos": Vector2i(1, 1)
	},
	{
		"text": "2", "position": Vector2(360, 70), "size": Vector2(140, 60),
		"intended_size": Vector2(140, 60), "grid_pos": Vector2i(2, 1)
	},
	{
		"text": "Rp 750.000", "position": Vector2(510, 70), "size": Vector2(140, 60),
		"intended_size": Vector2(140, 60), "grid_pos": Vector2i(3, 1)
	},

	{
		"text": "2.", "position": Vector2(10, 140), "size": Vector2(80, 60),
		"intended_size": Vector2(80, 60), "grid_pos": Vector2i(0, 2)
	},
	{
		"text": "1", "position": Vector2(360, 140), "size": Vector2(140, 60),
		"intended_size": Vector2(140, 60), "grid_pos": Vector2i(2, 2)
	},
	{
		"text": "Rp 350.000", "position": Vector2(510, 140), "size": Vector2(140, 60),
		"intended_size": Vector2(140, 60), "grid_pos": Vector2i(3, 2)
	},
	
	{
		"text": "3.", "position": Vector2(10, 210), "size": Vector2(80, 60),
		"intended_size": Vector2(80, 60), "grid_pos": Vector2i(0, 3)
	},
	{
		"text": "Webcam HD", "position": Vector2(100, 210), "size": Vector2(250, 60),
		"intended_size": Vector2(250, 60), "grid_pos": Vector2i(1, 3)
	},
	{
		"text": "1 & Rp 500.000", "position": Vector2(360, 210), "size": Vector2(290, 60),
		"intended_size": Vector2(140, 60), "grid_pos": Vector2i(2, 3)
	}
]

func _ready():
	build_table()

func build_table():
	for child in get_children():
		if child.is_in_group("cells"):
			child.queue_free()
	var count = 0
	for cell_data in initial_cells:
		var new_cell = CellScene.instantiate()
		
		var original_pos = cell_data.get("position", Vector2.ZERO)
		var original_size = cell_data.get("size", Vector2(80, 60))
		var original_intended_size = cell_data.get("intended_size", Vector2(80, 60))
		
		new_cell.position = original_pos * table_scale
		new_cell.custom_minimum_size = original_size * table_scale
		new_cell.intended_size = original_intended_size * table_scale
		
		new_cell.text = cell_data.get("text", "")
		new_cell.intended_grid_pos = cell_data.get("grid_pos", Vector2i.ZERO)
		
		add_child(new_cell)
	resize()
		
func resize():
	var children = get_children()
	if children.is_empty():
		custom_minimum_size = Vector2.ZERO
		return

	var total_rect = children[0].get_rect()
	for i in range(1, children.size()):
		total_rect = total_rect.merge(children[i].get_rect())
	
	custom_minimum_size = total_rect.size 
	size = custom_minimum_size + Vector2(10, 10)
	print(size)

	

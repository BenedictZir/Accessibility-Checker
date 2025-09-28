extends Node2D

@onready var table: Control = $Table
@onready var reset_button: Button = $ResetButton
@onready var horizontal_hammer: Area2D = $HorizontalHammer
@onready var vertical_hammer: Area2D = $VerticalHammer

var active_hammer = null
var switching = false

func _process(delta: float) -> void:
	if is_instance_valid(active_hammer):
		active_hammer.global_position = get_global_mouse_position()
		
func _ready():	
	vertical_hammer.input_event.connect(_on_hammer_selected.bind(vertical_hammer))
	horizontal_hammer.input_event.connect(_on_hammer_selected.bind(horizontal_hammer))

	if is_instance_valid(table):
		table.build_table() 
	center_table()

func _on_reset_button_pressed() -> void:
	if is_instance_valid(table):
		table.build_table() 

func examine() -> float:
	if not is_instance_valid(table):
		return 0.0

	var cells = table.get_children()
	if cells.is_empty():
		return 0.0

	var earned_points: float = 0.0
	var total_possible_points: float = 0.0

	total_possible_points += cells.size()
	for cell in cells:
		if cell.size.is_equal_approx(cell.intended_size):
			earned_points += 1.0
			
	var columns = {} 
	var rows = {}    

	for cell in cells:
		var col_idx = cell.intended_grid_pos.x
		var row_idx = cell.intended_grid_pos.y
		
		if not columns.has(col_idx): 
			columns[col_idx] = []
		columns[col_idx].append(cell)
		
		if not rows.has(row_idx):
			rows[row_idx] = []
		rows[row_idx].append(cell)

	total_possible_points += columns.size()
	for col_idx in columns:
		var cells_in_col = columns[col_idx]
		if cells_in_col.size() > 1:
			var is_aligned = true
			var first_width = cells_in_col[0].size.x
			for i in range(1, cells_in_col.size()):
				if not is_equal_approx(cells_in_col[i].size.x, first_width):
					is_aligned = false
					break
			if is_aligned:
				earned_points += 1.0
		else:

			earned_points += 1.0
			
	total_possible_points += rows.size()
	for row_idx in rows:
		var cells_in_row = rows[row_idx]
		if cells_in_row.size() > 1:
			var is_aligned = true
			var first_height = cells_in_row[0].size.y
			for i in range(1, cells_in_row.size()):
				if not is_equal_approx(cells_in_row[i].size.y, first_height):
					is_aligned = false
					break
			if is_aligned:
				earned_points += 1.0
		else:
			earned_points += 1.0

	if total_possible_points == 0:
		return 0.0
	
	var score = (earned_points / total_possible_points) * 10.0
	return score

func center_table():
	#if not is_instance_valid(table):
		#return
		#
	#var cells = table.get_children()
	#if cells.is_empty():
		#return
#
	#var total_rect = cells[0].get_rect()
	#for i in range(1, cells.size()):
		#total_rect = total_rect.merge(cells[i].get_rect())
#
	#
	#var new_table_pos = $Frame53.global_position - total_rect.get_center()
	#
	#table.position = new_table_pos
	table.position = $Frame53.global_position - table.size / 2

func _on_hammer_selected(viewport, event, shape_idx, hammer_node):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			
		if is_instance_valid(active_hammer):
			if active_hammer != hammer_node:
				deactivate_hammer()
			#deactivate_hammer()
	
		active_hammer = hammer_node
		active_hammer.activate() 
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
func deactivate_hammer():
	if is_instance_valid(active_hammer):
		active_hammer.deactivate() 
		active_hammer = null
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _input(event: InputEvent) -> void:
	if is_instance_valid(active_hammer) and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		active_hammer.play_swing_animation() 
		#if is_instance_valid(active_hammer.target_cell):	

extends Node2D

@onready var cell_container: Node2D = $CellContainer
@onready var reset_button: Button = $ResetButton

var CELL_SCENE: PackedScene = load("res://scene/Cell.tscn")

var initial_cells_data = []

func _ready() -> void:
	save_initial_cells()

func save_initial_cells():
	initial_cells_data.clear()
	for cell in get_tree().get_nodes_in_group("cells"):
		initial_cells_data.append({
			"global_position": cell.global_position,
			"size": cell.size,
			"text": cell.text
		})




func _on_reset_button_pressed() -> void:
	for cell in get_tree().get_nodes_in_group("cells"):
		cell.queue_free()
	
	for data in initial_cells_data:
		var cell = CELL_SCENE.instantiate()
		cell.global_position = data["global_position"]
		cell.size = data["size"]
		cell.text = data["text"]
		cell_container.add_child(cell)

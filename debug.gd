extends Node2D
@onready var level_template: Node2D = $level_template

func _ready() -> void:
	level_template.set_document(load("res://scene/document_template.tscn"))

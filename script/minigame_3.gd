extends Node2D

var doc_texts = []
var structures = []
@export var struct_text_scene : PackedScene
@export var struct_answer_scene : PackedScene
@onready var text_container: VBoxContainer = $text_container
@onready var answer_container: VBoxContainer = $answer_container

func get_texts(texts):
	doc_texts.clear()
	structures.clear()
	for text in texts:
		doc_texts.append(text)
		structures.append(text.intended_structure)

func _ready() -> void:
	# buat ngatur posisi box, nanti ganti  di fungsi lain
	text_container.position.y = -text_container.size.y / 2 
	answer_container.position.y = - answer_container.size.y / 2
	
func check_all_connected():
	pass

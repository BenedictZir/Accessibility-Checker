extends Node2D

var doc_texts = []
var structures = []
var judul_count = 0
var subjudul_count = 0
var teks_count = 0
var text_and_struct : Dictionary = {}
var all_connected := false
@export var struct_text_scene : PackedScene
@export var struct_answer_scene : PackedScene
@onready var text_container: VBoxContainer = $text_container
@onready var answer_container: VBoxContainer = $answer_container
@onready var submit_button: Button = $submit_button

signal done
signal canceled
signal connecting(text, answer)
func init(texts):
	reset()
	for text in texts:
		doc_texts.append(text)
		text_and_struct[text.text] = text.structure
		var structure = convert_int_structure(text.intended_structure)
		structures.append(structure)
	answer_container.size = Vector2(0, 0)
	text_container.size = Vector2(0, 0)
	create_child()
	
func reset():
	text_and_struct = {}
	judul_count = 0
	subjudul_count = 0
	teks_count = 0
	doc_texts.clear()
	structures.clear()
	var texts = text_container.get_children()
	for text in texts:
		text.get_parent().remove_child(text)
		text.queue_free()
		
	var answers = answer_container.get_children()
	for answer in answers:
		answer.get_parent().remove_child(answer)
		answer.queue_free()

	
		
func create_child():
	create_struct_texts()
	create_answers()
	
func create_struct_texts():
	var randomized_texts = doc_texts.duplicate()
	randomized_texts.shuffle()
	for doc in randomized_texts:
		var struct_text = struct_text_scene.instantiate()
		text_container.add_child(struct_text)
		struct_text.label.text = doc.text
	call_deferred("reset_pos")
func create_answers():
	var randomized_structures = structures.duplicate()
	randomized_structures.shuffle() 
	for structure in randomized_structures:
		var struct_answer = struct_answer_scene.instantiate()
		answer_container.add_child(struct_answer)
		struct_answer.label.text = structure
	call_deferred("reset_pos")
func _ready() -> void:
	text_container.position.y = -(text_container.size.y / 2)
	answer_container.position.y = -(answer_container.size.y / 2)
	
func _process(delta: float) -> void:
	check_all_connected()
	if all_connected:
		submit_button.show()
	else:
		submit_button.hide()
func check_all_connected():
	for answer in answer_container.get_children():
		if answer.connected_to == null:
			all_connected = false
			return
	all_connected = true

func reset_pos():
	text_container.position.y = -text_container.size.y / 2 
	answer_container.position.y = -answer_container.size.y / 2
func _on_exit_button_pressed() -> void:
	emit_signal("canceled")

func convert_int_structure(index):
	if index == 0:
		judul_count += 1
		return "judul"
	if index == 1:
		subjudul_count += 1
		return "subjudul"
	if index == 2:
		teks_count += 1
		return "teks"
		 


func _on_connecting(text, answer) -> void:
	text_and_struct[text] = answer
	
func return_result():
	return text_and_struct


func _on_submit_button_pressed() -> void:
	emit_signal("done")
	

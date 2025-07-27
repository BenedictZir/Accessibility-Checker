extends Node2D

@onready var timer: Timer = $"app/Timer"
@onready var timer_label: Label = $"app/Timer/timer_label"
@onready var color_wheel_minigame: Node2D = $color_wheel_minigame
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var document_paper: Sprite2D = $app/document_paper

@export var time := 0
var selected_object = null
var all_object := []
var all_images := []
var all_texts := []

func _ready() -> void:
	get_all_obj()
	timer.wait_time = time
	timer.start()

func _process(delta: float) -> void:
	var minutes = int(timer.time_left) / 60
	var seconds = int(timer.time_left) % 60
	var minutes_str = str(minutes).pad_zeros(2)
	var seconds_str = str(seconds).pad_zeros(2)
	timer_label.text = minutes_str + ":" + seconds_str
	if selected_object:
		if selected_object.is_in_group("images"):
			show_image_features()
		elif selected_object.is_in_group("texts"):
			show_text_features()
		else:
			show_doc_features()
	else:
		show_nothing()
func get_all_images():
	var images = find_child("images").get_children()
	for image in images:
		all_images.append(image)

func get_all_text():
	var texts = find_child("texts").get_children()
	for text in texts:
		all_texts.append(text)
	
func get_all_obj():
	get_all_images()
	get_all_text()
	for text in all_texts:
		all_object.append(text)
	for image in all_images:
		all_object.append(image)
	all_object.sort_custom(sort_by_pos)
	var text_count = 1
	var image_count = 1
	for obj in all_object:
		if obj.is_in_group("texts"):
			obj.name = "text_" + str(text_count)
			text_count += 1
		else:
			obj.name = "image_" + str(image_count)
			image_count += 1
		print(obj.name)
func select(obj):
	if (selected_object):
		selected_object.emit_signal("deselect")
		if (selected_object == obj):
			selected_object = null
			return
		selected_object = null
	selected_object = obj
	obj.emit_signal("selected")

func sort_by_pos(a, b):
	if a.global_position.y < b.global_position.y:
		return true
	return false

func show_image_features():
	pass
	
func show_text_features():
	pass

func show_doc_features():
	pass
func show_nothing():
	pass
	



	


func _on_color_wheel_button_pressed() -> void:
	if (selected_object == null):
		return
	elif (selected_object.is_in_group("texts")):
		color_wheel_minigame.init_wheel(selected_object)
	else:
		color_wheel_minigame.init_wheel(document_paper)
	animation_player.play("show_color_wheel_minigame")
	await animation_player.animation_finished
	color_wheel_minigame.start_rotating()
	


func _on_color_wheel_minigame_done() -> void:
	var color = color_wheel_minigame.return_color()
	if (selected_object.is_in_group("texts")):
		selected_object.add_theme_color_override("font_color", color)
	else:
		document_paper.self_modulate = color
	animation_player.play("show_color_wheel_minigame", -1, -1.0, true)

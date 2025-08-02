extends Node2D

@onready var timer: Timer = $"app/Timer"
@onready var timer_label: Label = $"app/Timer/timer_label"
@onready var color_wheel_minigame: Node2D = $color_wheel_minigame
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var document_paper: Sprite2D = $app/document_paper
@onready var image_features: Node2D = $app/minigame_icons/image_features
@onready var docs_features: Node2D = $app/minigame_icons/docs_features
@onready var text_features: Node2D = $app/minigame_icons/text_features
@onready var alt_text_minigame: Node2D = $alt_text_minigame
@onready var document: Node2D = $app/document
@onready var v_box_container: VBoxContainer = $app/ScrollContainer/VBoxContainer
@onready var app: Node2D = $app
@onready var structure_minigame: Node2D = $structure_minigame

@export var document_scene: PackedScene
@export var outline_scene: PackedScene
@export var time := 0
@export var is_tutorial_1 := false

var selected_outline = null
var selected_object = null
var all_object := []
var all_images := []
var all_texts := []

signal image_clicked # untuk tutor 1

func _ready() -> void:
	if is_tutorial_1:
		$app/minigame_icons/image_features/structure_button.self_modulate = Color(0.451, 0.451, 0.451)
		$app/minigame_icons/image_features/structure_button.disabled = true
		
		$app/minigame_icons/docs_features/color_wheel_button.self_modulate = Color(0.451, 0.451, 0.451)
		$app/minigame_icons/docs_features/color_wheel_button.disabled = true
		
		$app/minigame_icons/text_features/color_wheel_button.self_modulate = Color(0.451, 0.451, 0.451)
		$app/minigame_icons/text_features/color_wheel_button.disabled = true
		
		$app/minigame_icons/text_features/structure_button.self_modulate = Color(0.451, 0.451, 0.451)
		$app/minigame_icons/text_features/structure_button.disabled = true
		
	var doc = document_scene.instantiate()
	document.add_child(doc)
	doc.global_position = document.global_position
	get_all_obj()
	timer.wait_time = time
	timer.start()

func _process(delta: float) -> void:
	var minutes = int(timer.time_left) / 60
	var seconds = int(timer.time_left) % 60
	var minutes_str = str(minutes).pad_zeros(2)
	var seconds_str = str(seconds).pad_zeros(2)
	timer_label.text = minutes_str + ":" + seconds_str
func get_all_images():
	var images = find_child("document").get_child(0).get_images()
	for image in images:
		all_images.append(image)

func get_all_text():
	var texts = find_child("document").get_child(0).get_texts()
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
			obj.name = "text " + str(text_count)
			create_outline(obj.name)
			text_count += 1
		else:
			obj.name = "image " + str(image_count)
			create_outline(obj.name)
			image_count += 1
			
func create_outline(obj_name):
	var outline = outline_scene.instantiate()
	outline.name = obj_name
	v_box_container.add_child(outline)
func select(obj):
	if (selected_object):
		selected_object.emit_signal("deselect")
		selected_outline = find_outline(selected_object)
		if selected_outline != null:
			selected_outline.emit_signal("deselect")
		if (selected_object == obj):
			show_nothing()
			selected_object = null
			show_features()
			return
		selected_object = null
	selected_object = obj
	show_features()
	
	selected_outline = find_outline(selected_object)
	if (selected_outline != null):
		selected_outline.emit_signal("selected")
	
	obj.emit_signal("selected")
	if (obj.is_in_group("images")):
			emit_signal("image_clicked")

func find_outline(obj):
	var outlines = v_box_container.get_children()
	for outline in outlines:
		if outline.name == obj.name:
			return outline
			
func select_outline(outline):
	if (selected_outline):
		if (selected_object):
			selected_object.emit_signal("deselect")
		selected_outline.emit_signal("deselect")
		if (selected_outline == outline):
			selected_object = null
			selected_outline = null
			show_features()
			
			return
		selected_object = null
		selected_outline = null
	selected_outline = outline
	selected_outline.emit_signal("selected")
	var obj
	for object in all_object:
		if object.name == selected_outline.name:
			obj = object
			break
	selected_object = obj
	show_features()
	if (obj.is_in_group("images")):
		emit_signal("image_clicked")
	
	obj.emit_signal("selected")

func sort_by_pos(a, b):
	if a.global_position.y < b.global_position.y:
		return true
	return false

func show_features():
	if selected_object == null:
		show_nothing()
	elif selected_object.is_in_group("document"):
		show_doc_features()
	elif selected_object.is_in_group("images"):
		show_image_features()
	else:
		show_text_features()
		
func show_image_features():
	image_features.show()
	docs_features.hide()
	text_features.hide()
	
func show_text_features():
	text_features.show()
	image_features.hide()
	docs_features.hide()

func show_doc_features():
	docs_features.show()
	text_features.hide()
	image_features.hide()
	
func show_nothing():
	image_features.hide()
	docs_features.hide()
	text_features.hide()
	
func examine():
	for obj in all_object:
		if (obj.is_in_group("images")):
			#TODO cek aksesibility image
			pass
		else:
			#TODO cek aksesibility teks
			pass


	


func _on_color_wheel_button_pressed() -> void:
	if (selected_object == null):
		return
	elif (selected_object.is_in_group("texts")):
		color_wheel_minigame.init_wheel(selected_object)
	else:
		color_wheel_minigame.init_wheel(document_paper)
	animation_player.play("show_color_wheel_minigame")
	app.process_mode = Node.PROCESS_MODE_DISABLED
	
	await animation_player.animation_finished
	color_wheel_minigame.start_rotating()
	


func _on_color_wheel_minigame_done() -> void:
	var color = color_wheel_minigame.return_color()
	if (selected_object.is_in_group("texts")):
		selected_object.add_theme_color_override("font_color", color)
	else:
		document_paper.self_modulate = color
	animation_player.play("show_color_wheel_minigame", -1, -1.0, true)
	app.process_mode = Node.PROCESS_MODE_INHERIT

func _on_alt_text_button_pressed() -> void:
	if (selected_object == null):
		return
	animation_player.play("show_alt_text_minigame")
	await animation_player.animation_finished
	alt_text_minigame.init_alt_text(selected_object.get_texts_list(), selected_object.get_texture(), selected_object.get_alt_text())
	alt_text_minigame.set_alt_text_pos()
	alt_text_minigame.reset_all_alt_texts(selected_object.get_alt_text())
	app.process_mode = Node.PROCESS_MODE_DISABLED
	
	


func _on_color_wheel_minigame_canceled() -> void:
	animation_player.play("show_color_wheel_minigame", -1, -1.0, true)
	app.process_mode = Node.PROCESS_MODE_INHERIT


func _on_alt_text_minigame_canceled() -> void:
	animation_player.play("show_alt_text_minigame", -1, -1.0, true)
	app.process_mode = Node.PROCESS_MODE_INHERIT


func _on_alt_text_minigame_done(text) -> void:
	selected_object.set_alt_text(text)
	animation_player.play("show_alt_text_minigame", -1, -1.0, true)
	app.process_mode = Node.PROCESS_MODE_INHERIT
	
	
	
	
	
	
func _on_structure_button_pressed() -> void:
	if selected_object == null:
		return
	animation_player.play("show_structure_minigame")
	var texts = get_all_text_in_a_part(selected_object.get_part())
	structure_minigame.init(texts)
	await animation_player.animation_finished
	app.process_mode = Node.PROCESS_MODE_DISABLED
	
func get_all_text_in_a_part(selected_part: int):
	var texts = []
	for text in all_texts:
		if text.part == selected_part:
			texts.append(text)
	return texts
	

func update_outline():
	var outlines = v_box_container.get_children()
	for outline in outlines:
		outline.update_outline()
	
func _on_structure_minigame_done() -> void:
	var result = structure_minigame.return_result()
	var heading_count = 0
	var subheading_count = 0
	var text_count = 0
	for doc_text in all_texts:
		if result.has(doc_text.text):
			var structure = result[doc_text.text]
			doc_text.structure = structure
			var outline = find_outline_text(doc_text.name)
			if structure.containsn("subheading"):
				subheading_count += 1
				text_count = 0
				doc_text.name = "subheading " + str(subheading_count)
			elif structure.containsn("heading"):
				heading_count += 1
				subheading_count = 0
				text_count = 0
				doc_text.name = "heading " + str(heading_count)
			else:
				text_count += 1
				doc_text.name = "text " + str(text_count)
			outline.name = doc_text.name
	update_text_outline()
	animation_player.play("show_structure_minigame", -1, -1.0, true)
	app.process_mode = Node.PROCESS_MODE_INHERIT

func find_outline_text(target_text):
	for child in v_box_container.get_children():
		if child.name == target_text:
			return child

func update_text_outline():
	var heading_count = 0
	var subheading_count = 0
	var text_count = 0
	for text in all_texts:
		var outline = find_outline_text(text.name)
		if text.name.containsn("subheading"):
			subheading_count += 1
			text_count = 0
			text.name = "subheading " + str(subheading_count)
		elif text.name.containsn("heading"):
			heading_count += 1
			subheading_count = 0
			text_count = 0
			text.name = "heading " + str(heading_count)
		else:
			text_count += 1
			text.name = "text " + str(text_count)
			outline.name = text.name
		print(outline)
func _on_structure_minigame_canceled() -> void:
	animation_player.play("show_structure_minigame", -1, -1.0, true)
	app.process_mode = Node.PROCESS_MODE_INHERIT

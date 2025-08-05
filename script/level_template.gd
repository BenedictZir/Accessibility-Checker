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
@onready var text_tidak_jelas: Label = $app/accessibility_checker/Sprite2D/text_tidak_jelas
@onready var tidak_ada_alt_text: Label = $app/accessibility_checker/Sprite2D2/tidak_ada_alt_text
@onready var struktur_salah: Label = $app/accessibility_checker/Sprite2D3/struktur_salah



@export var document_scene: PackedScene
@export var outline_scene: PackedScene
@export var time := 0
@export var is_tutorial_1 := false
var total_score := 0.0
var accessibility_score := 0.9
var constaint_score := 0
var difficulty_mult := 1
var timer_score := 0

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
	if document_scene:
		var doc = document_scene.instantiate()
		document.add_child(doc)
		doc.global_position = document.global_position
		get_all_obj()
		timer.wait_time = time
		timer.start()
		examine()
		$app/nama_dokumen.text = doc.judul
		

func _process(delta: float) -> void:
	total_score = (accessibility_score / (4 * all_object.size()) * 60 / 100 * 2500)
	var minutes = int(timer.time_left) / 60
	var seconds = int(timer.time_left) % 60
	var minutes_str = str(minutes).pad_zeros(1)
	var seconds_str = str(seconds).pad_zeros(2)
	timer_label.text = minutes_str + ":" + seconds_str
func get_all_images():
	var images = find_child("document").get_child(0).get_images()
	for image in images:
		all_images.append(image)
	all_images.sort_custom(sort_by_pos)

func get_all_text():
	var texts = find_child("document").get_child(0).get_texts()
	for text in texts:
		all_texts.append(text)
	all_texts.sort_custom(sort_by_pos)
func get_all_obj():
	get_all_images()
	get_all_text()
	
	for text in all_texts:
		all_object.append(text)
	for image in all_images:
		all_object.append(image)
	all_object.sort_custom(sort_by_pos)
	var subjudul_count = 0
	var judul_count = 0
	var text_count = 0
	var image_count = 1
	
	for obj in all_object:
		if obj.is_in_group("texts"):
			if obj.get_structure().contains("subjudul"):
				subjudul_count += 1
				text_count = 0 
				obj.name = obj.get_structure() + " " + str(subjudul_count)
			elif obj.get_structure().contains("judul"):
				subjudul_count = 0
				judul_count += 1
				text_count = 0
				obj.name = obj.get_structure() + " " + str(judul_count)
				
			else:
				text_count += 1
				obj.name = obj.get_structure() + " " + str(text_count)
			obj.display_name = obj.name
			create_outline(obj, obj.display_name)
			text_count += 1
		else:
			obj.name = "foto " + str(image_count)
			obj.display_name = obj.name
			create_outline(obj, obj.display_name)
			image_count += 1
			
func create_outline(obj, display_name):
	var outline = outline_scene.instantiate()
	outline.name = obj.name + "_outline"
	outline.set_display_name(display_name)
	outline.bind_object(obj)
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
	for outline in v_box_container.get_children():
		if outline.get_bound_object() == obj:
			return outline
	return null
			
func select_outline(outline):
	if selected_outline:
		if selected_object:
			selected_object.emit_signal("deselect")
		selected_outline.emit_signal("deselect")
		if selected_outline == outline:
			selected_object = null
			selected_outline = null
			show_features()
			return
		selected_object = null
		selected_outline = null

	selected_outline = outline
	selected_outline.emit_signal("selected")
	selected_object = outline.get_bound_object()
	show_features()
	if selected_object.is_in_group("images"):
		emit_signal("image_clicked")
	selected_object.emit_signal("selected")
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
	accessibility_score = 0
	var image_dont_have_alt_text = 0
	var color_used = []
	var text_tidak_contrast = 0
	var text_wrong_structure = 0
	for obj in all_object:
		if (obj.is_in_group("images")):
			accessibility_score += obj.examine()
			if obj.examine() <= 0:
				image_dont_have_alt_text += 1
			
		else:
			accessibility_score += obj.examine_structure()
			if obj.examine_structure() <= 0:
				text_wrong_structure += 1
			accessibility_score += obj.examine_color(document_paper.self_modulate)
			if obj.examine_color(document_paper.self_modulate) <= 0:
				text_tidak_contrast += 1
	if text_tidak_contrast > 0:
		text_tidak_jelas.text = str(text_tidak_contrast)
		text_tidak_jelas.show()
		$app/accessibility_checker/Sprite2D/check_circle.hide()
	else:
		$app/accessibility_checker/Sprite2D/check_circle.show()
		text_tidak_jelas.hide()
		
	if text_wrong_structure > 0:
		struktur_salah.text = str(text_wrong_structure)
		struktur_salah.show()
		$app/accessibility_checker/Sprite2D3/check_circle.hide()
	else:
		$app/accessibility_checker/Sprite2D3/check_circle.show()
		struktur_salah.hide()
		
	if image_dont_have_alt_text > 0:
		tidak_ada_alt_text.text = str(image_dont_have_alt_text)
		tidak_ada_alt_text.show()
		$app/accessibility_checker/Sprite2D2/check_circle.hide()
	else:
		$app/accessibility_checker/Sprite2D2/check_circle.show()
		tidak_ada_alt_text.hide()

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
	examine()

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
	examine()
	
	
	
	
	
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
	


	
func _on_structure_minigame_done() -> void:
	var result = structure_minigame.return_result()
	for doc_text in all_texts:
		if result.has(doc_text.text):
			doc_text.structure = result[doc_text.text]

	update_text_outline()
	examine()

	animation_player.play("show_structure_minigame", -1, -1.0, true)
	app.process_mode = Node.PROCESS_MODE_INHERIT
	
func find_outline_text(target_text):
	for child in v_box_container.get_children():
		if child.name == target_text:
			return child

func update_text_outline():
	var judul_count = 0
	var subjudul_count = 0
	var teks_count = 0

	for text in all_texts:
		var outline = find_outline(text)
		var display_name = ""

		if text.structure.containsn("subjudul"):
			subjudul_count += 1
			teks_count = 0
			display_name = "subjudul " + str(subjudul_count)
		elif text.structure.containsn("judul"):
			judul_count += 1
			subjudul_count = 0
			teks_count = 0
			display_name = "judul " + str(judul_count)
		else:
			teks_count += 1
			display_name = "teks " + str(teks_count)

		text.display_name = display_name
		if outline:
			outline.set_display_name(display_name)
func _on_structure_minigame_canceled() -> void:
	animation_player.play("show_structure_minigame", -1, -1.0, true)
	app.process_mode = Node.PROCESS_MODE_INHERIT

func set_document(document):
	var doc = document_scene.instantiate()
	$app/nama_dokumen.text = doc.judul
	document.add_child(doc)
	doc.global_position = document.global_position
	get_all_obj()
	timer.wait_time = time
	timer.start()
	examine()

extends Node2D

@onready var timer: Timer = $app/Sprite2D/Timer
@onready var timer_label: Label = $app/Sprite2D/timer_label

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
@onready var selesai: Button = $app/selesai

const DOCUMENT_SCENE_1_2 = preload("res://scene/documents/document_scene_1_2.tscn")
@export var outline_scene: PackedScene
@export var time := 0
var is_tutorial_1 := false
var is_tutorial_2 := false
var is_tutorial_3 := false
var is_tutorial_4 := false
var timer_score = 0
var total_score := 0.0
var accessibility_score := 0.0
var constraint_score := 0.0
var difficulty_mult := 1.0
var constraint_list  = []
var constraint_correct = []
var selected_outline = null
var selected_object = null
var all_object := []
var all_images := []
var all_texts := []

const COLORS = {
	"merah" : Color("#d10f0b"),
	"oranye" : Color("#ff750a"),
	"kuning" : Color("#ffeb3b"),
	"hijau" : Color("#01b046"),
	"biru" : Color("#296cd4"),
	"hitam" : Color("#253238"),
	"ungu" : Color("#5f006f"),
	"putih" : Color("#fbfbfb")
}
signal image_clicked # untuk tutor 1
signal text_clicked # untuk tutor 2
signal button_structure_clicked

signal wrong_alt_text
signal tutorial_done
signal selesai_button_clicked

signal done_working
func _ready() -> void:
	#set_document(preload("res://scene/documents/document_scene_2_2.tscn"), "easy")
	
	
	pass

func _process(delta: float) -> void:
	if is_tutorial_1:
		
		$app/aruni_helper.hide()
		$app/Sprite2D.hide()
		$app/minigame_icons/docs_features/color_wheel_button.self_modulate = Color(0.451, 0.451, 0.451)
		$app/minigame_icons/docs_features/color_wheel_button.disabled = true
		
		$app/minigame_icons/text_features/color_wheel_button.self_modulate = Color(0.451, 0.451, 0.451)
		$app/minigame_icons/text_features/color_wheel_button.disabled = true
		
		$app/minigame_icons/text_features/structure_button.self_modulate = Color(0.451, 0.451, 0.451)
		$app/minigame_icons/text_features/structure_button.disabled = true
		examine()
		if accessibility_score < 36:
			selesai.hide()
			$app/SelesaiButtonBg.hide()
		else:
			emit_signal("tutorial_done")
			selesai.show()
			$app/SelesaiButtonBg.show()
			
		for obj in all_object:
			if (obj.is_in_group("images")):
				if obj.examine() == 1:
					wrong_alt_text.emit()
	elif is_tutorial_2:
		$app/aruni_helper.hide()
		$app/Sprite2D.hide()
		$app/minigame_icons/docs_features/color_wheel_button.self_modulate = Color(0.451, 0.451, 0.451)
		$app/minigame_icons/docs_features/color_wheel_button.disabled = true
		
		$app/minigame_icons/text_features/color_wheel_button.self_modulate = Color(0.451, 0.451, 0.451)
		$app/minigame_icons/text_features/color_wheel_button.disabled = true
		examine()
		if accessibility_score < 64:
			selesai.hide()
			$app/SelesaiButtonBg.hide()
			
		else:
			selesai.show()
			$app/SelesaiButtonBg.show()
			
	elif is_tutorial_3:
		$app/Sprite2D.hide()
		$aruna_helper_screen/panduan_tugas_button.hide()
		$app/minigame_icons/image_features/alt_text_button.self_modulate = Color(0.451, 0.451, 0.451)
		$app/minigame_icons/image_features/alt_text_button.disabled = true
		$app/minigame_icons/text_features/structure_button.self_modulate = Color(0.451, 0.451, 0.451)
		$app/minigame_icons/text_features/structure_button.disabled = true
		examine()
		if accessibility_score < 36:
			selesai.hide()
			$app/SelesaiButtonBg.hide()
			
		else:
			selesai.show()
			$app/SelesaiButtonBg.show()
			

	elif is_tutorial_4:
		pass

	else:
		timer_score = (ceil(timer.time_left / 60)) * 50
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
	
	all_object.clear()
	for text in all_texts:
		all_object.append(text)
	for image in all_images:
		all_object.append(image)
	all_object.sort_custom(sort_by_pos)

	var subjudul_count = 0
	var judul_count = 0
	var text_count = 0
	var image_count = 1
	var unique_id = 1  # ID unik supaya nama tidak bentrok
	
	for obj in all_object:
		if obj.is_in_group("texts"):
			if obj.get_structure().contains("subjudul"):
				subjudul_count += 1
				text_count = 0
				obj.display_name = "subjudul " + str(subjudul_count)
			
			elif obj.get_structure().contains("judul"):
				judul_count += 1
				subjudul_count = 0
				text_count = 0
				image_count = 1
				obj.display_name = "judul " + str(judul_count)
				
			else:
				text_count += 1
				obj.display_name = "teks " + str(text_count)

			# name harus unik supaya Godot nggak rename otomatis
			obj.name = obj.display_name + "#" + str(unique_id)
			unique_id += 1

			create_outline(obj, obj.display_name)

		elif obj.is_in_group("images"):
			obj.display_name = "foto " + str(image_count)
			obj.name = obj.display_name + "#" + str(unique_id)
			unique_id += 1
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
	if obj.is_in_group("texts"):
		emit_signal("text_clicked")
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
	if selected_object.is_in_group("texts"):
		emit_signal("text_clicked")
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
	button_structure_clicked.emit()
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
	var outlines = v_box_container.get_children()
	for outline in outlines:
		outline.queue_free()
	all_object.clear()
	for text in all_texts:
		all_object.append(text)
	for image in all_images:
		all_object.append(image)
	all_object.sort_custom(sort_by_pos)
	
	var subjudul_count = 0
	var judul_count = 0
	var text_count = 0
	var image_count = 1
	var unique_id = 1
	
	for obj in all_object:
		if obj.is_in_group("texts"):
			if obj.get_structure().containsn("subjudul"):
				subjudul_count += 1
				text_count = 0
				obj.display_name = "subjudul " + str(subjudul_count)
			
			elif obj.get_structure().containsn("judul"):
				judul_count += 1
				subjudul_count = 0
				text_count = 0
				image_count = 1
				obj.display_name = "judul " + str(judul_count)
				
			else:
				text_count += 1
				obj.display_name = "teks " + str(text_count)
			
			obj.name = obj.display_name + "#" + str(unique_id)
			unique_id += 1

			create_outline(obj, obj.display_name)

		elif obj.is_in_group("images"):
			obj.display_name = "foto " + str(image_count)
			obj.name = obj.display_name + "#" + str(unique_id)
			unique_id += 1
			create_outline(obj, obj.display_name)
			image_count += 1
func _on_structure_minigame_canceled() -> void:
	animation_player.play("show_structure_minigame", -1, -1.0, true)
	app.process_mode = Node.PROCESS_MODE_INHERIT

func set_document(document_random, diff):
	if (diff == "easy"):
		difficulty_mult = 1
	elif (diff == "medium"):
		difficulty_mult = 1.25
	else:
		difficulty_mult = 1.5
	color_wheel_minigame.set_speed(diff)
	var doc = document_random.instantiate()
	if doc.paper_color in COLORS:
		document_paper.self_modulate = COLORS[doc.paper_color]
	$app/nama_dokumen.text = doc.judul
	document.add_child(doc)
	doc.global_position = document.global_position
	get_all_obj()
	timer.wait_time = time
	examine()



func disable_all_button():
	$app/pause_button.disabled = true
	$app/selesai.disabled = true
	$app/minigame_icons/image_features/alt_text_button.disabled = true
	$app/minigame_icons/docs_features/color_wheel_button.disabled = true
	$app/minigame_icons/text_features/color_wheel_button.disabled = true
	$app/minigame_icons/text_features/structure_button.disabled = true

func enable_all_button():
	$app/pause_button.disabled = false
	$app/selesai.disabled = false
	$app/minigame_icons/image_features/alt_text_button.disabled = false
	$app/minigame_icons/docs_features/color_wheel_button.disabled = false
	$app/minigame_icons/text_features/color_wheel_button.disabled = false
	$app/minigame_icons/text_features/structure_button.disabled = false

func _on_selesai_pressed() -> void:
	
	selesai_button_clicked.emit()
	check_constraint()
		
	animation_player.play("show_result_screen")
	timer.stop()
	var true_constraint_count = 0.0
	for correct in constraint_correct:
		if correct:
			true_constraint_count += 1

	var acc_score = (accessibility_score / (4 * all_object.size()) * 6 * 250) # max 1500
	$result_screen/SkorAksesibel/acc_score_label.text = str(int(acc_score)).pad_zeros(4)
	if constraint_list.size() > 0:
		constraint_score = (true_constraint_count / constraint_list.size()) * 4 * 250
	$result_screen/SkorMisi/misi_score_label.text = str(int(constraint_score)).pad_zeros(4)
	$result_screen/Skortimer/timer_score_label.text = str(int(timer_score)).pad_zeros(4)
	

	var total_score_before_mult = acc_score + constraint_score + timer_score

	$result_screen/mult_box/Label2.text = str(difficulty_mult)
	if is_tutorial_1 or is_tutorial_2 or is_tutorial_3:
		$result_screen/SkorMisi.hide()
		$result_screen/Skortimer.hide()
		$result_screen/mult_box.hide()
		$result_screen/bg_mult.hide()
		total_score_before_mult -= timer_score + constraint_score
		
	Dialogic.VAR.poin_inklusif_harian = total_score_before_mult
	total_score = total_score_before_mult * difficulty_mult
	$result_screen/Total/total_score_label.text = str(int(total_score)).pad_zeros(4)
	Dialogic.VAR.poin_inklusif += total_score
	app.process_mode = Node.PROCESS_MODE_DISABLED
	
func set_constraint(constraint_set):
	var constraint_labels = [$aruna_helper_screen/panduan_tugas/constraint_1_label, $aruna_helper_screen/panduan_tugas/constraint_2_label, $aruna_helper_screen/panduan_tugas/constraint_1_label3, $aruna_helper_screen/panduan_tugas/constraint_1_label4, $aruna_helper_screen/panduan_tugas/constraint_1_label5]
	var constraint_labels_2 = [$mulai_kerja/constraint_1, $mulai_kerja/constraint_2, $mulai_kerja/constraint_3, $mulai_kerja/constraint_4, $mulai_kerja/constraint_5]
	constraint_list = constraint_set
	var count = 0
	for constraint in constraint_list:
		constraint_correct.append(false)
		constraint_labels[count].text = constraint
		constraint_labels_2[count].text = constraint
		count += 1
	for i in range(count, 5):
		constraint_labels[i].hide()
		constraint_labels_2[i].hide()

func check_constraint():
	for  i in range(constraint_list.size()):
		var constraint = constraint_list[i]
		if constraint.begins_with("Selesaikan tugas tidak lebih dari "):
			var words = constraint.split(" ")
			var time_constraint = int(words[5]) * 60
			constraint_correct[i] = check_constraint_type_1(time_constraint)
			
		elif constraint.begins_with("Gunakan hanya 1 warna untuk setiap jenis teks"):
			var words = constraint.split(" ")
			constraint_correct[i] = check_constraint_type_2()
			
			
		elif constraint.begins_with("Gunakan minimal "):
			var words = constraint.split(" ")
			var min_colors = int(words[2])
			constraint_correct[i] = check_constraint_type_3(min_colors)
			
		elif constraint.begins_with("Jangan gunakan warna "):
			var words = constraint.split(" ")
			var forbidden_color = COLORS[words[3]]
			constraint_correct[i] = check_constraint_type_4(forbidden_color)
			
		elif constraint.begins_with("Gunakan warna ") and "pada elemen teks" in constraint:
			var words = constraint.split(" ")
			var must_use_text_color = COLORS[words[2]]
			constraint_correct[i] = check_constraint_type_5(must_use_text_color)

		elif constraint.begins_with("Gunakan warna ") and "pada latar belakang" in constraint:
			var words = constraint.split(" ")
			var must_use_bg_color = COLORS[words[2]]
			constraint_correct[i] = check_constraint_type_6(must_use_bg_color)

		elif constraint.begins_with("Gunakan warna "):
			var words = constraint.split(" ")
			var must_use_color = COLORS[words[2]]
			constraint_correct[i] = check_constraint_type_7(must_use_color)
			
			
func check_constraint_type_1(time_constraint):
	if timer.time_left > timer.wait_time - time_constraint:
		return true
	return false
func check_constraint_type_2():
	var color_per_structure = {}
	for text in all_texts:
		var text_color = text.get_theme_color("font_color")
		var structure = text.get_structure()
		if structure in color_per_structure:
			if not colors_equal(color_per_structure[structure], text_color):
				return false
		else:
			color_per_structure[structure] = text_color
	return true
func check_constraint_type_3(min_colors):
	var color_used = []
	for text in all_texts:
		var text_color = text.get_theme_color("font_color")
		if not (text_color in color_used):
			color_used.append(text_color)
	var doc_color = document_paper.self_modulate
	if not (doc_color in color_used):
		color_used.append(doc_color)
	
	if color_used.size() < min_colors:
		return false
	else:
		return true
	
func check_constraint_type_4(forbidden_color):
	for text in all_texts:
		var text_color = text.get_theme_color("font_color")
		if colors_equal(text_color, forbidden_color):
			return false
	var doc_color = document_paper.self_modulate
	if colors_equal(forbidden_color, doc_color):
		return false
	return true
	
func check_constraint_type_5(must_use_text_color):
	for text in all_texts:
		var text_color = text.get_theme_color("font_color")
		if colors_equal(text_color, must_use_text_color):
			return true
	return false
	
func check_constraint_type_6(must_use_bg_color):
	var doc_color = document_paper.self_modulate
	if colors_equal(doc_color, must_use_bg_color):
		return true
	return false
	
func check_constraint_type_7(must_use_color):
	for text in all_texts:
		var text_color = text.get_theme_color("font_color")
		if colors_equal(text_color, must_use_color):
			return true
	var doc_color = document_paper.self_modulate
	if colors_equal(doc_color, must_use_color):
		return true
	return false





func _on_aruni_helper_aruna_pressed() -> void:
	animation_player.play("show_aruna_helper_screen")
	app.process_mode = Node.PROCESS_MODE_DISABLED



func _on_cancel_aruna_pressed() -> void:
	animation_player.play("show_aruna_helper_screen", -1, -1.0, true)
	app.process_mode = Node.PROCESS_MODE_INHERIT
	

func colors_equal(c1: Color, c2: Color, tolerance := 0.01) -> bool:
	return abs(c1.r - c2.r) < tolerance and abs(c1.g - c2.g) < tolerance and abs(c1.b - c2.b) < tolerance and abs(c1.a - c2.a) < tolerance


func _on_lanjut_pressed() -> void:
	GlobalVar.done_working_today = true
	emit_signal("done_working")
		


func _on_panduan_warna_pressed() -> void:
	if $aruna_helper_screen/tabel_warna.modulate == Color("ffffff00"):
		animation_player.play("show_panduan", -1, -1.0, true)


func _on_panduan_tugas_button_pressed() -> void:
	if $aruna_helper_screen/panduan_tugas.modulate == Color("ffffff00"):
		animation_player.play("show_panduan")

func start():
	SoundManager.play_minigame_music()
	disable_all_button()
	animation_player.play("init")
	app.process_mode = Node.PROCESS_MODE_DISABLED

func _on_mulai_kerja_pressed() -> void:
	timer.start()
	animation_player.play("mulai_kerja")
	enable_all_button()
	app.process_mode = Node.PROCESS_MODE_INHERIT
	

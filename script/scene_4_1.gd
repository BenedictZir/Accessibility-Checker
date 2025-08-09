extends Node2D
var document
@onready var level_template: Node2D = $level_template

var CONSTRAINT_SET = [
	["Selesaikan tugas tidak lebih dari 2 menit", "Gunakan hanya 1 warna untuk setiap jenis teks", "Gunakan minimal 3 warna", "Jangan gunakan warna merah", "Gunakan warna biru", "Gunakan warna hitam pada elemen teks", "Gunakan warna putih pada latar belakang"],
	["Selesaikan tugas tidak lebih dari 2 menit", "Gunakan hanya 1 warna untuk setiap jenis teks", "Gunakan minimal 3 warna", "Jangan gunakan warna hijau", "Gunakan warna kuning", "Gunakan warna putih pada elemen teks", "Gunakan warna hitam pada latar belakang"],
	["Selesaikan tugas tidak lebih dari 2 menit", "Gunakan minimal 3 warna", "Gunakan warna oranye", "Gunakan warna kuning pada elemen teks", "Gunakan warna hitam pada latar belakang"],
	["Selesaikan tugas tidak lebih dari 2 menit", "Gunakan hanya 1 warna untuk setiap jenis teks", "Gunakan minimal 3 warna", "Jangan gunakan warna putih", "Gunakan warna oranye", "Gunakan warna kuning pada elemen teks", "Gunakan warna ungu pada latar belakang"]
]

var easy_document_list = []
var medium_document_list = []
var hard_document_list = []
var constraint_list

func _ready() -> void:
	SoundManager.play_kantor_music()

	load_documents()
	constraint_list = CONSTRAINT_SET.pick_random()
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("scene_4_1")

func _on_dialogic_signal(arg):  
	match arg:
		"end":
			SceneTransition.transition()
			await SceneTransition.animation_player.animation_finished
			SoundManager.stop_music()
			SoundManager.play_minigame_music()
			level_template.show()
			level_template.start()
			Dialogic.start("scene_4_1", "after_start")
		"end_day":
			SceneTransition.change_scene("res://scene/map.tscn")
		"easy_diff":
			document = get_random_document("easy")
			level_template.set_document(document, "easy")
			var constraints = []
			for i in range(3):
				var constraint = constraint_list.pick_random()
				constraint_list.erase(constraint)
				constraints.append(constraint)
			level_template.set_constraint(constraints)
		"medium_diff":
			document = get_random_document("medium")
			level_template.set_document(document, "medium")
			var constraints = []
			for i in range(4):
				var constraint = constraint_list.pick_random()
				constraint_list.erase(constraint)
				constraints.append(constraint)
			level_template.set_constraint(constraints)
		"hard_diff":
			document = get_random_document("hard")
			level_template.set_document(document, "hard")
			var constraints = []
			for i in range(5):
				var constraint = constraint_list.pick_random()
				constraint_list.erase(constraint)
				constraints.append(constraint)
			level_template.set_constraint(constraints)

func _on_level_template_done_working() -> void:
	SceneTransition.change_scene("res://story_scene/scene_4_2.tscn")

func load_documents():
	var dir = DirAccess.open("res://scene/documents/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tscn"):
				var path = "res://scene/documents/" + file_name
				if file_name.begins_with("document_easy"):
					easy_document_list.append(load(path))
				elif file_name.begins_with("document_medium"):
					medium_document_list.append(load(path))
				elif file_name.begins_with("document_hard"):
					hard_document_list.append(load(path))
			file_name = dir.get_next()
		dir.list_dir_end()
	print(easy_document_list)
	GlobalVar.easy_remaining = easy_document_list.duplicate()
	GlobalVar.medium_remaining = medium_document_list.duplicate()
	GlobalVar.hard_remaining = hard_document_list.duplicate()

func get_random_document(difficulty: String):
	var remaining_list
	var full_list

	match difficulty:
		"easy":
			remaining_list = GlobalVar.easy_remaining
			full_list = easy_document_list
		"medium":
			remaining_list = GlobalVar.medium_remaining
			full_list = medium_document_list
		"hard":
			remaining_list = GlobalVar.hard_remaining
			full_list = hard_document_list

	if remaining_list.size() == 0:
		remaining_list.append_array(full_list)

	var doc = remaining_list.pick_random()
	remaining_list.erase(doc)
	return doc

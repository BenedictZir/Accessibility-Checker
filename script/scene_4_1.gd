extends Node2D
var document
@onready var level_template: Node2D = $level_template

var CONSTRAINT_SET = [
	["Selesaikan tugas tidak lebih dari 2 menit", "Gunakan hanya 1 warna untuk setiap jenis teks", "Gunakan minimal 3 warna", "Jangan gunakan warna merah", "Gunakan warna biru", "Gunakan warna hitam pada elemen teks", "Gunakan warna putih pada latar belakang"],
	["Selesaikan tugas tidak lebih dari 2 menit", "Gunakan hanya 1 warna untuk setiap jenis teks", "Gunakan minimal 3 warna", "Jangan gunakan warna hijau", "Gunakan warna kuning", "Gunakan warna putih pada elemen teks", "Gunakan warna hitam pada latar belakang"],
	["Selesaikan tugas tidak lebih dari 2 menit", "Gunakan minimal 3 warna", "Gunakan warna oranye", "Gunakan warna kuning pada elemen teks", "Gunakan warna hitam pada latar belakang"],
	["Selesaikan tugas tidak lebih dari 2 menit", "Gunakan hanya 1 warna untuk setiap jenis teks", "Gunakan minimal 3 warna", "Jangan gunakan warna putih", "Gunakan warna oranye", "Gunakan warna kuning pada elemen teks", "Gunakan warna ungu pada latar belakang"]
]
const DOCUMENT_EASY_1 = preload("res://scene/documents/document_easy_1.tscn")
const DOCUMENT_EASY_2 = preload("res://scene/documents/document_easy_2.tscn")
const DOCUMENT_EASY_3 = preload("res://scene/documents/document_easy_3.tscn")
const DOCUMENT_HARD_1 = preload("res://scene/documents/document_hard_1.tscn")
const DOCUMENT_HARD_2 = preload("res://scene/documents/document_hard_2.tscn")
const DOCUMENT_HARD_3 = preload("res://scene/documents/document_hard_3.tscn")
const DOCUMENT_MEDIUM_1 = preload("res://scene/documents/document_medium_1.tscn")
const DOCUMENT_MEDIUM_2 = preload("res://scene/documents/document_medium_2.tscn")
const DOCUMENT_MEDIUM_3 = preload("res://scene/documents/document_medium_3.tscn")
var easy_document_list = []
var medium_document_list = []
var hard_document_list = []
var constraint_list

func _ready() -> void:
	SoundManager.play_kantor_music()
	easy_document_list = [DOCUMENT_EASY_1, DOCUMENT_EASY_2,DOCUMENT_EASY_3]
	medium_document_list = [DOCUMENT_MEDIUM_1, DOCUMENT_MEDIUM_2, DOCUMENT_MEDIUM_3]
	hard_document_list = [DOCUMENT_HARD_1, DOCUMENT_HARD_2, DOCUMENT_HARD_3]
	if GlobalVar.easy_doc_used.size() == easy_document_list.size():
		GlobalVar.easy_doc_used.clear()
	if GlobalVar.medium_doc_used.size() == medium_document_list.size():
		GlobalVar.medium_doc_used.clear()
	if GlobalVar.hard_doc_used.size() == hard_document_list.size():
		GlobalVar.hard_doc_used.clear()
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


func get_random_document(difficulty: String):
	var doc
	for easy in GlobalVar.easy_doc_used:
		easy_document_list.erase(easy)
	for medium in GlobalVar.medium_doc_used:
		medium_document_list.erase(medium)
	for hard in GlobalVar.hard_doc_used:
		hard_document_list.erase(hard)
	match difficulty:
		"easy":
			doc = easy_document_list.pick_random()
			GlobalVar.easy_doc_used.append(doc)
		"medium":
			doc = medium_document_list.pick_random()
			GlobalVar.medium_doc_used.append(doc)
		"hard":
			doc = hard_document_list.pick_random()
			GlobalVar.hard_doc_used.append(doc)
	return doc

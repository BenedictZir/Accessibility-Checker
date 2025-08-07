extends Node2D

const CHARACTER_LIST = ["mbak_intan", "pak_anton", "mbak_rani"]
var pak_anton_scene = preload("res://scene/pak_anton.tscn")
var mbak_rani_scene = preload("res://scene/mbak_rani.tscn")
var mbak_intan_scene = preload("res://scene/mbak_intan.tscn")
var document
@onready var level_template: Node2D = $level_template

const CONSTRAINT_SET = [
	["Selesaikan tugas tidak lebih dari 2 menit", "Gunakan hanya 1 warna untuk setiap jenis teks", "Gunakan minimal 3 warna", "Jangan gunakan warna merah", "Gunakan warna biru", "Gunakan warna hitam pada elemen teks", "Gunakan warna putih pada latar belakang"],
	["Selesaikan tugas tidak lebih dari 2 menit", "Gunakan hanya 1 warna untuk setiap jenis teks", "Gunakan minimal 3 warna", "Jangan gunakan warna hijau", "Gunakan warna kuning", "Gunakan warna putih pada elemen teks", "Gunakan warna hitam pada latar belakang"],
	["Selesaikan tugas tidak lebih dari 2 menit", "Gunakan minimal 3 warna", "Gunakan warna oranye", "Gunakan warna kuning pada elemen teks", "Gunakan warna hitam pada latar belakang"],
	["Selesaikan tugas tidak lebih dari 2 menit", "Gunakan hanya 1 warna untuk setiap jenis teks", "Gunakan minimal 3 warna", "Jangan gunakan warna putih", "Gunakan warna oranye", "Gunakan warna kuning pada elemen teks", "Gunakan warna ungu pada latar belakang"]
]



var easy_document_list = [
	
]

var medium_document_list = [
	
]

var hard_document_list = [
	
]
@onready var character_node: Node2D = $character_node
var character_name = ""
var character_sprite: Node2D
var constraint_list
func _ready() -> void:
	load_documents()
	constraint_list = CONSTRAINT_SET.pick_random()
	character_name = CHARACTER_LIST.pick_random()
	match character_name:
		"pak_anton":
			character_sprite = pak_anton_scene.instantiate()
		"mbak_rani":
			character_sprite = mbak_rani_scene.instantiate()
		"mbak_intan":
			character_sprite = mbak_intan_scene.instantiate()
	character_node.add_child(character_sprite)
	var timeline = character_name + "_random_" + str(randi_range(1, 3))
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start(timeline)
	
func _on_dialogic_signal(arg):
	match arg:
		"easy_diff":
			document = easy_document_list.pick_random()
			level_template.set_document(document, "easy")
			var constraints = []
			for i in range(3):
				var constraint = constraint_list.pick_random()
				constraint_list.erase(constraint)
				constraints.append(constraint)
		"medium_diff":
			document = medium_document_list.pick_random()
			level_template.set_document(document, "medium")
			var constraints = []
			for i in range(4):
				var constraint = constraint_list.pick_random()
				constraint_list.erase(constraint)
				constraints.append(constraint)
			level_template.set_constraint(constraints)
			
		"hard_diff":
			document = hard_document_list.pick_random()
			level_template.set_document(document, "hard")
			var constraints = []
			for i in range(5):
				var constraint = constraint_list.pick_random()
				constraint_list.erase(constraint)
				constraints.append(constraint)
			level_template.set_constraint(constraints)
			


func _on_level_template_done_working() -> void:
	Dialogic.start("after_work_" + character_name)




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

extends Node2D

const CHARACTER_LIST = ["mbak_intan", "pak_anton", "mbak_rani"]

var document
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var level_template: Node2D = $level_template
@onready var live_caption_minigame: Node2D = $LiveCaptionMinigame

var CONSTRAINT_SET = [
	["Selesaikan tugas tidak lebih dari 2 menit", "Gunakan hanya 1 warna untuk setiap jenis teks", "Gunakan minimal 3 warna", "Jangan gunakan warna merah", "Gunakan warna biru", "Gunakan warna hitam pada elemen teks", "Gunakan warna putih pada latar belakang"],
	["Selesaikan tugas tidak lebih dari 2 menit", "Gunakan hanya 1 warna untuk setiap jenis teks", "Gunakan minimal 3 warna", "Jangan gunakan warna hijau", "Gunakan warna kuning", "Gunakan warna putih pada elemen teks", "Gunakan warna hitam pada latar belakang"],
	["Selesaikan tugas tidak lebih dari 2 menit", "Gunakan minimal 3 warna", "Gunakan warna oranye", "Gunakan warna kuning pada elemen teks", "Gunakan warna hitam pada latar belakang"],
	["Selesaikan tugas tidak lebih dari 2 menit", "Gunakan hanya 1 warna untuk setiap jenis teks", "Gunakan minimal 3 warna", "Jangan gunakan warna putih", "Gunakan warna oranye", "Gunakan warna kuning pada elemen teks", "Gunakan warna ungu pada latar belakang"]
]



#var easy_document_list = [
	#
#]
#
#var medium_document_list = [
	#
#]
#
#var hard_document_list = [
	#
#]
@onready var character_node: Node2D = $character_node
var character_name = ""
var character_sprite: Node2D
var constraint_list
func _ready() -> void:
	SoundManager.play_kantor_music()
	#easy_document_list = [GlobalVar.DOCUMENT_EASY_1, GlobalVar.DOCUMENT_EASY_2,GlobalVar.DOCUMENT_EASY_3]
	#medium_document_list = [GlobalVar.DOCUMENT_MEDIUM_1, GlobalVar.DOCUMENT_MEDIUM_2, GlobalVar.DOCUMENT_MEDIUM_3]
	#hard_document_list = [GlobalVar.DOCUMENT_HARD_1, GlobalVar.DOCUMENT_HARD_2, GlobalVar.DOCUMENT_HARD_3]
	#if GlobalVar.easy_doc_used.size() == easy_document_list.size():
		#GlobalVar.easy_doc_used.clear()
	#if GlobalVar.medium_doc_used.size() == medium_document_list.size():
		#GlobalVar.medium_doc_used.clear()
	#if GlobalVar.hard_doc_used.size() == hard_document_list.size():
		#GlobalVar.hard_doc_used.clear()
	constraint_list = CONSTRAINT_SET.pick_random()
	character_name = CHARACTER_LIST.pick_random()
	match character_name:
		"pak_anton":
			character_sprite = GlobalVar.pak_anton_scene.instantiate()
		"mbak_rani":
			character_sprite = GlobalVar.mbak_rani_scene.instantiate()
		"mbak_intan":
			character_sprite = GlobalVar.mbak_intan_scene.instantiate()
	character_node.add_child(character_sprite)
	#var timeline = character_name + "_random_" + str(randi_range(1, 3))
	if not Dialogic.signal_event.is_connected(_on_dialogic_signal):
		Dialogic.signal_event.connect(_on_dialogic_signal)
	#Dialogic.start(timeline)
	
	set_tugas()
	
func _on_dialogic_signal(arg):
	match arg:
		#"easy_diff":	
			#document = get_random_document("easy")
			#level_template.set_document(document, "easy")
			#var constraints = []
			#for i in range(3):
				#var constraint = constraint_list.pick_random()
				#constraint_list.erase(constraint)
				#constraints.append(constraint)
			#level_template.set_constraint(constraints)
			#
		#"medium_diff":
			#document = get_random_document("medium")
			#level_template.set_document(document, "medium")
			#var constraints = []
			#for i in range(4):
				#var constraint = constraint_list.pick_random()
				#constraint_list.erase(constraint)
				#constraints.append(constraint)
			#level_template.set_constraint(constraints)
		#"hard_diff":
			#document = get_random_document("hard")
			#level_template.set_document(document, "hard")
			#var constraints = []
			#for i in range(5):
				#var constraint = constraint_list.pick_random()
				#constraint_list.erase(constraint)
				#constraints.append(constraint)
			#level_template.set_constraint(constraints)
		"end":
			SceneTransition.transition()
			await SceneTransition.animation_player.animation_finished

			level_template.show()
			level_template.start()
		"show_leaderboard":
			if Dialogic.VAR.can_promote:
				show_win_leaderboard()
			else:
				show_lose_leaderboard()
		"end_day":
			SceneTransition.change_scene("res://scene/map.tscn")
		"hide_leaderboard":
			$leaderboard_lose.hide()
			$leaderboard_win.hide()
		"done_promoting":
			GlobalVar.idx_title += 1
			Dialogic.VAR.can_promote = false
func _on_level_template_done_working() -> void:
	SceneTransition.transition()
	await SceneTransition.animation_player.animation_finished
	level_template.hide()
	
	if GlobalVar.day == "JUMAT":
		# TODO 
		if GlobalVar.fired:
			#change cutscene to game over scene
			pass
		$background_audit.show()
		character_node.get_child(0).queue_free()
		character_node.add_child(GlobalVar.pak_anton_scene.instantiate())
		$character_node_left.add_child(GlobalVar.mbak_rani_scene.instantiate())
		$character_node_right.add_child(GlobalVar.mbak_intan_scene.instantiate())
		if Dialogic.signal_event.is_connected(_on_dialogic_signal):
			Dialogic.signal_event.disconnect(_on_dialogic_signal)
		Dialogic.signal_event.connect(_on_dialogic_signal)
		Dialogic.start("naik_pangkat")
	else:
		if Dialogic.signal_event.is_connected(_on_dialogic_signal):
			Dialogic.signal_event.disconnect(_on_dialogic_signal)
		Dialogic.signal_event.connect(_on_dialogic_signal)
		Dialogic.start("after_work_" + character_name)



	
#func get_random_document(difficulty: String):
	#var doc
	#for easy in GlobalVar.easy_doc_used:
		#easy_document_list.erase(easy)
	#for medium in GlobalVar.medium_doc_used:
		#medium_document_list.erase(medium)
	#for hard in GlobalVar.hard_doc_used:
		#hard_document_list.erase(hard)
	#match difficulty:
		#"easy":
			#doc = easy_document_list.pick_random()
			#GlobalVar.easy_doc_used.append(doc)
		#"medium":
			#doc = medium_document_list.pick_random()
			#GlobalVar.medium_doc_used.append(doc)
		#"hard":
			#doc = hard_document_list.pick_random()
			#GlobalVar.hard_doc_used.append(doc)
	#return doc

func show_lose_leaderboard():
	$leaderboard_lose.show()
	
	$leaderboard_lose/LeaderboardLabel2/label_name2.text = str(Dialogic.VAR.player_name)
	
	$leaderboard_lose/LeaderboardLabel/Label_point.text = str(int(GlobalVar.skor_list[GlobalVar.idx_title + 1] + 2500))
	$leaderboard_lose/LeaderboardLabel2/Label_point2.text = str(int(Dialogic.VAR.poin_inklusif))
	$leaderboard_lose/LeaderboardLabel3/Label_point3.text = str(int(Dialogic.VAR.poin_inklusif - 150))
	$leaderboard_lose/LeaderboardLabel4/Label_point4.text = str(int(Dialogic.VAR.poin_inklusif - 400))
	
	animation_player.play("show_lose_leaderboard")
	await animation_player.animation_finished
	Dialogic.start("naik_pangkat", "after_leaderboard")
	
func show_win_leaderboard():
	$leaderboard_win.show()
	
	$leaderboard_win/LeaderboardLabel/label_name.text = str(Dialogic.VAR.player_name)
	$leaderboard_win/LeaderboardLabel/Label_point.text = str(int(Dialogic.VAR.poin_inklusif))
	$leaderboard_win/LeaderboardLabel2/Label_point2.text = str(int(Dialogic.VAR.poin_inklusif - 50))
	$leaderboard_win/LeaderboardLabel3/Label_point3.text = str(int(Dialogic.VAR.poin_inklusif - 150))
	$leaderboard_win/LeaderboardLabel4/Label_point4.text = str(int(Dialogic.VAR.poin_inklusif - 400))
	
	animation_player.play("show_win_leaderboard")
	await animation_player.animation_finished
	Dialogic.start("naik_pangkat", "after_leaderboard")

func set_tugas():
	var list_tugas = [$LaptopScreen/VBoxContainer/Tugas, $LaptopScreen/VBoxContainer/Tugas2, $LaptopScreen/VBoxContainer/Tugas3, $LaptopScreen/VBoxContainer/Tugas4, $LaptopScreen/VBoxContainer/Tugas5]
	var idx = 0
	for tugas in GlobalVar.tugas_minggu_ini.keys():
		list_tugas[idx].set_tugas(tugas, GlobalVar.tugas_minggu_ini.get(tugas).get("description"), GlobalVar.tugas_minggu_ini.get(tugas).get("status"))
		idx += 1
	
	
	


func _on_tugas_tugas_live_picked(judul: Variant) -> void:
	live_caption_minigame.set_text(judul, GlobalVar.VIDEO_SCRIPT[judul])
	live_caption_minigame.show()
func _on_tugas_tugas_dokumen_picked(judul: Variant) -> void:
	pass # Replace with function body.


func _on_live_caption_minigame_done_working() -> void:
	SceneTransition.transition()
	await SceneTransition.animation_player.animation_finished
	live_caption_minigame.hide()
	if Dialogic.signal_event.is_connected(_on_dialogic_signal):
		Dialogic.signal_event.disconnect(_on_dialogic_signal)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("after_work_" + character_name)

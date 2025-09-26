extends Node2D
var is_clicking := false
var is_dragging := false
var can_click := true
var can_drag := false
var player_name := ""
var date := 1
var date_bulan_ini := 1
var idx_title = 0
var day_list = ["SENIN", "SELASA", "RABU", "KAMIS", "JUMAT", "SABTU", "MINGGU"]
var title_list = ["Pemula Aksesibilitas", "Penjelajah Inklusi", "Penggerak Akses Setara", "Pelopor Aksesibilitas", "Jagoan Inklusif"]
var jabatan_list = ["Pegawai Magang", "Pegawai Koordinator", "Pegawai Tetap", "Pegawai Koordinator", "Pegawai Senior"]
var skor_list = [0, 25000, 50000, 75000, 100000]
var musim = ["kemarau", "hujan"]
var musim_idx = 0
var performance_score := 10000.0
var day := "SENIN"
var easy_doc_used = []
var medium_doc_used = []
var hard_doc_used = []
#var pak_anton_scene = preload("res://scene/pak_anton.tscn")
#var mbak_rani_scene = preload("res://scene/mbak_rani.tscn")
#var mbak_intan_scene = preload("res://scene/mbak_intan.tscn")
#const DOCUMENT_EASY_1 = preload("res://scene/documents/document_easy_1.tscn")
#const DOCUMENT_EASY_2 = preload("res://scene/documents/document_easy_2.tscn")
#const DOCUMENT_EASY_3 = preload("res://scene/documents/document_easy_3.tscn")
#const DOCUMENT_HARD_1 = preload("res://scene/documents/document_hard_1.tscn")
#const DOCUMENT_HARD_2 = preload("res://scene/documents/document_hard_2.tscn")
#const DOCUMENT_HARD_3 = preload("res://scene/documents/document_hard_3.tscn")
#const DOCUMENT_MEDIUM_1 = preload("res://scene/documents/document_medium_1.tscn")
#const DOCUMENT_MEDIUM_2 = preload("res://scene/documents/document_medium_2.tscn")
#const DOCUMENT_MEDIUM_3 = preload("res://scene/documents/document_medium_3.tscn")
var done_working_today := false

var interactable := []
var taman_first_time := true
func next_day():
	
	Dialogic.VAR.poin_inklusif_harian = 0
	done_working_today = false
	date += 1
	date_bulan_ini += 1
	if (date_bulan_ini == 31):
		musim_idx = (musim_idx + 1) % 2
		date_bulan_ini = 1
	day = day_list[((date - 1) % 7)]
	
	if Dialogic.VAR.can_promote:
		Dialogic.VAR.title_next = title_list[idx_title + 1] # buat dialog aruna 
	else:
		Dialogic.VAR.title_next = title_list[idx_title]
	Dialogic.VAR.jabatan = jabatan_list[idx_title]
	if idx_title < 4: # jika blm max maka bisa promote
		if Dialogic.VAR.poin_inklusif >= skor_list[idx_title + 1]:
			Dialogic.VAR.can_promote = true
		else:
			Dialogic.VAR.can_promote = false
		

func _ready() -> void:
	player_name = str(Dialogic.VAR.player_name)
	

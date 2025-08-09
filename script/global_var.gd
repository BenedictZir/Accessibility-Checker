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
var skor_list = [0, 25000, 50000, 75000, 10000]
var musim = ["kemarau", "hujan"]
var musim_idx = 0
var day := "SENIN"
var easy_remaining = []
var medium_remaining = []
var hard_remaining = []

var inclusive_point := 0
var done_working_today := false
var default_cursor = load("res://assets/cursors/cursor_default.png")
var grab_cursor = load("res://assets/cursors/cursor_grab.png")
var interactable_cursor = load("res://assets/cursors/cursor_point.png")
var interactable := []
func next_day():
	Dialogic.VAR.poin_inklusif_harian = 0
	done_working_today = false
	date += 1
	date_bulan_ini += 1
	if (date_bulan_ini == 31):
		musim_idx = (musim_idx + 1) % 2
		date_bulan_ini = 1
	day = day_list[((date - 1) % 7)]
	
func _process(delta: float) -> void:
	Dialogic.VAR.title = title_list[idx_title]
	Dialogic.VAR.jabatan = jabatan_list[idx_title]
	if Dialogic.VAR.poin_inklusif >= skor_list[idx_title]:
		Dialogic.VAR.can_promote = true
	player_name = str(Dialogic.VAR.player_name)
	if is_dragging:
		Input.set_custom_mouse_cursor(grab_cursor, Input.CURSOR_ARROW, Vector2(50, 50))
	elif is_mouse_over_button() or interactable.size() > 0:
		Input.set_custom_mouse_cursor(interactable_cursor, Input.CURSOR_ARROW, Vector2(10, 0))
	else:
		Input.set_custom_mouse_cursor(default_cursor)
		
func is_mouse_over_button() -> bool:
	var hovered = get_viewport().gui_get_hovered_control()
	if hovered != null and hovered is Button:
		if not hovered.is_disabled():
			return true
	return false

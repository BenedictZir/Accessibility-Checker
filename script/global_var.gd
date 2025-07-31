extends Node2D
var is_clicking := false
var is_dragging := false
var can_click := true
var can_drag := false
var player_name = ""
var date := 1
var day_list = ["SENIN", "SELASA", "RABU", "KAMIS", "JUMAT", "SABTU", "MINGGU"]
var day := "SENIN"
var inclusive_point := 0
var done_working_today := false
func next_day():
	done_working_today = false
	date += 1
	day = day_list[((date - 1) % 7)]

extends Node2D

@onready var date_label: Label = $date/date_label
@onready var name_label: Label = $name_box/name_label
@onready var name_top_label: Label = $name_top/name_top_label
@onready var day_label: Label = $date/day_label
@onready var title_label: Label = $title/title_label
@onready var poin_inklusif_label: Label = $title_progress/poin_inklusif_label
@onready var icon_panas: Sprite2D = $date/icon_panas
@onready var icon_hujan: Sprite2D = $date/icon_hujan

@onready var cafe_button: Button = $cafe_button
@onready var kantor_button: Button = $kantor_button
@onready var kos_button: Button = $kos_button
@onready var supermarket_button: Button = $supermarket_button
@onready var taman_button: Button = $taman_button
@onready var desc_label: Label = $desc/desc_label
@onready var title_progress: TextureProgressBar = $title_progress
@onready var poin_inklusif: Label = $title_progress/Sprite2D/poin_inklusif

const HOVER_SCALE := 1.2
const NORMAL_SCALE := 1.0
const LERP_SPEED := 25.0
const DISABLED_COLOR := Color(0.451, 0.451, 0.451)
const ENABLED_COLOR := Color(1, 1, 1)

var buttons: Array[Button] = []

func _ready() -> void:
	if GlobalVar.musim[GlobalVar.musim_idx] == "kemarau":
		icon_panas.show()
		icon_hujan.hide()
	else:
		icon_panas.hide()
		icon_hujan.show()
		
	if GlobalVar.idx_title < 4:
		title_progress.max_value = GlobalVar.skor_list[GlobalVar.idx_title + 1]
		poin_inklusif_label.text = str(int(Dialogic.VAR.poin_inklusif)) + " / " + str(GlobalVar.skor_list[GlobalVar.idx_title + 1])
	else:
		title_progress.max_value = GlobalVar.skor_list[GlobalVar.idx_title]
		poin_inklusif_label.text = str(Dialogic.VAR.poin_inklusif) + " / " + str(GlobalVar.skor_list[GlobalVar.idx_title])
	if GlobalVar.done_working_today:
		desc_label.text = "Saatnya pulang dan beristirahat"
	else:
		desc_label.text = "Hari ini mau jalan-jalan ke mana ya?"
	title_progress.value = Dialogic.VAR.poin_inklusif
		
	var is_weekend := (GlobalVar.day == "SABTU" or GlobalVar.day == "MINGGU")
	kantor_button.disabled = is_weekend
	cafe_button.disabled = not is_weekend
	supermarket_button.disabled = not is_weekend
	taman_button.disabled = not is_weekend

	buttons = [cafe_button, kantor_button, kos_button, supermarket_button, taman_button]

	for button in buttons:
		button.scale = Vector2(NORMAL_SCALE, NORMAL_SCALE)
		button.self_modulate = DISABLED_COLOR if button.disabled else ENABLED_COLOR
		await button.ready  
		button.pivot_offset = Vector2(button.size.x / 2, button.size.y)

func _process(delta: float) -> void:
	name_top_label.text = GlobalVar.player_name
	date_label.text = str(GlobalVar.date)
	name_label.text = GlobalVar.player_name
	day_label.text = GlobalVar.day
	desc_label.visible_ratio += 1.8 * delta
	for button in buttons:
		var target_scale = HOVER_SCALE if button.is_hovered() and not button.disabled else NORMAL_SCALE
		var current_scale = button.scale.x
		var new_scale = lerp(current_scale, target_scale, delta * LERP_SPEED)
		button.scale = Vector2(new_scale, new_scale)
		button.self_modulate = DISABLED_COLOR if button.disabled else ENABLED_COLOR


func _on_cafe_button_pressed() -> void:
	pass # Replace with function body.


func _on_kantor_button_pressed() -> void:
	if GlobalVar.done_working_today:
		desc_label.text = "Aku sudah bekerja keras hari ini, saatnya untuk pulang dan istirahat."
		desc_label.visible_ratio = 0
	else:
		SceneTransition.change_scene("res://scene/kantor_scene.tscn")

func _on_taman_button_pressed() -> void:
	pass # Replace with function body.


func _on_kos_button_pressed() -> void:
	if not GlobalVar.done_working_today:
		desc_label.text = "Hari baru mulai, aku harus melakukan aktivitas."
		desc_label.visible_ratio = 0
	else:
		SceneTransition.change_scene("res://scene/kos_scene.tscn")

func _on_supermarket_button_pressed() -> void:
	pass # Replace with function body.

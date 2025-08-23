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
var done_init = false
const HOVER_SCALE := 1.2
const NORMAL_SCALE := 1.0
const LERP_SPEED := 25.0
const DISABLED_COLOR := Color(0.451, 0.451, 0.451)
const ENABLED_COLOR := Color(1, 1, 1)
@onready var check_button: CheckButton = $pause_screen/Background/CheckButton

var buttons: Array[Button] = []

func _ready() -> void:
	check_button.button_pressed = GlobalAltText.alt_text_on

	desc_label.visible_ratio = 0 
	SoundManager.play_map_music()
	title_label.text = GlobalVar.title_list[GlobalVar.idx_title]
	if GlobalVar.musim[GlobalVar.musim_idx] == "kemarau":
		icon_panas.show()
		icon_hujan.hide()
	else:
		icon_panas.hide()
		icon_hujan.show()
		
	title_progress.value = 0  
	if GlobalVar.idx_title < 4:
		title_progress.max_value = GlobalVar.skor_list[GlobalVar.idx_title + 1]
		poin_inklusif_label.text = str(int(0)) + " / " + str(GlobalVar.skor_list[GlobalVar.idx_title + 1])
	else:
		title_progress.max_value = GlobalVar.skor_list[GlobalVar.idx_title]
		poin_inklusif_label.text = str(0) + " / " + str(GlobalVar.skor_list[GlobalVar.idx_title])
	if GlobalVar.done_working_today:
		desc_label.text = "Saatnya pulang dan beristirahat"
	else:
		desc_label.text = "Hari ini mau jalan-jalan ke mana ya?"
		
	var is_weekend := (GlobalVar.day == "SABTU" or GlobalVar.day == "MINGGU")
	kantor_button.disabled = is_weekend
	cafe_button.disabled = not is_weekend
	supermarket_button.disabled = not is_weekend
	taman_button.disabled = not is_weekend

	buttons = [cafe_button, kantor_button, kos_button, supermarket_button, taman_button, $pause, $pause_screen/Background/exit_credit]

	for button in buttons:
		button.scale = Vector2(NORMAL_SCALE, NORMAL_SCALE)
		button.self_modulate = DISABLED_COLOR if button.disabled else ENABLED_COLOR
		await button.ready  
		button.pivot_offset = Vector2(button.size.x / 2, button.size.y)
	
func _process(delta: float) -> void:
	name_top_label.text = str(GlobalVar.player_name)
	date_label.text = str(GlobalVar.date)
	name_label.text = str(GlobalVar.player_name)
	day_label.text = GlobalVar.day
	if done_init:
		desc_label.visible_ratio += 1.8 * delta
	for button in buttons:
		var target_scale
		if button.is_hovered() and not button.disabled and button.visible and (button.process_mode != PROCESS_MODE_DISABLED):
			target_scale = HOVER_SCALE if button.is_hovered() and not button.disabled and button.visible else NORMAL_SCALE
			if button == $pause_screen/Background/exit_credit:
				target_scale = 1.1 
			else:
				target_scale = HOVER_SCALE
		else:
			target_scale = NORMAL_SCALE
		var current_scale = button.scale.x
		var new_scale = lerp(current_scale, target_scale, delta * LERP_SPEED)
		button.scale = Vector2(new_scale, new_scale)
		button.self_modulate = DISABLED_COLOR if button.disabled else ENABLED_COLOR


func _on_cafe_button_pressed() -> void:
	desc_label.text = "Aku masih belum bisa ke sini...."
	desc_label.visible_ratio = 0


func _on_kantor_button_pressed() -> void:
	if GlobalVar.done_working_today:
		desc_label.text = "Aku sudah bekerja keras hari ini, saatnya untuk pulang dan istirahat."
		desc_label.visible_ratio = 0
	elif GlobalVar.date == 2:
		SceneTransition.change_scene("res://story_scene/scene_2_1.tscn")
	elif GlobalVar.date == 3:
		SceneTransition.change_scene("res://story_scene/scene_3_1.tscn")
	elif GlobalVar.date == 4:
		SceneTransition.change_scene("res://story_scene/scene_4_1.tscn")
	else:
		SceneTransition.change_scene("res://scene/kantor_scene.tscn")

func _on_taman_button_pressed() -> void:
	if GlobalVar.done_working_today:
		desc_label.text = "Aku sudah terlalu lelah, saatnya pulang dan beristirahat"
		desc_label.visible_ratio = 0
	else:
		SceneTransition.change_scene("res://scene/taman_scene.tscn")
		

func _on_kos_button_pressed() -> void:
	if not GlobalVar.done_working_today and not GlobalVar.day == "SABTU" and not GlobalVar.day == "MINGGU":
		desc_label.text = "Hari baru mulai, aku harus melakukan aktivitas."
		desc_label.visible_ratio = 0
	else:
		SceneTransition.change_scene("res://scene/kos_scene.tscn")

func _on_supermarket_button_pressed() -> void:
	desc_label.text = "Aku masih belum bisa ke sini...."
	desc_label.visible_ratio = 0


func init_anim_done():
	done_init = true
	var tween = create_tween()
	tween.tween_property(title_progress, "value", Dialogic.VAR.poin_inklusif, 1.0) 
	
	title_progress.value_changed.connect(func(new_value):
		if GlobalVar.idx_title < 4:
			poin_inklusif_label.text = str(int(new_value)) + " / " + str(GlobalVar.skor_list[GlobalVar.idx_title + 1])
		else:
			poin_inklusif_label.text = str(int(new_value)) + " / " + str(GlobalVar.skor_list[GlobalVar.idx_title])
	)


func _on_pause_pressed() -> void:
	for button in buttons:
		if button != $pause_screen/Background/exit_credit:
			button.process_mode = Node.PROCESS_MODE_DISABLED
	$AnimationPlayer.play("show_pause_screen")


func _on_exit_credit_pressed() -> void:
	for button in buttons:
		button.process_mode = Node.PROCESS_MODE_INHERIT
	$AnimationPlayer.play("show_pause_screen", -1, -1.0, true)


func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GlobalAltText.alt_text_on = true
	else:
		GlobalAltText.alt_text_on = false

extends Node2D

@onready var day_label: Label = $day/day_label
@onready var date_label: Label = $date/date_label
@onready var name_label: Label = $name_box/name_label

@onready var cafe_button: Button = $cafe_button
@onready var kantor_button: Button = $kantor_button
@onready var kos_button: Button = $kos_button
@onready var supermarket_button: Button = $supermarket_button
@onready var taman_button: Button = $taman_button

const HOVER_SCALE := 1.2
const NORMAL_SCALE := 1.0
const LERP_SPEED := 25.0
const DISABLED_COLOR := Color(0.451, 0.451, 0.451)
const ENABLED_COLOR := Color(1, 1, 1)

var buttons: Array[Button] = []

func _ready() -> void:
	day_label.text = GlobalVar.day
	date_label.text = str(GlobalVar.date)
	name_label.text = GlobalVar.player_name

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
	for button in buttons:
		var target_scale = HOVER_SCALE if button.is_hovered() and not button.disabled else NORMAL_SCALE
		var current_scale = button.scale.x
		var new_scale = lerp(current_scale, target_scale, delta * LERP_SPEED)
		button.scale = Vector2(new_scale, new_scale)
		button.self_modulate = DISABLED_COLOR if button.disabled else ENABLED_COLOR

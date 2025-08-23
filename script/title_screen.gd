extends Node2D
const HOVER_SCALE := 1.1
const NORMAL_SCALE := 1.0
const LERP_SPEED := 25.0
var buttons
@onready var check_button: CheckButton = $credit/Background/CheckButton

var player_data: PlayerData
func _ready() -> void:
	if FileAccess.file_exists("user://player_data.res"):
		player_data = ResourceLoader.load("user://player_data.res") as PlayerData
		if player_data:
			$load_button.show()
		else:
			$load_button.hide()
	else:
		$load_button.hide()
	check_button.button_pressed = GlobalAltText.alt_text_on
	SoundManager.play_title_music()
	buttons = [$play_button, $credit_button, $exit_button, $credit/Background/exit_credit]

func _process(delta: float) -> void:
	for button in buttons:
		var target_scale = HOVER_SCALE if button.is_hovered() and not button.disabled and button.visible else NORMAL_SCALE
		button.z_index = 1 if button.is_hovered() and not button.disabled else 0
		var current_scale = button.scale.x
		var new_scale = lerp(current_scale, target_scale, delta * LERP_SPEED)
		button.scale = Vector2(new_scale, new_scale)


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	SceneTransition.change_scene("res://scene/prologue.tscn")


func _on_credit_button_pressed() -> void:
	$AnimationPlayer.play("show_credit")
	$play_button.disabled = true
	$credit_button.disabled = true
	$exit_button.disabled = true
	$play_button.z_index = 0
	$credit_button.z_index = 0
	$exit_button.z_index = 0

func _on_exit_credit_pressed() -> void:
	$AnimationPlayer.play("show_credit", -1, -1.0, true)
	$play_button.disabled = false
	$credit_button.disabled = false
	$exit_button.disabled = false


func _on_check_button_pressed() -> void:
	pass # Replace with function body.


func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GlobalAltText.alt_text_on = true
	else:
		GlobalAltText.alt_text_on = false


func _load():
	Dialogic.VAR.player_name = player_data.player_name
	GlobalVar.date = player_data.date
	GlobalVar.day = player_data.day
	GlobalVar.musim_idx = player_data.musim_idx
	GlobalVar.idx_title = player_data.idx_title
	Dialogic.VAR.poin_inklusif = player_data.poin_inklusif
	GlobalVar.taman_first_time = player_data.taman_first_time
	GlobalAltText.alt_text_on = player_data.alt_text_on
	SceneTransition.change_scene("res://scene/map.tscn")

extends Node2D
var last_hovered_button: Button = null
func play_minigame_music():
	$minigame_music.play()

func play_map_music():
	$map_music.play()
func play_kantor_music():
	$kantor_music.play()
func stop_music():
	$map_music.stop()
	$minigame_music.stop()
	$kantor_music.stop()
	
func _process(delta: float) -> void:
	var hovered = get_viewport().gui_get_hovered_control()

	if hovered != null and hovered is Button:
		if not hovered.is_disabled() and hovered.visible:
			if hovered != last_hovered_button:
				$button_hover_sfx.play()
				last_hovered_button = hovered
	else:
		last_hovered_button = null
	if hovered != null and hovered is Button and Input.is_action_just_pressed("click"):
		$button_click_sfx.play()

extends Node2D
var last_hovered_button: Button = null
var typing_sfx_idx := 0

func play_minigame_music():
	$minigame_music.play()

func play_map_music():
	$map_music.play()
func play_kantor_music():
	$kantor_music.play()
func play_kos_music():
	$kos_music.play()
func stop_music():
	$map_music.stop()
	$minigame_music.stop()
	$kantor_music.stop()
	$kos_music.stop()
	$title_screen_music.stop()
	$prologue_music.stop()
	$taman_kuis_music.stop()
	$taman_music.stop()
	
func play_mult_sfx():
	$mult_sfx.play()
func play_score_sfx():
	$score_sfx.play()
func play_typing_sfx():
	var typing_sfx = [$typing_sfx1, $typing_sfx2, $typing_sfx3, $typing_sfx4, $typing_sfx5, $typing_sfx6, $typing_sfx7, $typing_sfx8, $typing_sfx9, $typing_sfx10]
	var picked= typing_sfx[typing_sfx_idx]
	typing_sfx_idx = (typing_sfx_idx + 1) % typing_sfx.size()
	picked.pitch_scale = randf_range(0.95, 1.05)
	picked.play()
		
	
func play_prologue_music():
	$prologue_music.play()
func play_title_music():
	$title_screen_music.play()
func play_notif_sfx():
	$notif_sfx.play()
	
func play_select_obj_sfx():
	$select_obj_sfx.play()

func play_correct_answer_sfx():
	$correct_answer_sfx.play()

func play_wrong_answer_sfx():
	$wrong_answer_sfx.play()
	
func play_taman_kuis_music():
	$taman_kuis_music.play()


func play_taman_music():
	$taman_music.play()
	

	
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

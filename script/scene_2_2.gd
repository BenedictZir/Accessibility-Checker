extends Node2D
var text_clicked = false
var button_clicked = false
const DOCUMENT_SCENE_2_2 = preload("res://scene/documents/document_scene_2_2.tscn")
func _ready() -> void:
	SoundManager.play_minigame_music()
	Dialogic.start("scene_2_2")
	$level_template.is_tutorial_2 = true
	$level_template.set_document(DOCUMENT_SCENE_2_2, "easy")
	
func _on_level_template_text_clicked() -> void:
	if not text_clicked:
		text_clicked = true
		Dialogic.start("scene_2_2", "after_click_text")


func _on_level_template_done_working() -> void:
	SceneTransition.change_scene("res://story_scene/scene_2_3.tscn")


func _on_level_template_button_structure_clicked() -> void:
	if not button_clicked:
		button_clicked = true
		Dialogic.start("scene_2_2", "after_click_button")

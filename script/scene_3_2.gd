extends Node2D
const DOCUMENT_SCENE_3_2 = preload("res://scene/documents/document_scene_3_2.tscn")
func _ready() -> void:
	SoundManager.play_minigame_music()
	Dialogic.start("scene_3_2")
	$level_template.is_tutorial_3 = true
	$level_template.set_document(DOCUMENT_SCENE_3_2, "easy")
	



func _on_level_template_done_working() -> void:
	SceneTransition.change_scene("res://story_scene/scene_3_3.tscn")

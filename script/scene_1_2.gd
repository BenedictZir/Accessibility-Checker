extends Node2D
@onready var yellow_arrow: Sprite2D = $yellow_arrow

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var document = preload("res://scene/documents/document_scene_1_2.tscn")
var image_clicked = false
var wrong_alt_text = false
var done = false
func _ready() -> void:
	$level_template.is_tutorial_1 = true
	$level_template.set_document(document, "easy")
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("scene_1_2")

func _on_dialogic_signal(arg):
	if arg == "arrow_document":
		animation_player.play("arrow_document")
	elif arg == "arrow_outline":
		animation_player.play("arrow_outline")
	elif arg == "arrow_acc_checker":
		animation_player.play("arrow_acc_checker")
	elif arg == "arrow_aruna":
		animation_player.play("arrow_aruna")
	elif arg == "wait_image_clicked":
		yellow_arrow.hide()
	elif arg == "end":
		SceneTransition.change_scene("res://scene/scene_1_3.tscn")

func _process(delta: float) -> void:
	pass


func _on_level_template_image_clicked() -> void:
	if not image_clicked:
		Dialogic.start("scene_1_2", "after_click_image")
	image_clicked = true


func _on_level_template_wrong_alt_text() -> void:
	if not wrong_alt_text:
		Dialogic.start("scene_1_2", "wrong_alt_text")
	wrong_alt_text = true


func _on_level_template_tutorial_done() -> void:
	if not done:
		Dialogic.start("scene_1_2", "can_submit")
	done = true


func _on_level_template_selesai_button_clicked() -> void:
	Dialogic.start("scene_1_2", "result")
	

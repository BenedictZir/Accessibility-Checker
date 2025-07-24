extends Node2D
@onready var button: Button = $Button
@onready var images_alt: TextureRect = $images_alt

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("intro")


func _on_button_pressed() -> void:
	$images_alt/Sprite2D2.show()
	$images_alt/Label.show()
	Dialogic.start("intro", "after_button")
	
func _on_dialogic_signal(argument:):
	if argument == "show_button":
		$Button.show()
	if argument == "show_ans_box":
		$answer_box.show()
	if argument == "show_ans":
		$answers.show()
	if argument == "part2":
		$Button.show()
		$images_alt/Sprite2D2.hide()
		$images_alt/Label.hide()
		$answer_box.hide()
		$answers.hide()


func _on_button_2_pressed() -> void:
	Dialogic.start("intro", "after_submit")
	

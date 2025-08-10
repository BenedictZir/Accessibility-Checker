extends Button
@onready var label: Label = $Label
var is_correct_answer := false
var count_question := 0

signal answer_revealed
signal last_question_done

func set_answer(text, image, correctness):
	$correct_box.hide()
	$wrong_box.hide()
	count_question += 1
	if correctness:
		is_correct_answer = true
	else:
		is_correct_answer = false
		
	label.text = text
	
	if image != null:
		$TextureRect.texture = image
	



func _on_pressed() -> void:
	reveal_answer()
	
func reveal_answer():
	if is_correct_answer:
		$correct_box.show()
		SoundManager.play_correct_answer_sfx()
		Dialogic.VAR.poin_inklusif += 1000
	else:
		$wrong_box.show()
		SoundManager.play_wrong_answer_sfx()
		Dialogic.VAR.poin_inklusif += 50
	if count_question == 5:
		last_question_done.emit()
	else:
		answer_revealed.emit()

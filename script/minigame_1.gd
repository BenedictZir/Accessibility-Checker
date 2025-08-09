extends Node2D

@onready var image: TextureRect = $image
@onready var alt_text: Area2D = $alt_text
@onready var alt_text_1: Area2D = $alt_text1
@onready var alt_text_2: Area2D = $alt_text2
@onready var alt_text_3: Area2D = $alt_text3
@onready var answer_box: Area2D = $answer_box
@onready var submit: Button = $submit
var buttons
const HOVER_SCALE := 1.1
const NORMAL_SCALE := 1.0
const LERP_SPEED := 25.0

signal done
signal canceled
var alt_texts = []
func _ready() -> void:
	buttons = [$cancel, $submit]
	alt_texts.append(alt_text)
	alt_texts.append(alt_text_1)
	alt_texts.append(alt_text_2)
	alt_texts.append(alt_text_3)
func _process(delta: float) -> void:
	for button in buttons:
		var target_scale = HOVER_SCALE if button.is_hovered() and not button.disabled and button.visible else NORMAL_SCALE
		var current_scale = button.scale.x
		var new_scale = lerp(current_scale, target_scale, delta * LERP_SPEED)
		button.scale = Vector2(new_scale, new_scale)
	if answer_box.occupied_by:
		submit.show()
	else:
		submit.hide()
	
	
func init_alt_text(texts, texture, used_text):
	image.texture = texture
	for alt_text in alt_texts:
		var text = texts.pick_random()
		texts.erase(text)
		alt_text.set_text(text)


func set_alt_text_pos():
	alt_text.set_pos($Node2D.global_position)
	alt_text_1.set_pos($Node2D2.global_position)
	alt_text_2.set_pos($Node2D3.global_position)
	alt_text_3.set_pos($Node2D4.global_position)
	


func _on_cancel_pressed		() -> void:
	emit_signal("canceled")



func _on_submit_pressed() -> void:
	emit_signal("done", answer_box.get_text())
	
func reset_all_alt_texts(selected_object_text): # kembalikan yang tidak disimpan
	for alt in alt_texts:
		alt.reset()

	for alt in alt_texts:
		if alt.label.text == selected_object_text:
			alt.enter_box(answer_box)
			break

func disable_collisions():
	for alt in alt_texts:
		alt.disable_collision()

func enable_collisions():
	for alt in alt_texts:
		alt.enable_collision()

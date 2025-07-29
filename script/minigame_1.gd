extends Node2D

@onready var image: TextureRect = $image
@onready var alt_text: Area2D = $alt_text
@onready var alt_text_1: Area2D = $alt_text1
@onready var alt_text_2: Area2D = $alt_text2
@onready var alt_text_3: Area2D = $alt_text3

var alt_texts = []

func _ready() -> void:
	alt_texts.append(alt_text)
	alt_texts.append(alt_text_1)
	alt_texts.append(alt_text_2)
	alt_texts.append(alt_text_3)
	
func init_alt_text(texts, texture):
	print(texts)
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
	

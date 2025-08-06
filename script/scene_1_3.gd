extends Node2D
@onready var pak_anton: AnimatedSprite2D = $pak_anton
@onready var aruna: AnimatedSprite2D = $aruna
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("scene_1_3")
	

func _on_dialogic_signal(arg):
	pass

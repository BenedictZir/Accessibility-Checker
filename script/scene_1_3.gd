extends Node2D
@onready var pak_anton: AnimatedSprite2D = $pak_anton
@onready var aruna: AnimatedSprite2D = $aruna
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("scene_1_3")
	

func _on_dialogic_signal(arg):
	if arg == "pak_anton_join":
		animation_player.play("pak_anton_join")
	if arg == "aruna_join":
		animation_player.play("aruna_join")
		await  animation_player.animation_finished
		aruna.start_floating(aruna.position.y)

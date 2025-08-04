extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pak_anton: AnimatedSprite2D = $pak_anton
@onready var aruna: AnimatedSprite2D = $aruna

# 205, 445
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("scene_1_1")

func _on_dialogic_signal(arg):  
	if arg == "change_background":
		print("bg changed")
		$backgrounds/backrgound_1.hide()
		$backgrounds/background_2.show()
		
	if arg == "pak_anton_join":
		animation_player.play("pak_anton_join")
	if arg == "aruna_join":
		animation_player.play("aruna_join")
		await  animation_player.animation_finished
		aruna.start_floating(aruna.position.y)
	if arg == "end":
		SceneTransition.change_scene("res://scene/scene_1_2.tscn")

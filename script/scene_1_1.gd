extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pak_anton: AnimatedSprite2D = $pak_anton
@onready var aruni: AnimatedSprite2D = $aruni

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
	if arg == "pak_anton_talk":
		pak_anton.play("talk")
		
	if arg == "aruni_join":
		animation_player.play("aruni_join")
		await  animation_player.animation_finished
		aruni.start_floating(aruni.position.y)
	if arg == "aruni_happy":
		aruni.play("happy")
		

extends Node2D
@onready var pak_anton: AnimatedSprite2D = $pak_anton
@onready var aruni: AnimatedSprite2D = $aruni
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("scene_1_3")
	

func _on_dialogic_signal(arg):
	if arg == "pak_anton_join":
		animation_player.play("pak_anton_join")
	if arg == "pak_anton_talk":
		pak_anton.play("talk")
	if arg == "pak_anton_smile":
		pak_anton.play("smile")	
	if arg == "aruni_join":
		animation_player.play("aruni_join")
		await  animation_player.animation_finished
		aruni.start_floating(aruni.position.y)
	if arg == "aruni_happy":
		aruni.play("happy")

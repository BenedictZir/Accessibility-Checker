extends Node2D
@onready var arrow: Sprite2D = $arrow
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
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
		arrow.hide()
	elif arg == "image_clicked":
		arrow.show()
		animation_player.play("arrow_button")
	elif arg == "arrow_alt_text":
		animation_player.play("arrow_alt_text")

func _process(delta: float) -> void:
	pass


func _on_level_template_image_clicked() -> void:
	Dialogic.start("scene_1_2", "after_click_image")

extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera_2d: Camera2D = $Camera2D
@onready var line: Label = $mail/line
@onready var mail_screen_3: Sprite2D = $mail/MailScreen3
@onready var mail_screen_2: Sprite2D = $mail/MailScreen2
@onready var text_edit: LineEdit = $mail/TextEdit

var blink_interval := 0.4 
var blink_timer := 0.0
var can_blink := false


func _ready() -> void:
	SoundManager.play_prologue_music()
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("prologue")
	


	
func _process(delta: float) -> void:
	if $mail/end.visible or $mail/acc_button.visible:
		$background_button.show()
	else:
		$background_button.hide()
	if text_edit.size.x >= 1155:
		text_edit.size.x = 1155
		text_edit.scroll_fit_content_width = false
	if (text_edit.text != ""):
		line.hide()

		$mail/acc_button.show()
	else:
		blink_timer += delta
		if blink_timer >= blink_interval and can_blink:
			line.visible = not line.visible
			blink_timer = 0.0
			
		$mail/acc_button.hide()
		

		
	

func _on_dialogic_signal(arg):
	if arg =="change_bg_1":
		$bg_1.hide()
		$bg_2.show()
	elif arg == "change_bg_2":
		$bg_2.hide()
		SoundManager.play_notif_sfx()
		$bg_3.show()
	elif arg == "show_mail":
		animation_player.play("show_mail")
		await animation_player.animation_finished
		can_blink = true
	


	



func _input(event: InputEvent) -> void:
	pass










func _on_acc_button_pressed() -> void:
	Dialogic.VAR.player_name = str((text_edit.text).to_upper())
	line.hide()
	text_edit.hide()
	if (mail_screen_2.visible == false):
		mail_screen_2.show()
	elif mail_screen_3.visible == false:
		mail_screen_2.hide()
		mail_screen_3.show()
		$mail/acc_button.hide()
		$mail/end.show()




func _on_end_pressed() -> void:
	SceneTransition.change_scene("res://story_scene/scene_1_1.tscn")

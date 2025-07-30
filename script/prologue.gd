extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera_2d: Camera2D = $Camera2D
@onready var skip_timer: Timer = $skip/skip_timer
@onready var skip: ProgressBar = $skip
@onready var text_edit: TextEdit = $mail/TextEdit
@onready var line: Label = $mail/line
@onready var mail_screen_3: Sprite2D = $mail/MailScreen3
@onready var mail_screen_2: Sprite2D = $mail/MailScreen2
@onready var back_button: Button = $mail/back_button

var blink_interval := 0.4 
var blink_timer := 0.0
var can_blink := false


func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("prologue")
	


	
func _process(delta: float) -> void:
	if text_edit.size.x >= 1155:
		text_edit.size.x = 1155
		text_edit.scroll_fit_content_width = false
	$mail/ColorRect.size.x = min(text_edit.size.x, 1155)
	if (text_edit.text != ""):
		line.hide()
		if (mail_screen_2.visible == false and mail_screen_3.visible == false):
			$mail/ColorRect.show()
		$mail/acc_button.show()
	else:
		blink_timer += delta
		if blink_timer >= blink_interval and can_blink:
			line.visible = not line.visible
			blink_timer = 0.0
		$mail/ColorRect.hide()
			
		$mail/acc_button.hide()
		
	if skip_timer.time_left == 0:
		skip.value = 0
	else:
		skip.value = (skip_timer.wait_time - skip_timer.time_left) / skip_timer.wait_time * 100

		
	

func _on_dialogic_signal(arg):
	if arg =="change_bg_1":
		$bg_1.hide()
		$bg_2.show()
	elif arg == "change_bg_2":
		$bg_2.hide()
		$bg_3.show()
	elif arg == "show_mail":
		cant_skip()
		animation_player.play("show_mail")
		await animation_player.animation_finished
		can_blink = true
	


	



func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("right_click"):
		if skip_timer.is_stopped():
			skip_timer.start()
		#print("skipping..." + str(timer.time_left))
	if Input.is_action_just_released("right_click"):
		#print("timer stopped")
		skip_timer.stop()



func _on_skip_timer_timeout() -> void:
	cant_skip()
	Dialogic.start("prologue", "skip_1")

func can_skip():
	skip.show()
	skip_timer.paused = false

func cant_skip():
	skip.hide()
	skip_timer.paused = true







func _on_acc_button_pressed() -> void:
	Dialogic.VAR.player_name = (text_edit.text).to_upper()
	line.hide()
	$mail/ColorRect.hide()
	text_edit.hide()
	if (mail_screen_2.visible == false):
		mail_screen_2.show()
		back_button.show()
	elif mail_screen_3.visible == false:
		mail_screen_2.hide()
		mail_screen_3.show()
		back_button.show()
		$mail/acc_button.hide()
		$mail/end.show()

func _on_back_button_pressed() -> void:
	if mail_screen_2.visible == true:
		$mail/acc_button.show()
		text_edit.show()
		mail_screen_2.hide()
		back_button.hide()
	elif mail_screen_3.visible == true:
		$mail/acc_button.show()
		$mail/end.hide()
		
		mail_screen_3.hide()
		mail_screen_2.show()
		


func _on_end_pressed() -> void:
	SceneTransition.change_scene("res://scene/scene_1_1.tscn")

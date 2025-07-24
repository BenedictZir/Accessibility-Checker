extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera_2d: Camera2D = $Camera2D
@onready var timer: Timer = $Timer
@onready var skip_timer: Timer = $skip/skip_timer
@onready var skip: ProgressBar = $skip
@onready var text_edit: TextEdit = $mail/TextEdit
@onready var text_edit_2: TextEdit = $mail/TextEdit2
var blink_interval := 0.4  # detik antar kedipan
var blink_timer := 0.0
var is_blinking := false
@onready var lines: Node2D = $mail/lines

var shake_fade := 5.0
var rng = RandomNumberGenerator.new()
var shake_strength := 0.0

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("prologue")
	

func apply_shake(strength, shake_duration):
	AudioManager.play("phone_vibrate_sfx")
	shake_strength = strength
	shake_fade = shake_duration
	
func _process(delta: float) -> void:
	
	if (text_edit.text != ""):
		$mail/lines.hide()
		$mail/acc_button.show()
	else:
		blink_timer += delta
		if blink_timer >= blink_interval:
			lines.visible = not lines.visible
			blink_timer = 0.0
		$mail/acc_button.hide()
		
	if skip_timer.time_left == 0:
		skip.value = 0
	else:
		skip.value = (skip_timer.wait_time - skip_timer.time_left) / skip_timer.wait_time * 100
	if (shake_strength > 0):
		if timer.is_stopped():
			timer.start()
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		camera_2d.offset = random_offset()
		
	
func random_offset():
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))	

func _on_dialogic_signal(arg):
	if arg == "reveal_phone":
		animation_player.play("phone_reveal")
		cant_skip()
	


func _on_timer_timeout() -> void:
	shake_strength =  0
	animation_player.play("turn_on_phone")
	await animation_player.animation_finished
	



func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("right_click"):
		if skip_timer.is_stopped():
			skip_timer.start()
		#print("skipping..." + str(timer.time_left))
	if Input.is_action_just_released("right_click"):
		#print("timer stopped")
		skip_timer.stop()



func _on_skip_timer_timeout() -> void:
	Dialogic.start("prologue", "skip_1")
	cant_skip()

func can_skip():
	skip.show()
	skip_timer.paused = false

func cant_skip():
	skip.hide()
	skip_timer.paused = true


func _on_text_edit_2_text_changed() -> void:
	text_edit.text = text_edit_2.text


func _on_text_edit_text_changed() -> void:
	text_edit_2.text = text_edit.text


func _on_button_pressed() -> void:
	$phone.hide()
	$mail.show()


func _on_acc_button_pressed() -> void:
	Dialogic.VAR.player_name = text_edit.text
	print("player name: " + Dialogic.VAR.player_name)

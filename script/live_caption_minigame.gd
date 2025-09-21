extends Node2D
@onready var shadow_label: RichTextLabel = $ShadowLabel
@onready var score_label: Label = $Score
@onready var streak_timer: Timer = $StreakTimer
@onready var streak_progress: ProgressBar = $StreakProgress
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var chat_timer: Timer = $ChatTimer
@onready var live_chat_box: VBoxContainer = $LiveChatBox

@export var live_chat_scene : PackedScene
var streak_time := 8.0
var streak := 0
var streak_mult = {0: 1, 1 : 1, 2: 1.25, 3: 1.5, 4: 2, 5: 2.5, 6: 3}
var streak_requirements = {1:1, 2:1, 3:3, 4:4, 5:5, 6:6}
var streak_counter = 0

var score := 0
var score_ori_pos
var time_passed := 0.0
var float_amplitude = 5

var words = []
var cur_word_idx := 0
var cur_key_idx := 0
var cur_word := ""

var finished := false
func _ready():
	shadow_label.bbcode_enabled = true
	words = shadow_label.text.split(" ")
	cur_word = words[0]
	update_bbcode()
	
	score_ori_pos = score_label.global_position

func _process(delta):
	if streak < 2 or streak >= 4:
		chat_timer.wait_time = 2
	else:
		chat_timer.wait_time = 4
		
	
	cur_word = words[cur_word_idx]
	streak_progress.value = streak_timer.time_left
	
	time_passed += delta
	#score_label.global_position.y = score_ori_pos.y + sin(time_passed * 3.5) * float_amplitude
	

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		var key_text = event.as_text()
		if cur_key_idx >= cur_word.length() - 1 and cur_word_idx >= words.size() - 1:
			on_finish()
			return
		var target = cur_word[cur_key_idx].to_upper()

		if key_text == target:
			cur_key_idx += 1
			update_bbcode()
			if cur_key_idx == cur_word.length():
				on_word_done()

func on_word_done():
	streak_counter += 1  # Hitung kata beruntun
	if streak_counter >= streak_requirements.get(streak + 1, 1):
		streak += 1
		streak_counter = 0  # Reset counter untuk streak selanjutnya
		if streak > 3:
			animation_player.play("streak", -1, float(streak ** 1.1) / 4.0)
		streak_timer.wait_time = streak_time / streak
		streak_timer.start()
		streak_progress.show()
		streak_progress.max_value = streak_timer.wait_time
	else:
		# Jika belum cukup kata, timer tetap berjalan
		streak_timer.start()
	update_score()
	reveal_next_word()
func on_finish():
	cur_key_idx += 1
	if finished:
		return
	finished = true
	
	update_score()
	
	
	update_bbcode()

func reveal_next_word():
	cur_word_idx += 1
	cur_key_idx = 0
	cur_word = words[cur_word_idx]
	update_bbcode()

func update_bbcode():
	var bbcode = ""

	for i in range(words.size()):
		var word = words[i]

		if i < cur_word_idx:
			bbcode += "[color=#000000FF]" + word + "[/color]"
		elif i == cur_word_idx:
			for j in range(word.length()):
				var character = word[j]
				if j < cur_key_idx:
					bbcode += "[color=#000000FF]" + character + "[/color]"
				else:
					bbcode += "[color=#00000050]" + character + "[/color]"
		else:
			bbcode += "[color=#00000000]" + word + "[/color]"

		if i < words.size() - 1:
			bbcode += " "

	shadow_label.bbcode_text = bbcode


func _on_streak_timer_timeout() -> void:
	streak = 0
	streak_counter = 0
	animation_player.play("RESET")
	streak_progress.hide()

func update_score():
	score += cur_word.length() * 5 * streak_mult[streak]
	
	score_label.pivot_offset.x = score_label.size.x / 2
	score_label.text = str(score)


func _on_chat_timer_timeout() -> void:
	var live_chat = live_chat_scene.instantiate()
	live_chat_box.add_child(live_chat)
	if live_chat_box.get_child_count() > 5:
		live_chat_box.get_child(0).queue_free()
	if streak < 2:
		live_chat.set_speed("slow")
	elif streak < 5:
		live_chat.set_speed("normal")
	else:
		live_chat.set_speed("fast")

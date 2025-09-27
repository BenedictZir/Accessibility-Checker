extends Node2D
@onready var shadow_label: RichTextLabel = $ShadowLabel
@onready var score_label: Label = $Score
@onready var streak_timer: Timer = $StreakTimer
@onready var streak_progress: ProgressBar = $StreakProgress
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var chat_timer: Timer = $ChatTimer
@onready var live_chat_box: VBoxContainer = $LiveChatBox
@onready var video_duration: Timer = $VideoDuration
@onready var video_progress: TextureProgressBar = $VideoProgress
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D
@onready var error_timer: Timer = $ErrorTimer
@export var live_chat_scene : PackedScene


const VIDEO_SCRIPT = {
	0: "Warga sebuah desa di Jawa Tengah dibuat heboh oleh seekor kambing yang kabur dari kandangnya dan berjalan-jalan di pasar. Kambing itu masuk ke warung sayur dan menjatuhkan beberapa ikat kangkung. Untungnya, warga segera membantu menangkapnya. Pemilik mengatakan kambing itu memang sering iseng dan pandai membuka pintu sendiri. Peristiwa ini jadi hiburan gratis bagi pengunjung pasar. Beberapa orang merekamnya dan videonya tersebar di media sosial. Judul video yang populer adalah kambing belanja sayur sendiri.",
	1: "Kejadian unik terjadi di kota kecil di Sumatera, saat seekor ayam masuk ke kantor kelurahan. Ayam itu naik ke meja pelayanan dan berkokok keras. Pegawai yang sedang mengurus berkas terkejut, tapi kemudian tertawa bersama warga. Menurut cerita, ayam itu sering ikut pemiliknya ke pasar dekat kantor. Momen lucu ini viral karena warga mengunggah video dengan caption ayam ikut daftar KTP. Banyak orang menonton dan membagikannya, membuat hari itu jadi penuh tawa di kantor kelurahan."
}
const MAX_CHAR = 115
var sections = []
var cur_section := 0
var streak_time := 8.0
var streak := 0
var streak_mult = {0: 1, 1 : 1, 2: 1.25, 3: 1.5, 4: 2, 5: 2.5, 6: 3}
var streak_requirements = {1:1, 2:1, 3:3, 4:4, 5:5, 6:6}
var streak_counter = 0

var score := 0
var score_ori_pos
var display_score := 0
var time_passed := 0.0
var float_amplitude = 5

var is_error_active := false

var words = []
var cur_word_idx := 0
var cur_key_idx := 0
var cur_word := ""

var finished := false
func _ready():
	shadow_label.bbcode_enabled = true
	
	var text = VIDEO_SCRIPT[randi() % VIDEO_SCRIPT.size()]
	var start = 0
	while start < text.length():
		var end = min(start + MAX_CHAR, text.length())
		var part = text.substr(start, end - start)

		if end < text.length() and text[end] != " ":
			var last_space = part.rfind(" ")
			if last_space != -1:
				end = start + last_space
				part = text.substr(start, last_space)

		sections.append(part.strip_edges())  
		start = end

	if sections.size() > 0:
		words = sections[cur_section].split(" ")
		cur_word = words[0]
		update_bbcode()
	score_ori_pos = score_label.global_position


func _process(delta):
	
	video_progress.value = video_duration.wait_time - video_duration.time_left
	path_follow_2d.progress_ratio = (video_duration.wait_time - video_duration.time_left) / video_duration.wait_time
	if streak < 2 or streak >= 4:
		chat_timer.wait_time = 2
	else:
		chat_timer.wait_time = 4
		
	
	cur_word = words[cur_word_idx]
	streak_progress.value = streak_timer.time_left
	
	time_passed += delta
	
	score_label.text = str(floor(display_score))
	score_label.pivot_offset.x = score_label.size.x / 2
	#score_label.global_position.y = score_ori_pos.y + sin(time_passed * 3.5) * float_amplitude
	


	

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if finished or cur_key_idx >= cur_word.length():
			return
		SoundManager.play_typing_sfx()
		var key_text = String.chr(event.unicode).to_upper()
		var target = cur_word[cur_key_idx].to_upper()

		if key_text == target:
			is_error_active = false
			error_timer.stop()
			cur_key_idx += 1
			
			var char_pos = get_char_position(cur_word, cur_key_idx - 1)
			ParticleManager.emit_typing_particle(char_pos)
			
			update_bbcode()
			if cur_key_idx == cur_word.length():
				if cur_word_idx < words.size() - 1:
					on_word_done()
				else:
					if cur_section < sections.size() - 1:
						reveal_next_word()
					else:
						on_finish()
		else:
			if not is_error_active:
				is_error_active = true
				error_timer.start()
				update_bbcode()

func on_word_done():
	streak_counter += 1  
	if streak_counter >= streak_requirements.get(streak + 1, 1):	
		streak += 1
		streak_counter = 0  
		if streak > 3:
			animation_player.play("streak", -1, float(streak ** 1.1) / 4.0)
		streak_timer.wait_time = streak_time / streak
		streak_timer.start()
		streak_progress.show()
		streak_progress.max_value = streak_timer.wait_time
	else:
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

	if cur_word_idx >= words.size():
		cur_section += 1
		if cur_section >= sections.size():
			on_finish()
			return
		words = sections[cur_section].split(" ")
		cur_word_idx = 0
	
	cur_word = words[cur_word_idx]
	update_bbcode()


func update_bbcode():
	var bbcode = ""
	
	for i in range(words.size()):
		var word = words[i]

		if i < cur_word_idx:
			bbcode += "[color=#000000FF]" + word + "[/color]"
		elif i == cur_word_idx:
			var typed_part = word.substr(0, cur_key_idx)
			bbcode += "[color=#000000FF]" + typed_part + "[/color]"

			if cur_key_idx < word.length():
				var target_char = word[cur_key_idx]
				var remaining_after_target = word.substr(cur_key_idx + 1)
				
				if is_error_active:
					bbcode += "[color=red][shake rate=60 level=25]" + target_char + "[/shake][/color]"
				else:
					bbcode += "[color=#00000050]" + target_char + "[/color]"
				
				bbcode += "[color=#00000050]" + remaining_after_target + "[/color]"
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
	var cur_score = score + cur_word.length() * 5 * streak_mult[streak]
	var tween = create_tween()
	score_label.pivot_offset.x = score_label.size.x / 2
	tween.tween_property(self, "display_score", cur_score, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	score = cur_score
	#score_label.text = str(score)


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
		
func get_char_position(word: String, idx: int) -> Vector2:
	var font := shadow_label.get_theme_font("normal_font")
	var font_size := shadow_label.get_theme_font_size("normal_font_size")
	
	var max_width = shadow_label.size.x
	
	var current_pos := Vector2.ZERO
	
	for i in range(cur_word_idx):
		var current_word_text = words[i] + " "
		var word_size = font.get_string_size(current_word_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
		
		if current_pos.x + word_size.x > max_width:
			current_pos.x = 0
			current_pos.y += font.get_height(font_size)
		
		current_pos.x += word_size.x

	var text_in_current_word = word.substr(0, idx)
	var size_in_current_word = font.get_string_size(text_in_current_word, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	
	var current_word_total_size = font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	if current_pos.x + current_word_total_size.x > max_width:
		var remaining_x = current_pos.x
		current_pos.x = 0
		if remaining_x > 0: 
			current_pos.y += font.get_height(font_size)
	
	var char_size := font.get_char_size(word.unicode_at(idx), font_size)
	
	var final_pos_x = shadow_label.global_position.x + current_pos.x + size_in_current_word.x + (char_size.x / 2.0)
	var final_pos_y = shadow_label.global_position.y + current_pos.y + (font.get_height(font_size) / 2.0)
	
	return Vector2(final_pos_x, final_pos_y)


func _on_error_timer_timeout() -> void:
	is_error_active = false
	update_bbcode()

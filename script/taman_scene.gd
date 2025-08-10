extends Node2D
var answers = []
@onready var label: Label = $question/Label
@onready var question: Sprite2D = $question/QuestionMark
var rotation_speed := 3.0 
var rotation_amount := 0.05 
var rotation_time := 0.0
var quiz_active := false

const HOVER_SCALE := 0.9
const NORMAL_SCALE := 0.7
const LERP_SPEED := 25.0
const QUESTION_SET = [
	{
		"text": "Kalau teks di website warnanya abu-abu muda di atas latar putih, siapa yang paling kesulitan membacanya?",
		"choices": [
			{"text": "Orang yang baru bangun tidur", "image": null},
			{"text": "Orang dengan gangguan penglihatan", "image": null},
			{"text": "Orang yang lupa pakai kacamata hitam", "image": null},
			{"text": "Semua orang yang lagi di luar ruangan", "image": null}
		],
		"correct_index": 1
	},
	{
		"text": "Kalau tombol “Kirim” di aplikasi cuma bisa diklik dengan mouse, apa yang terjadi?",
		"choices": [
			{"text": "Semua orang jadi lebih cepat mengirim", "image": null},
			{"text": "Pengguna keyboard atau switch device kesulitan", "image": null},
			{"text": "Aplikasi jadi lebih aman", "image": null},
			{"text": "Tombol jadi lebih cantik", "image": null}
		],
		"correct_index": 1
	},
	{
		"text": "Kalau semua foto di website nggak punya alt text, apa yang hilang untuk tunanetra?",
		"choices": [
			{"text": "Informasi visual penting", "image": null},
			{"text": "Koneksi internet", "image": null},
			{"text": "Warna foto", "image": null},
			{"text": "Ukuran file", "image": null}
		],
		"correct_index": 0
	},
	{
		"text": "Kalau ikon tombol di aplikasi hanya berupa gambar tanpa teks penjelas, apa yang bisa terjadi?",
		"choices": [
			{"text": "Semua orang jadi lebih paham", "image": null},
			{"text": "Pengguna baru kebingungan fungsinya", "image": null},
			{"text": "Tombol jadi lebih cepat di-klik", "image": null},
			{"text": "Aplikasi lebih ringan", "image": null}
		],
		"correct_index": 1
	},
	{
		"text": "Mana kombinasi warna yang kontras?",
		"choices": [
			{"text": "", "image": "res://assets/park_quiz_image/question_1_1.png"},
			{"text": "", "image": "res://assets/park_quiz_image/question_1_2.png"},
			{"text": "", "image": "res://assets/park_quiz_image/question_1_3.png"},
			{"text": "", "image": "res://assets/park_quiz_image/question_1_4.png"}
		],
		"correct_index": 2
	},
		{
		"text": "Kalau video di website tidak punya teks terjemahan (subtitle), siapa yang dirugikan?",
		"choices": [
			{"text": "Pengguna yang sedang belajar bahasa", "image": null},
			{"text": "Pengguna dengan gangguan pendengaran", "image": null},
			{"text": "Pengguna yang suka baca cepat", "image": null},
			{"text": "Semua orang yang punya headphone", "image": null}
		],
		"correct_index": 1
	},
	{
		"text": "Kalau form pendaftaran tidak memberi tahu letak kesalahan setelah submit, apa yang terjadi?",
		"choices": [
			{"text": "Pengguna jadi tebak-tebakan salahnya di mana", "image": null},
			{"text": "Form jadi lebih singkat", "image": null},
			{"text": "Form lebih aman dari spam", "image": null},
			{"text": "Pengguna jadi langsung sukses submit", "image": null}
		],
		"correct_index": 0
	},
	{
		"text": "Kalau link di website hanya dibedakan dengan warna tanpa garis bawah, siapa yang mungkin tidak sadar kalau itu link?",
		"choices": [
			{"text": "Pengguna yang sedang buru-buru", "image": null},
			{"text": "Pengguna dengan buta warna", "image": null},
			{"text": "Pengguna yang pakai kacamata", "image": null},
			{"text": "Semua orang yang pakai ponsel", "image": null}
		],
		"correct_index": 1
	},
	{
		"text": "Kalau tombol di aplikasi terlalu kecil, siapa yang akan kesulitan mengklik?",
		"choices": [
			{"text": "Pengguna dengan jari besar", "image": null},
			{"text": "Pengguna yang pakai stylus", "image": null},
			{"text": "Pengguna dengan gangguan motorik", "image": null},
			{"text": "Semua orang yang main game", "image": null}
		],
		"correct_index": 2
	},
	{
		"text": "Tombol 'Next' hanya bisa digerakkan dengan swipe layar sentuh, siapa yang akan kesulitan?",
		"choices": [
			{"text": "Pengguna dengan gangguan motorik", "image": null},
			{"text": "Pengguna yang pakai sarung tangan", "image": null},
			{"text": "Pengguna yang pakai keyboard", "image": null},
			{"text": "Semua jawaban benar", "image": null}
		],
		"correct_index": 3
	},
		{
		"text": "Teks putih di atas latar kuning termasuk contoh apa?",
		"choices": [
			{"text": "Kontras rendah", "image": null},
			{"text": "Kontras tinggi", "image": null},
			{"text": "Desain minimalis", "image": null},
			{"text": "Aksen visual", "image": null}
		],
		"correct_index": 0
	}
]
var remaining_questions = []
func _ready() -> void:
	SoundManager.play_taman_music()
	remaining_questions = QUESTION_SET.duplicate(true)
	answers = [$taman_puzzle_answer, $taman_puzzle_answer2, $taman_puzzle_answer3, $taman_puzzle_answer4]
	Dialogic.signal_event.connect(_on_dialogic_signal)
	if (GlobalVar.taman_first_time):
		GlobalVar.taman_first_time = false
		Dialogic.start("taman_first_time")
	else:
		var ada_event 
		ada_event = randi_range(0, 1)
		if ada_event:
			Dialogic.start("taman_event")
		else:
			Dialogic.start("taman_no_event")
	
func _on_dialogic_signal(arg):
	match arg:
		"end":
			GlobalVar.done_working_today = true
			SceneTransition.change_scene("res://scene/map.tscn")
		"start_quiz":
			SoundManager.stop_music()
			SoundManager.play_taman_kuis_music()
			set_puzzle()
			quiz_active = true
			$AnimationPlayer.play("start_quiz")
		

func set_puzzle():
	if remaining_questions.size() == 0:
		remaining_questions = QUESTION_SET.duplicate(true)
		
	var index = randi_range(0, remaining_questions.size() - 1)
	var question = remaining_questions[index]
	remaining_questions.remove_at(index)
	
	label.text = question["text"]
	
	var choices = []
	for i in range(question["choices"].size()):
		var choice_data = question["choices"][i]
		var is_correct = (i == question["correct_index"])
		choices.append({
			"text": choice_data["text"],
			"image": choice_data["image"],
			"correct": is_correct
		})
	
	choices.shuffle()
	
	for i in range(answers.size()):
		var choice = choices[i]
		var image = null
		if choice["image"] != null:
			image = load(choice["image"])
		answers[i].set_answer(choice["text"], image, choice["correct"])
		
func _on_taman_puzzle_answer_answer_revealed() -> void:
	for answer in answers:
		answer.disabled = true
	await get_tree().create_timer(1.0).timeout
	for answer in answers:
		answer.disabled = false
	set_puzzle()

func _on_taman_puzzle_answer_last_question_done() -> void:
	quiz_active = false
	question.rotation = 0.0
	$AnimationPlayer.play("start_quiz", -1, -1.0, true)
	await $AnimationPlayer.animation_finished
	Dialogic.start("park_after_minigame")

func _process(delta: float) -> void:
	for answer in answers:
		var target_scale = HOVER_SCALE if answer.is_hovered() and not answer.disabled and answer.visible else NORMAL_SCALE
		var current_scale = answer.scale.x
		var new_scale = lerp(current_scale, target_scale, delta * LERP_SPEED)
		answer.scale = Vector2(new_scale, new_scale)
	if quiz_active:
		rotation_time += delta * rotation_speed
		question.rotation = sin(rotation_time) * rotation_amount
	else:
		question.rotation = 0.0

extends Control
static var used_box = []
static var last_used_box 
var speed = "slow"
var boxes = []
var box = ""
var names := [
	"Budi Setiawan", "Siti Nuraini", "Andi Saputra", "Rina Marlina", "Joko Prasetyo",
	"Putri Anggraini", "Dwi Kurniawan", "Rani Oktaviani", "Agus Santoso", "Lestari Wulandari",
	"Hendra Gunawan", "Melati Kusuma", "Rahmat Hidayat", "Ayu Kartika", "Bambang Priyono",
	"Indah Permata", "Fajar Nugroho", "Dewi Sartika", "Rizky Ramadhan", "Nur Aisyah",
	"Wahyu Firmansyah", "Maya Sari", "Arif Setiono", "Fitri Andayani", "Yudi Hartono",
	"Sri Rahayu", "Toni Wijaya", "Desi Amelia", "Bayu Kurnia", "Wulan Ayuningtyas",
	"Dedi Susanto", "Nanda Putri", "Sigit Purnomo", "Eka Lestari", "Taufik Hidayat",
	"Dini Amelia", "Ferry Pratama", "Intan Cahya", "Doni Prakoso", "Nia Rahmawati",
	"Aldi Firmansyah", "Yuni Puspita", "Heru Santosa", "Rika Marlina", "Iwan Setiadi",
	"Silvia Kartini", "Yoga Pratama", "Nurul Azizah", "Anton Suryadi", "Clara Anggun",
	"Rangga Saputra", "Bella Ayu", "Eko Wibowo", "Laila Kurnia", "Fery Susanto",
	"Dina Wulandari", "Ahmad Fauzi", "Mira Anggraeni", "Rudi Hartanto", "Sari Dewanti",
	"Guntur Adi", "Winda Aprilia", "Surya Nugraha", "Diah Kartika", "Haris Firmansyah",
	"Vina Amelia", "Bimo Santoso", "Lusia Permata", "Bayu Aditya", "Ratna Dewi",
	"Hafiz Ramadhan", "Nabila Sari", "Rangga Wibowo", "Elsa Kartika", "Andri Kurnia",
	"Della Sari", "Kevin Saputra", "Putri Maharani", "Rio Nugroho", "Shinta Aulia",
	"Aldi Prakoso", "Rika Amalia", "Dimas Putra", "Lina Kartini", "Farhan Hidayat",
	"Zahra Nuraini", "Adi Pratama", "Maya Anggun", "Ilham Santoso", "Fani Wulandari",
	"Rendy Kurniawan", "Lala Ayu", "Galih Nugraha", "Sinta Permata", "Anton Prasetya",
	"Yuni Kartika", "Doni Wibisono", "Arum Cahaya", "Yoga Saputro", "Sari Anggraini", "Paja Nanda"
]

var chats := {
	"slow": [
		"Kok delay banget sih captionnya?", "Ga jelas tulisannya…", "Captionnya ketinggalan jauh 😭",
		"Ngetiknya lama banget wkwk", "Kok typo semua ya?", "Telat terus nih",
		"Suaranya udah ganti scene, caption masih di awal", "Ngetik sambil tidur ya?",
		"Captionnya kacau, ga kebaca", "Mending manual translate aja",
		"Ini AI kalah cepet sama kamu", "Kok lambat amat",
		"Ngetiknya bikin ngantuk nungguin", "Captionnya ngelag ga sih?",
		"Delay parah sumpah", "Kok sering salah ketik sih?",
		"Kurang fokus nih caption", "Ngetiknya kayak lagi mikir lama",
		"Kenapa ga realtime ya?", "Viewer jadi bingung baca ini"
	],
	"normal": [
		"Oke sih, masih bisa kebaca", "Ya lumayan lah", "Agak telat dikit, gapapa",
		"Captionnya masih nyambung kok", "Standar aja, bisa diikuti",
		"Yaudah lah, penting ada caption", "Bisa ngerti maksudnya meski agak lambat",
		"Masih oke lah untuk streaming", "Ngetiknya cukup, ga terlalu parah",
		"Ya wajar sih agak delay", "Not bad lah", "Masih lumayan jelas",
		"Bisa dikejar kok", "Captionnya oke2 aja", "Yaudah, tetep mantap",
		"Normal aja sih kecepatannya", "Ga buruk, ga bagus", "Caption masih masuk akal kok",
		"Cukup informatif", "Santai aja, bisa dimengerti"
	],
	"fast": [
		"Gila cepet banget ngetiknya 👏", "Mantap, realtime banget", "Captionnya rapi dan jelas!",
		"Keren, ga ada typo", "Wuih, setara AI kecepatannya", "Salut sama captionernya",
		"Ini baru live captioning beneran", "Tepat banget, pas sama audio",
		"Viewer terbantu banget", "Wah, kecepatannya mantap", "Ngetiknya ngebut anjay",
		"Respect buat captionernya!", "Jarang ada typo, luar biasa",
		"Streaming jadi makin enak ditonton", "Ini sih pro level",
		"Lancar banget bacanya", "Kayak langsung sinkron sama suara",
		"Sumpah kagum sama ketikannya", "Penjelasan makin jelas dengan captionnya",
		"Perfect banget!"
	]
}

func _ready() -> void:
	boxes = [$Box1, $Box2, $Box3, $Box4]
	box = boxes.pick_random()
	if used_box.size() == 4:
		used_box.clear()
	while used_box.has(box.name) or last_used_box == box.name:
		boxes.erase(box)
		box = boxes.pick_random()
	used_box.append(box.name)
	last_used_box = box.name
func set_speed(typing_speed):
	speed = typing_speed
	set_chat()
	
func set_chat():
	var name_label = box.find_child("Name")
	name_label.text = names[randi() % names.size()]
	
	var chat_label = box.find_child("Chat")
	var chat_list = chats[speed]
	chat_label.text = chat_list[randi() % chat_list.size()]
	$AnimationPlayer.play(box.name)

extends Node2D
var is_clicking := false
var is_dragging := false
var can_click := true
var can_drag := false
var player_name := ""
var date := 1
var date_bulan_ini := 1
var idx_title = 0
var day_list = ["SENIN", "SELASA", "RABU", "KAMIS", "JUMAT", "SABTU", "MINGGU"]
var title_list = ["Pemula Aksesibilitas", "Penjelajah Inklusi", "Penggerak Akses Setara", "Pelopor Aksesibilitas", "Jagoan Inklusif"]
var jabatan_list = ["Pegawai Magang", "Pegawai Koordinator", "Pegawai Tetap", "Pegawai Koordinator", "Pegawai Senior"]
var skor_list = [0, 25000, 50000, 75000, 100000]
var musim = ["kemarau", "hujan"]
var musim_idx = 0
var performance_score := 10000.0
var day := "SENIN"
var easy_doc_used = []
var medium_doc_used = []
var hard_doc_used = []
var fired = false

var persentase_inspeksi_market = 0
var persentase_inspeksi_taman = 0
var persentase_inspeksi_cafe = 0
var list_area_inspeksi = ["market", "taman", "cafe"]

var pak_anton_scene = preload("res://scene/pak_anton.tscn")
var mbak_rani_scene = preload("res://scene/mbak_rani.tscn")
var mbak_intan_scene = preload("res://scene/mbak_intan.tscn")
#const DOCUMENT_EASY_1 = preload("res://scene/documents/document_easy_1.tscn")
#const DOCUMENT_EASY_2 = preload("res://scene/documents/document_easy_2.tscn")
#const DOCUMENT_EASY_3 = preload("res://scene/documents/document_easy_3.tscn")
#const DOCUMENT_HARD_1 = preload("res://scene/documents/document_hard_1.tscn")
#const DOCUMENT_HARD_2 = preload("res://scene/documents/document_hard_2.tscn")
#const DOCUMENT_HARD_3 = preload("res://scene/documents/document_hard_3.tscn")
#const DOCUMENT_MEDIUM_1 = preload("res://scene/documents/document_medium_1.tscn")
#const DOCUMENT_MEDIUM_2 = preload("res://scene/documents/document_medium_2.tscn")
#const DOCUMENT_MEDIUM_3 = preload("res://scene/documents/document_medium_3.tscn")

const LIST_DOCUMENT = {
	"1" : "JUDUL1",
	"2" : "JUDUL2",
	"3" : "JUDUL3"
}
# judul : skrip

const VIDEO_SCRIPT = {
	"Kambing Belanja Sayur": "Warga sebuah desa di Jawa Tengah dibuat heboh oleh seekor kambing yang kabur dari kandangnya dan berjalan-jalan di pasar. Kambing itu masuk ke warung sayur dan menjatuhkan beberapa ikat kangkung. Untungnya, warga segera membantu menangkapnya. Pemilik mengatakan kambing itu memang sering iseng dan pandai membuka pintu sendiri. Peristiwa ini jadi hiburan gratis bagi pengunjung pasar. Beberapa orang merekamnya dan videonya tersebar di media sosial. Judul video yang populer adalah kambing belanja sayur sendiri.",
	
	"Balon Lepas di Balai Desa": "Di sebuah acara syukuran desa di Jawa Timur, warga dibuat kaget sekaligus tertawa saat puluhan balon dekorasi yang dipasang di langit-langit tiba-tiba terlepas bersamaan. Balon-balon itu beterbangan dan beberapa bahkan nyangkut di kipas angin besar, membuat ruangan jadi ramai dengan suara balon meletus. Anak-anak berteriak senang sambil berusaha menangkap balon yang jatuh. Panitia acara sempat panik, tapi suasana malah berubah jadi hiburan tak terduga. Rekaman kejadian ini viral di media sosial dengan judul balon pesta kabur massal.",

	"Kucing Naik Angkot": "Di sebuah kota di Jawa Barat, penumpang angkot dibuat tertawa ketika seekor kucing tiba-tiba meloncat masuk ke dalam kendaraan. Kucing itu berjalan santai di lorong kursi, bahkan sempat duduk di pangkuan salah satu penumpang. Sopir angkot menghentikan mobil sejenak karena penumpang sibuk merekam momen tersebut. Menurut warga, kucing itu memang sering berkeliaran di sekitar terminal. Video ini viral dengan judul kucing naik angkot, membuat banyak orang terhibur dengan tingkah lucu hewan tersebut."
}

var tugas_minggu_ini = {
	
}

var done_working_today := false

var interactable := []
var taman_first_time := true
func next_day():
	
	Dialogic.VAR.poin_inklusif_harian = 0
	done_working_today = false
	date += 1
	date_bulan_ini += 1
	if (date_bulan_ini == 31):
		musim_idx = (musim_idx + 1) % 2
		date_bulan_ini = 1
	day = day_list[((date - 1) % 7)]
	if day == "SENIN":
		buat_tugas_mingguan()
	
		
		
func _process(delta: float) -> void:
	if Dialogic.VAR.can_promote:
		Dialogic.VAR.title_next = title_list[idx_title + 1] # buat dialog aruna 
	else:
		Dialogic.VAR.title_next = title_list[idx_title]
	Dialogic.VAR.jabatan = jabatan_list[idx_title]
	if idx_title < 4: # jika blm max maka bisa promote
		if Dialogic.VAR.poin_inklusif >= skor_list[idx_title + 1]:
			Dialogic.VAR.can_promote = true
		else:
			Dialogic.VAR.can_promote = false
			
		if Dialogic.VAR.poin_inklusif < skor_list[idx_title + 1] / 2.0:
			Dialogic.VAR.demote = true
			if (idx_title == 0):
				fired = true
		else:
			Dialogic.VAR.demote = false
	
	
func _ready() -> void:
	player_name = str(Dialogic.VAR.player_name)
	buat_tugas_mingguan()

func buat_tugas_mingguan():
	tugas_minggu_ini.clear()

	# 1 tugas inspeksi tiap minggu
	var area_for_inspeksi = []
	if persentase_inspeksi_market < 100:
		area_for_inspeksi.append("market")
	if persentase_inspeksi_cafe < 100:
		area_for_inspeksi.append("cafe")
	if persentase_inspeksi_taman < 100:
		area_for_inspeksi.append("taman")
		
	if not area_for_inspeksi.is_empty():
		var area_terpilih = area_for_inspeksi[randi() % area_for_inspeksi.size()]
		tugas_minggu_ini["Inspeksi Mingguan"] = {"description": "Lakukan inspeksi di " + area_terpilih, "status" : 0}

	var jumlah_video = randi() % 2 + 1 + int(area_for_inspeksi.is_empty())
	var list_judul_script = VIDEO_SCRIPT.keys()
	for i in range(jumlah_video):
		var picked_video = list_judul_script.pick_random()
		list_judul_script.erase(picked_video)
		tugas_minggu_ini[picked_video] = {"description": "Lakukan live captioning berita ini", "status" : 0}
	
	var list_document = LIST_DOCUMENT.keys()
	for i in range(5 - jumlah_video - area_for_inspeksi.size()):
		var picked_document_idx = list_document.pick_random()
		list_document.erase(picked_document_idx)
		var judul_dokumen = LIST_DOCUMENT[picked_document_idx]
		tugas_minggu_ini[judul_dokumen] = {"description": "Perbaiki aksesibilitas dokumen ini", "status" : 0}
	
	
	

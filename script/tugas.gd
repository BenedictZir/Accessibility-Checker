extends Control
@onready var deskripsi_tugas: Label = $DeskripsiTugas
@onready var judul_tugas: Label = $JudulTugas
@onready var done_icon: Sprite2D = $Icon/Done
@onready var not_done_icon: Sprite2D = $Icon/NotDone

signal tugas_dokumen_picked(judul)
signal tugas_live_picked(judul)
func set_tugas(judul, deskripsi, status):
	judul_tugas.text = judul
	deskripsi_tugas.text = deskripsi
	
	if status:
		done_icon.show()
	else:
		not_done_icon.show()
		


func _on_button_pressed() -> void:
	if judul_tugas.text.containsn("Inspeksi"):
		SceneTransition.change_scene("res://scene/map.tscn")
	elif deskripsi_tugas.text.containsn("live"):
		tugas_live_picked.emit(judul_tugas.text)
	else:
		tugas_dokumen_picked.emit(judul_tugas.text)
		

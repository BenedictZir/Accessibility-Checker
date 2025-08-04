extends Node2D

const CHARACTER_LIST = ["mbak_intan", "pak_anton", "mbak_rani"]
var pak_anton_scene = preload("res://scene/pak_anton.tscn")
var mbak_rani_scene = preload("res://scene/mbak_rani.tscn")
var mbak_intan_scene = preload("res://scene/mbak_intan.tscn")

@onready var character_node: Node2D = $character_node

var character_name = ""
var character_sprite: Node2D

func _ready() -> void:
	character_name = CHARACTER_LIST.pick_random()

	match character_name:
		"pak_anton":
			character_sprite = pak_anton_scene.instantiate()
		"mbak_rani":
			character_sprite = mbak_rani_scene.instantiate()
		"mbak_intan":
			character_sprite = mbak_intan_scene.instantiate()

	character_node.add_child(character_sprite)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start_timeline("test_signal")
	
func _on_dialogic_signal(arg):
	match arg:
		"pak_anton_ganteng":
			print("a")

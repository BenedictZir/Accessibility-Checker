extends Node2D

func _ready() -> void:
	GlobalVar.done_working_today = true
	SceneTransition.change_scene("res://scene/map.tscn")

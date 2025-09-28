extends Area2D
@export_enum("horizontal", "vertical") var hammer_type = 0
var returning := false
var start_position: Vector2
var return_speed := 12.0
var target_cell = null
@onready var hammer_animation: AnimationPlayer = $"../HammerAnimation"

func _ready() -> void:
	start_position = global_position 


func _process(delta: float) -> void:
	if returning:
		$HitArea/CollisionShape2D.disabled = true
		global_position = global_position.lerp(start_position, return_speed * delta)
		if global_position.distance_to(start_position) < 2.0:
			global_position = start_position
			returning = false
	else:
		$HitArea/CollisionShape2D.disabled = false
		
func activate():
	returning = false

func deactivate():
	returning = true

func play_swing_animation():
	await get_tree().create_timer(0.01).timeout
	if get_parent().active_hammer != self:
		return
	if (hammer_type):
		hammer_animation.play("vertical_hammer_swing")
	else:
		hammer_animation.play("horizontal_hammer_swing")
func _on_swing_finished(anim_name):
	if is_instance_valid(target_cell):
		var success = false
		if hammer_type == 0: 
			success = target_cell.break_horizontal()
		else:
			success = target_cell.break_vertical()
		if success:
			ParticleManager.emit_break_particle(global_position)


func _on_hit_area_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("cells"):
		if target_cell != null:
			var shrink_tween = create_tween()
			shrink_tween.tween_property(target_cell, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

		target_cell = area.get_parent()
		var expand_tween = create_tween()
		expand_tween.tween_property(target_cell, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		var cell_parent = target_cell.get_parent()
		cell_parent.move_child(target_cell, cell_parent.get_child_count() - 1)

	
func _on_hit_area_area_exited(area: Area2D) -> void:
	if area.get_parent() == target_cell:
		var shrink_tween = create_tween()
		shrink_tween.tween_property(target_cell, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		target_cell = null


	


func _on_mouse_entered() -> void:
	GlobalVar.interactable.append(self)


func _on_mouse_exited() -> void:
	GlobalVar.interactable.erase(self)

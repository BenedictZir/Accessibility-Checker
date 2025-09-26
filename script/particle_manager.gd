extends Node2D

func emit_50():
	$particle_50.position = to_local(get_global_mouse_position())
	$particle_50.emitting = true

func emit_1000():
	$particle_1000.position = to_local(get_global_mouse_position())
	$particle_1000.emitting = true

func emit_typing_particle(pos):
	$TypingParticle.global_position = pos
	$TypingParticle.restart()

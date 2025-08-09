extends AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_mad := false
var is_happy := false
var capek := false
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
func _process(delta: float) -> void:
	if !is_playing():
		if is_mad:
			play("angry_blink")
		elif is_happy:
			play("happy_blink")
		elif capek:
			play("capek_idle")
		else:
			play("blink")

func _on_dialogic_signal(arg):
	match arg:
		"mbak_intan_capek_idle":
			capek = true
			is_mad = false
			is_happy = false
		"mbak_intan_capek":
			capek = true
			is_mad = false
			is_happy = false
			play("capek")
		"mbak_intan_smile":
			play("smile")
		"mbak_intan_talk":
			is_happy = false
			is_mad = false
			capek = false
			play("talk")
		"mbak_intan_blink":
			is_happy = false
			is_mad = false
			capek = false
			play("blink")
		"mbak_intan_angry_blink":
			is_mad = true
			capek = false
			play("angry_blink")
		"mbak_intan_angry_talk":
			is_mad = true
			capek = false
			play("angry_talk")
		"mbak_intan_happy_blink":
			is_happy = true
			capek = false
			play("happy_blink")
		"mbak_intan_happy_talk":
			is_happy = true
			capek = false
			play("happy_talk")
		"mbak_intan_join":
			animation_player.play("join")
		"mbak_intan_leave":
			animation_player.play("leave")

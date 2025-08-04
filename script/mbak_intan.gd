extends AnimatedSprite2D

var is_mad := false
var is_happy := true
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _process(delta: float) -> void:
	if !is_playing():
		if not is_mad:
			play("blink")
		elif is_mad:
			play("angry_blink")
		elif is_happy:
			play("happy_blink")

func _on_dialogic_signal(arg):
	match arg:
		"mbak_intan_smile":
			play("smile")
		"mbak_intan_talk":
			play("talk")
		"mbak_intan_angry_blink":
			is_mad = true
			play("angry_blink")
		"mbak_intan_angry_talk":
			is_mad = true
			play("angry_talk")
		"mbak_intan_happy_blink":
			is_happy = true
			play("happy_blink")
		"mbak_intan_happy_talk":
			is_happy = true
			play("happy_talk")
			

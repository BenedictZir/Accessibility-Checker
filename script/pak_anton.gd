extends AnimatedSprite2D

var is_mad := false
var is_happy := true
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _process(delta: float) -> void:
	if !is_playing():
		if is_mad:
			play("angry_blink")
		if is_happy:
			play("happy_blink")
		else:
			play("blink")


func _on_dialogic_signal(arg):
	match arg:
		"pak_anton_smile":
			play("smile")
		"pak_anton_talk":
			play("talk")
		"pak_anton_angry_blink":
			is_mad = true
			play("angry_blink")
		"pak_anton_angry_talk":
			is_mad = true
			play("angry_talk")
		"pak_anton_happy_blink":
			is_happy = true
			play("happy_blink")
		"pak_anton_happy_talk":
			is_happy = true
			play("happy_talk")
			

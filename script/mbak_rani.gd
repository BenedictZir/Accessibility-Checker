extends AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_mad := false
var is_happy := false
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _process(delta: float) -> void:
	if !is_playing():
		if is_mad:
			play("angry_blink")
		elif is_happy:
			play("happy_blink")
		else:
			play("blink")


func _on_dialogic_signal(arg):
	match arg:
		"mbak_rani_smile":
			play("smile")
		"mbak_rani_talk":
			is_happy = false
			is_mad = false
			if animation == "talk":
				stop()
			play("talk")
		"mbak_rani_blink":
			is_happy = false
			is_mad = false
			play("blink")
		"mbak_rani_angry_blink":
			is_mad = true
			play("angry_blink")
		"mbak_rani_angry_talk":
			is_mad = true
			if animation == "angry_talk":
				stop()
			play("angry_talk")
		"mbak_rani_happy_blink":
			is_happy = true
			play("happy_blink")
		"mbak_rani_happy_talk":
			is_happy = true
			if animation == "happy_talk":
				stop()
			play("happy_talk")
		"mbak_rani_join":
			animation_player.play("join")
		"mbak_rani_leave":
			animation_player.play("leave")

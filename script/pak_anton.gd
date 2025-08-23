extends AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_mad := false
var is_happy := false
var other_people_talking = true
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _process(delta: float) -> void:
	if !is_playing():
		if other_people_talking:
			animation_player.play("hide")
		else:
			animation_player.play("hide", -1, -1.0, true)	
		if is_mad:
			play("angry_blink")
		elif is_happy:
			play("happy_blink")
		else:
			play("blink")


func _on_dialogic_signal(arg):
	match arg:
		"pak_anton_smile":
			play("smile")
		"pak_anton_talk":
			is_happy = false
			is_mad = false
			if animation == "talk":
				stop()
			play("talk")
		"pak_anton_blink":
			is_happy = false
			is_mad = false
			play("blink")
		"pak_anton_angry_blink":
			is_mad = true
			play("angry_blink")
		"pak_anton_angry_talk":
			is_mad = true
			if animation == "angry_talk":
				stop()
			play("angry_talk")
		"pak_anton_happy_blink":
			is_happy = true
			play("happy_blink")
		"pak_anton_happy_talk":
			is_happy = true
			if animation == "happy_talk":
				stop()
			play("happy_talk")
		"pak_anton_join":
			animation_player.play("join")
		"pak_anton_leave":
			animation_player.play("leave")

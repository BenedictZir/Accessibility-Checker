extends AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
const CHAR_NAME = "pak_anton"
var is_mad := false
var is_happy := false
var is_hiding := true
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
	if animation_player.is_playing():
		await animation_player.animation_finished
	if "talk" in arg or "join" in arg:
		if not CHAR_NAME in arg and not is_hiding:
			is_hiding = true

			animation_player.play("hide")
		elif CHAR_NAME in arg and is_hiding:
			is_hiding = false
			animation_player.play("hide", -1, -1.0, true)
			var parent = get_parent()
			parent.get_parent().move_child(parent, parent.get_parent().get_child_count() - 1)
			
	if animation_player.is_playing():
		await  animation_player.animation_finished
		
	match arg:
		CHAR_NAME+ "_smile":
			play("smile")
		CHAR_NAME+ "_talk":
			is_happy = false
			is_mad = false
			if animation == "talk":
				stop()
			play("talk")
		CHAR_NAME+ "_blink":
			is_happy = false
			is_mad = false
			play("blink")
		CHAR_NAME+ "_angry_blink":
			is_mad = true
			play("angry_blink")
		CHAR_NAME+ "_angry_talk":
			is_mad = true
			if animation == "angry_talk":
				stop()
			play("angry_talk")
		CHAR_NAME+ "_happy_blink":
			is_happy = true
			play("happy_blink")
		CHAR_NAME+ "_happy_talk":
			is_happy = true
			if animation == "happy_talk":
				stop()
			play("happy_talk")
		CHAR_NAME+ "_join":
			animation_player.play("join")
		CHAR_NAME+ "_leave":
			animation_player.play("leave")

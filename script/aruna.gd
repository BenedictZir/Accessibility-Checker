extends AnimatedSprite2D

var float_speed := 2.0         
var float_amplitude := 5.0     
var base_y := 0.0              
var floating := false
func _ready():
	base_y = global_position.y
	Dialogic.signal_event.connect(on_dialogic_signal)
func _process(delta: float) -> void:
	if (floating):
		var offset_y = sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_amplitude
		global_position.y = base_y + offset_y

func start_floating(pos):
	base_y = pos
	floating = true
	
func stop_floating():
	floating = false

func on_dialogic_signal(arg):
	match arg:
		"aruna_angry":
			play("angry")
		"aruna_happy":
			play("happy")
		"aruna_normal":
			play("normal")

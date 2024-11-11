extends Sprite2D
signal switched(state)

enum STATE {ON, OFF}

# Enums.
@export var switch_state: STATE = STATE.OFF
@export var text: String = "VALUE"
@onready var audio_stream_player = $AudioStreamPlayer
@onready var label = $Label


# Called when the node enters the scene tree for the first time.
func _ready():
	# ENUM is labeled based on frame # so we can set frame to STATE enum
	frame = switch_state
	label.text = text
	
func switch_on():
	switch_state = STATE.ON
	frame = switch_state

func switch_off():
	switch_state = STATE.OFF
	frame = switch_state

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.get_button_index() == 1:
		audio_stream_player.play()
		if switch_state == STATE.ON:
			switch_off()
		else: 
			switch_on()
		switched.emit(switch_state)

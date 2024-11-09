extends Node2D
@onready var bus_stop_animation_player = $BusStopAnimationPlayer
@onready var bus_door_sprite = $BusDoorSprite

var door_state_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_static_body_2d_input_event(viewport, event:InputEvent, shape_idx):
	# InputEvent 
	if event is InputEventMouseButton and event.pressed and event.get_button_index() == 1:
		print("opening door")
		if door_state_open:
			bus_door_sprite.play_backwards("Open")
		else:
			bus_door_sprite.play("Open")
		door_state_open = !door_state_open

		# highlight button
		
		pass
	pass # Replace with function body.

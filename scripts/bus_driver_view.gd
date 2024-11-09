extends Node2D
@onready var bus_stop_animation_player = $BusStopAnimationPlayer
@onready var bus_move_animation_player = $"../ExternalView/Bus/BusMoveAnimationPlayer"
@onready var bus_door_sprite = $BusDoorSprite
@onready var wind = $Wind
@onready var wind_animation: AnimationPlayer = $Wind/WindAnimation


var door_state_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	wind_animation.play_backwards("light_wind")
	bus_move_animation_player.play("bus_park")
	pass

func _process(delta):
	print(global.bus_state)
	if !bus_stop_animation_player.is_playing():
		#print("bus stopped")
		wind_animation.stop
		global.bus_state = global.BUS_STATE.STOPPED
	animate_wind()
		

func animate_wind():
	if !wind_animation.is_playing():
		#randomize wind
		#print("Wind.y before: %s" % wind.global_position)
		wind.global_position.y = randi_range(125, 360)
		wind_animation.play_backwards("light_wind")
		#print("Wind.y after: %s" % wind.global_position)

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

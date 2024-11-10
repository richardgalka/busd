extends Node2D
@onready var bus_stop_animation_player = $BusStopAnimationPlayer
@onready var bus_move_animation_player = $"../ExternalView/Bus/BusMoveAnimationPlayer"
@onready var bus_door_sprite = $BusDoorSprite
@onready var wind = $Wind
@onready var wind_animation: AnimationPlayer = $Wind/WindAnimation
@export var bus_top_speed: float = 20.0
var bus_speed: float = 0.0


var door_state_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	global.bus_state = global.BUS_STATE.MOVING
	wind_animation.play_backwards("light_wind")
	bus_move_animation_player.animation_finished.connect(bus_state_set)
	bus_move_animation_player.play("bus_park")
	pass

func bus_state_set(anim_name):
	print("Check State :%s" % str(anim_name))
	if anim_name == ":bus_park":
		print("abba")

func _process(delta):
	#if global.bus_state == global.BUS_STATE.STOPPED:
	#	print ("Bus Stopped")
	#if global.bus_state == global.BUS_STATE.MOVING:
	#	print ("Bus Moving")		
	'''
	if !bus_stop_animation_player.is_playing():
		#print("bus stopped")
		wind_animation.stop
		global.bus_state = global.BUS_STATE.STOPPED
	animate_wind()
	'''
		

func animate_wind():
	if !wind_animation.is_playing():
		#randomize wind
		#print("Wind.y before: %s" % wind.global_position)
		wind.global_position.y = randi_range(125, 360)
		wind_animation.play_backwards("light_wind")
		#print("Wind.y after: %s" % wind.global_position)

func _on_static_body_2d_input_event(_viewport, event:InputEvent, _shape_idx):
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

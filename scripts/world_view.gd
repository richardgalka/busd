extends Node2D

signal commuter_left(commuter_number:int)


@onready var bus_lights: PointLight2D = $Bus/HeadLights
@onready var bus_path_to_stop: Path2D = $BusStop/BusPathToStop
@onready var commuter_path_to_stop: Path2D = $BusStop/CommuterPathToStop
@onready var commuter_path_follow_2d: PathFollow2D = $BusStop/CommuterPathToStop/CommuterPathFollow2D
@onready var bus_stop: Node2D = $BusStop
@onready var passenger_arrive_timer: Timer = $PassengerArriveTimer
@onready var driver_view: Node2D = %DriverView

var bus_light_switch: Node2D
var bus_door_switch: Node2D

var _debug = true

var first_stop : Vector2
var last_stop : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Wait until scene tree is ready to continue
	await(get_node("/root").ready)  
	driver_view = get_node_or_null("%DriverView")
	
	# Get number of passengers from level

	_connect_switches()
	# Get last commutter stop:
	first_stop = bus_stop.global_position + bus_stop.scale.x*commuter_path_to_stop.curve.get_point_position(0)
	last_stop = bus_stop.global_position + commuter_path_to_stop.scale.x*commuter_path_to_stop.curve.get_point_position(commuter_path_to_stop.curve.point_count-1)
	




func _connect_switches() -> void:
	if get_node_or_null("%DashView"):
		bus_light_switch = %DashView.get_switch_lights_node()
		bus_door_switch = %DashView.get_switch_door_node()
		bus_light_switch.switched.connect(set_buslights)
		#bus_door_switch.switched.connect(set_busdoor)
	
func set_buslights(state):
	bus_lights.enabled = state



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

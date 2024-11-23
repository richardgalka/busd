extends Node2D

@onready var bus_lights: PointLight2D = $Bus/HeadLights
@onready var bus_path_to_stop: Path2D = $BusStop/BusPathToStop
@onready var commuter_path_to_stop: Path2D = $BusStop/CommuterPathToStop
@onready var commuter_path_follow_2d: PathFollow2D = $BusStop/CommuterPathToStop/CommuterPathFollow2D
@onready var bus_stop: Node2D = $BusStop
@onready var passenger_arrive_timer: Timer = $PassengerArriveTimer


var bus_light_switch: Node2D
var bus_door_switch: Node2D

var path_follows : Array[PathFollow2D] = []

@export var passengers_present: int = 3
@export var passengers_arriving: int = 1
@export var commuter_buffer: int = 15
const COMMUTER = preload("res://busd/characters/commuter.tscn")

var first_stop : Vector2
var last_stop : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Wait until scene tree is ready to continue
	await(get_node("/root").ready)  
	_connect_switches()
	# Get last commutter stop:
	first_stop = bus_stop.global_position + bus_stop.scale.x*commuter_path_to_stop.curve.get_point_position(0)
	last_stop = bus_stop.global_position + commuter_path_to_stop.scale.x*commuter_path_to_stop.curve.get_point_position(commuter_path_to_stop.curve.point_count-1)
	
	for n in range(passengers_present):
		var comy = _create_passenger(Vector2(last_stop.x-(commuter_buffer*n), last_stop.y), n)
		comy.scale = Vector2(2.0, 2.0)
		self.add_child(comy)
	# create passengers at busstop

## create a passenger scene at location and let them know their position in line
func _create_passenger(location, pos) -> commuter:
	var commuter_instance = COMMUTER.instantiate()
	commuter_instance.add_to_group("commuter")
	commuter_instance.global_position = location
	commuter_instance.line_position = pos
	return commuter_instance

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


func _on_passenger_arrive_timer_timeout() -> void:
	# duplicate pathfollow2d
	var commuter_num = get_tree().get_nodes_in_group("commuter").size()+1
	global.dprint(self, "Commuter Number: %s" % commuter_num)
	var new_comy = _create_passenger(first_stop, commuter_num)
	var new_comy_path = commuter_path_follow_2d.duplicate()
	commuter_path_to_stop.add_child(new_comy_path)
	new_comy_path.add_child(new_comy)
	new_comy.follow_path(new_comy_path)


	# check if we fire anymore
	if commuter_num >= passengers_arriving + passengers_present:
		passenger_arrive_timer.stop()
	

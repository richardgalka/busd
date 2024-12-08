extends Node2D

signal commuter_left(commuter_number:int)

@onready var bus_lights: PointLight2D = $Bus/HeadLights
@onready var bus_path_to_stop: Path2D = $BusStop/BusPathToStop
@onready var commuter_path_to_stop: Path2D = $BusStop/CommuterPathToStop
@onready var commuter_path_follow_2d: PathFollow2D = $BusStop/CommuterPathToStop/CommuterPathFollow2D
@onready var bus_stop: Node2D = $BusStop
@onready var passenger_arrive_timer: Timer = $PassengerArriveTimer

var bus_light_switch: Node2D
var bus_door_switch: Node2D

@export var passengers_present: int = 3
@export var passengers_arriving: int = 1
const COMMUTER = preload("res://busd/characters/commuter.tscn")
@export var ordered_commuters: Array[commuter]

var t_ordered_commuters_size = 0

var _debug = true

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
		var comy = _create_passenger(last_stop, n)
		var comy_path = commuter_path_follow_2d.duplicate()
		commuter_path_to_stop.add_child(comy_path)
		self.add_child(comy)
		comy.follow_path(comy_path, true)

	# create passengers at busstop

## create a passenger scene at location and let them know their position in line
func _create_passenger(location, pos) -> commuter:
	# Create the commuter instance and place at location
	var commuter_instance = COMMUTER.instantiate()
	# Need to add a person resource.
	commuter_instance.add_to_group("commuter")
	commuter_instance.global_position = location
	commuter_instance.line_position = pos
	#global.dprint(commuter_instance, "My position : %s" % pos)
	
	# register the commuter with our world
	commuter_instance.decided_to_leave.connect(_passenger_left)
	
	# register this world with the passenger
	self.commuter_left.connect(commuter_instance.other_comy_left)
	ordered_commuters.append(commuter_instance)
	return commuter_instance

func _passenger_left(position_num):
	global.dprint(self, "Passenger %s decided to leave" % position_num)
	# for each passenger with a > # let's ensure they move forward one place
	self.commuter_left.emit(position_num)
	# Update ordered_commuters
	ordered_commuters.pop_at(position_num)



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
	#global.dprint(self, "commuter size: %s" % ordered_commuters.size())
	if ordered_commuters.size() != t_ordered_commuters_size:
		global.dprint(self, "ordered commuters: %s" % ordered_commuters.size())
		t_ordered_commuters_size = ordered_commuters.size()
	pass


func _on_passenger_arrive_timer_timeout() -> void:
	# duplicate pathfollow2d
	var commuter_num = get_tree().get_nodes_in_group("commuter").size()
	global.dprint(self, "Commuter arriving - Number: %s" % commuter_num)
	var new_comy = _create_passenger(first_stop, commuter_num)
	#global.dprint(self, "last_stop: %s" % last_stop)
	var new_comy_path = commuter_path_follow_2d.duplicate()
	commuter_path_to_stop.add_child(new_comy_path)
	self.add_child(new_comy)
	new_comy.follow_path(new_comy_path)


	# check if we fire anymore
	if commuter_num >= passengers_arriving + passengers_present:
		passenger_arrive_timer.stop()
	
